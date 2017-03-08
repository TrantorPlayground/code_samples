class Api::GslidesController < ApplicationController
  # This filter will be replaced by the common API auth filter, once implemented
  before_action :authenticate_user!, except: :completion_notifier

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # google_slides should be enabled to consume the API
  require_feature :google_slides, except: :completion_notifier

  # Notifies completion of the Assigned slide
  def completion_notifier
    # TODO: Add another constraint: (assigned_to_id: current_user.id), 
    # once Authentication for API is in place
    pslide = ProjectSlide.find_by!(
                                    slide_id: params[:slide_id], 
                                    project_id: google_slide_params[:project_id]
                                  )
    user = User.find(pslide.assigned_to_id) # After authentication, use current_user instead of this line of code
    GslideImportJob.perform_later(user, pslide.project, pslide.slide)
    head :ok
  end

  # List slides assigned to `current_user`
  def list_assigned
    @assigned_project_slides = ProjectSlide.joins(:slide)
                                           .where('project_slides.project_id = ? AND project_slides.assigned_to_id = ? AND slides.gurl IS NOT ?',
                                                  list_assigned_params[:project_id], current_user, nil)
  end

  # TODO: Assumption here is that current_user already have an access_token and refresh_token
  # available, which at most can expire and we will re-authorize it.
  # Ask for google drive access if not given by the user here. <eom>
  # This returns temporary thumbnail url for assigned slide
  def assigned_slide_url
    pslide = ProjectSlide.find_by(id: params[:project_slide_id], assigned_to_id: current_user)
    gsip = Google::SlideImageProcessor.new(current_user, pslide)
    begin
      thumb_name, raw_name = gsip.get_image_paths
      @thumb_url = api_slide_temp_images_path(project_slide_id: pslide, image_name: thumb_name)
      @raw_url = api_slide_temp_images_path(project_slide_id: pslide, image_name: raw_name)
    rescue RestClient::Unauthorized => e
      head 401
    end
  end

  # This method responds to an Ajax call called within the application domain with logged in user
  # Uses Devise session, API version yet to be included
  def assigned_slide_completed
    pslide = ProjectSlide.find(assigned_slide_completed_params[:project_slide_id])
    GslideImportJob.perform_later(current_user, pslide.project, pslide.slide)

    head :ok
  end

  # Send image preview of requested slide after an authorization check
  def slide_temp_images
    pslide = ProjectSlide.includes(:slide).find(params[:project_slide_id])
    if authorize pslide.slide, :slide_assigned?
      img_location = pslide_image_path(pslide).join(params[:image_name])
      send_file img_location
    else
      head 401
    end
  end

  private

  # Derive path for temporary Slide preview image
  def pslide_image_path(pslide)
    derived_path = Google::SlideImageProcessor::BASE_TEMP_PATH
                   .join(Google::SlideImageProcessor.slide_dir_name(current_user.id, pslide))
    head 404 unless File.directory? derived_path
    derived_path
  end

  # Returns 404 status
  def not_found
    head :not_found
  end

  # StrongParams filters

  def list_assigned_params
    params.permit(:project_id)
  end

  def assigned_slide_completed_params
    params.permit(:project_slide_id)
  end

  def google_slide_params
    params.require(:gslide_params).permit(:project_id, :user_id)
  end
end
