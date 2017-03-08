require 'rails_helper'

RSpec.describe Google::SlideImageProcessor do
  let(:base_temp_path) { described_class::BASE_TEMP_PATH }
  let(:user) { FactoryGirl.create(:gtoken_user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:google_deck) { FactoryGirl.create(:google_deck, user: user) }
  let(:google_slide) { FactoryGirl.create(:gslide, deck: google_deck) }
  let(:project_slide) { FactoryGirl.create(:project_slide1, user: user, slide: google_slide, project: project) }
  let(:drive_api_url_v3) { 'https://www.googleapis.com/oauth2/v3/token' }
  let(:ensure_temp_dir_not_present) do
    parent_dir_path = described_class.slide_dir_name(user.id, project_slide)
    FileUtils.rm_rf(parent_dir_path) if File.directory? parent_dir_path
  end

  describe '.initialize' do
    it 'should create directory for keeping slide images' do
      ensure_temp_dir_not_present
      gsip = described_class.new(user, project_slide)
      tmp_slide_dir = gsip.instance_variable_get(:@tmp_slide_dir)
      expect(File.directory? tmp_slide_dir).to be_truthy
    end
  end

  describe '#slide_dir_name' do
    it 'should set directory path from #slide_dir_name' do
      gsip = described_class.new(user, project_slide)
      resp = described_class.slide_dir_name(user.id, project_slide)
      expect(resp).to be_a_kind_of(String)
      expect(gsip.instance_variable_get(:@tmp_slide_dir)).to eq(base_temp_path.join(resp))
    end
  end

  describe '.get_image_paths' do
    let(:slide_export_url) { 'https://docs.google.com/presentation/d/p_id/export/png?id=p_id&pageid=pageId' }
    let(:auth_headers) { { 'Authorization' => "Bearer #{user.google_access_token}" } }

    let(:return_slide_image) do
      stub_request(:get, slide_export_url)
        .with(headers: auth_headers)
        .to_return(body: File.new('spec/fixtures/test_slide.png'), status: 200)
    end

    let(:return_unauthorized_response) do
      stub_request(:get, slide_export_url)
        .with(headers: auth_headers)
        .to_return(status: [401, 'Not Authorized'])

      stub_request(:post, drive_api_url_v3)
        .to_return(status: [200], body: { access_token: user.google_access_token }.to_json)
    end

    it 'should download image and resize to thumbnail' do
      return_slide_image
      gsip = described_class.new(user, project_slide)
      thumb_image_name, raw_image_name = gsip.get_image_paths

      img_temp_path = base_temp_path.join described_class.slide_dir_name(user.id, project_slide)
      expect(File.exist?(img_temp_path.join(raw_image_name))).to be_truthy
      expect(File.exist?(img_temp_path.join(thumb_image_name))).to be_truthy
    end

    it 'should fail to fetch images and raise RestClient::Unauthorized error' do
      return_unauthorized_response
      gsip = described_class.new(user, project_slide)
      expect { gsip.get_image_paths }.to raise_error(RestClient::Unauthorized)
      expect(WebMock).to have_requested(:post, drive_api_url_v3)
    end
  end
end
