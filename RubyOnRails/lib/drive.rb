module Google
  module Drive

    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
        #retrieve new Google AccessToken if it get expired
        def refresh_access_token(user)
          access_token_age = (Time.zone.now - user.google_token_updated_at)
          if access_token_age >  APP_CONSTANTS["google_token_expire_time"]
            client_id = Rails.application.secrets.google_drive["client_id"]
            client_secret =  Rails.application.secrets.google_drive["client_secret"]
            payload = "client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{user.google_refresh_token}&grant_type=refresh_token"
            rest_resource =  RestClient::Resource.new("https://www.googleapis.com/oauth2/v3/token")
            response = rest_resource.post payload , :content_type => 'application/x-www-form-urlencoded'
            new_access_token = JSON.parse(response)["access_token"]
            # update user with new Google access token
            user.update(google_access_token: new_access_token, google_token_updated_at: Time.now)
          end
        end

        # Delete the file with the file_id from google drive using Google Drive API
        def delete_current_presentation(file_id, user)
          delete_url = "https://www.googleapis.com/drive/v2/files/#{file_id}"
          headers = { 'Authorization': "Bearer #{user.google_access_token}", 'Content-type': 'application/json' }
          rest_resource = RestClient::Resource.new(delete_url, :headers => headers)
          rest_resource.delete
        end

        # Get presentation_id from Slide or Presentation URL
        def get_presentation_id(slide_url)
          starting_index = slide_url.index("/d/")
          # Following string matching seems to be lengthy, But is faster the Regular Exp.
          ending_index = slide_url.index("/present#slide") || slide_url.index("/present?slide") || slide_url.index("/edit#slide") || slide_url.index("/edit?slide")
          return nil unless ending_index and starting_index
          presentation_id = slide_url[starting_index + 3..ending_index-1]
        end

        # Extract slide_id from google presentation/slide url
        def get_slide_id( slide_url )
          idx = slide_url.index( "=id." )
          return nil unless idx
          slide_url.slice( idx + 4..-1 )
        end

        # Returns true if page contains text matching known messages of Unauthorization
        def unauthorized?(browser_text)
          !!(browser_text.match(/unauthorized/i) || browser_text.match(/You have been signed out/i))
        end

        # You can see google presentation in 2 modes.
        # This returns string :present if slide url contains `/present?slide_id`||`/present#slide_id`
        # Or returns string :edit if slide url contains `/edit#slide_id`||`/edit?slide_id`
        def slide_url_mode(slide_url)
          return :edit if slide_url.match(/\/edit(#|\?)/)
          return :presentation if slide_url.match(/\/present(#|\?)/)
        end

        # Identifying whether it is a SlideUrl in presentation mode or Edit mode and toggles the state
        # toggle_edit_present_slide_url('edit_url') #=> present_url
        # toggle_edit_present_slide_url('present_url') #=> edit_url
        # Warning : Do not use single regex for matching, Performance issues may occur
        def toggle_edit_present_slide_url(slide_url)
          # Identifying whether it is a SlideUrl in presentation mode or Edit mode
          present_matchers = slide_url.match("/present#slide")

          case slide_url.match(/\/(present|edit)(#|\?)/).to_s
          when "/present#"
            return slide_url.gsub("/present#", "/edit#")
          when "/present?"
            # return slide_url.gsub("/present?", "/edit#")
            uri = Addressable::URI.parse(slide_url.gsub('/present?', '/edit?'))
            query_values = uri.query_values || {}
            uri.fragment = "slide=" + query_values.delete('slide') if query_values.present?
            uri.query_values = query_values.present? ? query_values : nil
            return uri.to_s
          when "/edit#", "/edit?"
            return slide_url.gsub(/\/edit(#|\?)/, "/present?")
          else
            return nil
          end
        end
      end

  end
end
