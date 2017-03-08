require 'rails_helper'

RSpec.describe Api::GslidesController, type: :controller do
  describe '#completion_notifier' do
    # google_slides/:slide_id
    let(:user) do
      user = create(:user)
      user.skip_confirmation!
      user
    end
    let(:project) { create(:project) }
    let(:slide) { create('slide1', title: 'Library Slide1') }
    let(:project_slide) do
      create(:project_slide1, slide_id: slide.id,
                              project: project, assigned_to_id: user.id)
    end

    context 'When valid params are passed' do
      it 'should enqueue background job' do
        expect do
          response = get :completion_notifier, slide_id: slide.id, controller: :gslides,
                                               action: :completion_notifier,
                                               gslide_params: { project_id: project.id, user_id: user.id }
        end.to change {
          Delayed::Job.count
        }.by(1)
        expect(response.success?).to be_truthy
      end
    end

    context 'When invalid params are passed' do
      it 'should respond with 404' do
        expect do
          response = get :completion_notifier,
                          slide_id: 'wrong_id',
                          gslide_params: { project_id: 'wrong_id', user_id: 'wrong_id' }
        end.to change {
          Delayed::Job.count
        }.by(0)
        expect(response.success?).to be_falsey
      end
    end
  end
end
