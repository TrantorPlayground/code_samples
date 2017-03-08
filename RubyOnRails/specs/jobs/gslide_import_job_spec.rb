require 'rails_helper'

RSpec.describe GslideImportJob, type: :job do
  before(:all) do
    # Overriding paperclip to use :filesystem instead of S3 for this particular spec
    # as we need not to store all the slides preview to overload S3 limits
    @storage = Paperclip::Attachment.default_options[:storage]
    Paperclip::Attachment.default_options.merge!(
      storage: :filesystem
    )
  end

  describe 'Decks and Slides extraction from google' do
    let(:google_drive_wrapper_instance) do # We need this to call Google::Drive module functions
      class GoogleDriveWrapper; end
      GoogleDriveWrapper.include(Google::Drive)
      GoogleDriveWrapper.new
    end

    let(:user) { FactoryGirl.create(:gtoken_user) }

    let(:project) do
      project = FactoryGirl.create(:project)
      project.users << user
      project
    end

    let(:deck) { FactoryGirl.create(:deck1) }

    let(:slide) do
      FactoryGirl.create(:slide1,
                         gurl: 'https://docs.google.com/presentation/d/id/present?slide=id.p',
                         deck_id: deck.id
                        )
    end

    context 'When importing all google presentations/decks of a user' do
      it 'should enqueue a job successfully' do
        expect do
          GslideImportJob.perform_later(user)
        end.to change {
          Delayed::Job.count
        }.by(1)
      end

      it "should import all google presentations from user's google drive" do
        # Stored 2 presentations, can increase in future, but at least 2 will be there,
        # hence testing against this integer
        expect { GslideImportJob.perform_now(user) }.to change { Deck.count }.by_at_least(2)
      end
    end

    context 'When importing an incoming google slide' do
      it 'should enqueue a job successfully' do
        expect do
          GslideImportJob.perform_later(user, project, slide)
        end.to change {
          Delayed::Job.count
        }.by(1)
      end

      it 'should import an incoming slide with a valid project_id' do
        expect do
          GslideImportJob.perform_now(user, project, slide)
        end.to change {
          Slide.where.not(project_id: nil).count
        }.by(1)
      end
    end
  end
end
