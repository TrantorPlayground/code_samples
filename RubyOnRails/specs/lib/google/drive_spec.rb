require 'rails_helper'

RSpec.describe Google::Drive do
  before(:all) do
    class GoogleDriveWrapper; end
    GoogleDriveWrapper.include(Google::Drive)
    @google_drive_wrapper_instance = GoogleDriveWrapper.new

    @slide_edit_url = 'https://docs.google.com/presentation/d/presentation_id/edit#slide=id.slide_id'
    @slide_present_url = 'https://docs.google.com/presentation/d/presentation_id/present?slide=id.slide_id'
    # Manually extracted from above URLs for verification purpose
    @related_presentation_id = 'presentation_id'
    # Manually extracted from above URLs for verification purpose
    @related_slide_id = 'slide_id'
    @browser_text = 'You have been signed out. You must sign in again to save changes to this file.\nIf you leave or reload the page, your unsaved changes may be lost.'
  end

  describe '#get_presentation_id(slide_url)' do
    context 'when url is valid' do
      it 'should return the presentation_id from given URL' do
        presentation_id = @google_drive_wrapper_instance.get_presentation_id(@slide_edit_url)
        expect(presentation_id).to eql(@related_presentation_id)
      end
    end

    context 'when url is invalid' do
      it 'should return nil' do
        expect(@google_drive_wrapper_instance.get_presentation_id('anything but a valid url')).to be_nil
      end
    end
  end

  describe '#get_slide_id(slide_url)' do
    context 'when url is valid' do
      it 'should return the slide_id from given URL' do
        slide_id = @google_drive_wrapper_instance.get_slide_id(@slide_edit_url)
        expect(slide_id).to eql(@related_slide_id)
      end
    end

    context 'when url is invalid' do
      it 'should return nil' do
        expect(@google_drive_wrapper_instance.get_slide_id('anything but a valid url')).to be_nil
      end
    end
  end

  describe '#unauthorized?(browser_text)' do
    context 'when input text contains substrings signifying unauthorised user' do
      it 'should return true' do
        expect(@google_drive_wrapper_instance.unauthorized?(@browser_text)).to be_truthy
      end
    end

    context 'when input text do not contains substrings signifying unauthorised user' do
      it 'should return false' do
        expect(@google_drive_wrapper_instance.unauthorized?('anything but signed out text')).to be_falsey
      end
    end
  end

  describe '#slide_url_mode(slide_url)' do
    context 'when input slide_url is a presentation mode url' do
      it 'should return :presentation' do
        expect(@google_drive_wrapper_instance.slide_url_mode(@slide_present_url)).to equal(:presentation)
      end
    end

    context 'when input slide_url is an edit mode url' do
      it 'should return :edit' do
        expect(@google_drive_wrapper_instance.slide_url_mode(@slide_edit_url)).to equal(:edit)
      end
    end

    context 'when input slide_url is invalid -> not a google presentation url' do
      it 'should return nil' do
        expect(@google_drive_wrapper_instance.slide_url_mode('anything but a URL')).to be_nil
      end
    end
  end

  describe '#toggle_edit_present_slide_url(slide_url)' do
    context 'when input slide_url is a presentation mode url' do
      it 'should return an Edit mode URL' do
        respone_url = @google_drive_wrapper_instance.toggle_edit_present_slide_url(@slide_present_url)
        expect(@google_drive_wrapper_instance.slide_url_mode(respone_url)).to equal(:edit)
      end
    end

    context 'when input slide_url is an edit mode url' do
      it 'should return a Presentation mode url' do
        respone_url = @google_drive_wrapper_instance.toggle_edit_present_slide_url(@slide_edit_url)
        expect(@google_drive_wrapper_instance.slide_url_mode(respone_url)).to equal(:presentation)
      end
    end

    context 'when input slide_url is invalid-not a google presentation url' do
      it 'should return nil' do
        expect(@google_drive_wrapper_instance.toggle_edit_present_slide_url('anything but a url')).to be_nil
      end
    end
  end
end
