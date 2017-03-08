require 'rails_helper'

RSpec.describe GslideMergeJob, type: :job do

  describe "Deck creation on google" do

    let(:google_drive_wrapper_instance) do # We need this to call Google::Drive module functions
      class GoogleDriveWrapper; end
      GoogleDriveWrapper.include(Google::Drive)
      GoogleDriveWrapper.new
    end

    let(:user) do
      FactoryGirl.create(:user, 
        email: "test@mailer.com",
        google_access_token: "access_token",
        google_refresh_token: "refresh_token",
        google_token_updated_at: Time.now - 10.days
        )
    end
    let(:project) do
      project = FactoryGirl.create(:project)
      project.users << user
      project
    end
    let(:title) { "GslideMergeJob Spec" }
    let(:slide_urls) do
      # These URls are from google drive account of the test user whose credentials are mentioned above.
      slide_http_url_1 = "https://docs.google.com/presentation/d/p1/present?slide=id.s1"
      slide_http_url_2 = "https://docs.google.com/presentation/d/p2/present?slide=id.s2"
      slide_http_url_3 = "https://docs.google.com/presentation/d/p3/present?slide=id.s3"
      slide_urls = [
                    {url: slide_http_url_1, source_position: 4, position: 2}, 
                    {url: slide_http_url_2, source_position: 2, position: 3}, 
                    {url: slide_http_url_3, source_position: 2, position: 1}
                    ]
    end

    it "should enqueue a job for GslideMergeJob" do
      expect { 
        GslideMergeJob.perform_later(slide_urls, title, user, project)
      }.to change { 
        Delayed::Job.count 
      }.by(1)
    end

    it "should create a new Google Presentation" do
      expect { GslideMergeJob.perform_now(slide_urls, title, user, project) }.to change { Deck.count }.by(1)

      deck = Deck.find_by(project_id: project.id)
      expect(deck).to be_present

      # Expect that the new google deck has been added to Google Drive by calling the API
      presentation_id = google_drive_wrapper_instance.get_presentation_id(deck.direct_url)
      headers = {"Authorization": "Bearer #{user.google_access_token}", "Content-Type": "application/json"}
      response = RestClient.get "https://www.googleapis.com/drive/v2/files/#{presentation_id}", headers rescue nil

      expect(response.code).to be(200) # Ensure that presentation has been created on Drive also

      response = JSON.parse response
      expect(response["title"]).to eq(title) # Should match title

      # Cleanup from Google
      google_drive_wrapper_instance.delete_current_presentation(presentation_id, user)
    end

  end

end
