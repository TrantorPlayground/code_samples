module Google
  # Fetches raw slide preview and processes it into thumbnail
  class SlideImageProcessor
    include Drive

    # Parent directory path for storing images sub-directories
    BASE_TEMP_PATH = Rails.root.join('temp_slide_images')
    DIR_PREFIX = 'slide_image_dir_'.freeze
    THUMB_PREFIX = 'processed_slide_thumb_'.freeze
    RAW_IMAGE_PREFIX = 'raw_slide_thumb_'.freeze
    IMAGE_EXTENSION = '.png'.freeze

    DEFAULTS = { thumbnail_size: '150x150' }.freeze

    attr_reader :temp_thumb_path, :raw_image_path

    #
    # SlideImageProcessor.new( <user>, <project_slide> )
    #
    def initialize(user, project_slide)
      @user = user
      @project_slide = project_slide
      @slide = @project_slide.slide

      verify_thumb_dir
    end

    # .get_image_paths( '<width>x<height>'(optional) )
    def get_image_paths(dimensions = DEFAULTS[:thumbnail_size])
      set_images_path

      # Will return nil at success
      return false if fetch_raw_image

      image = MiniMagick::Image.open @raw_image_path
      begin
        image.resize dimensions
      rescue MiniMagick::Error => e
        raise "Cannot resize to #{dimensions} - #{e.message}"
      end
      image.write @temp_thumb_path
      [@temp_thumb_path.split.last, @raw_image_path.split.last]
    end

    # #slide_dir_name( <user_id>, <project_slide_object> )
    def self.slide_dir_name(user_id, project_slide)
      "#{DIR_PREFIX}#{user_id}_#{project_slide.project_id}_#{project_slide.id}"
    end

    private

    # Delete raw image
    def cleanup_raw_image
      File.delete(@raw_image_path) if File.exist?(@raw_image_path)
    end

    # Downloading slide preview from Google Docs
    def fetch_raw_image
      r_header = { 'Authorization' => "Bearer #{@user.google_access_token}" }
      response = RestClient::Request.execute(method: :get, url: slide_download_url, headers: r_header)
      img_file = File.open(@raw_image_path, 'wb')
      img_file.write response
      img_file.close
    rescue RestClient::Unauthorized => e
      puts e.inspect
      raise RestClient::Unauthorized unless re_authorize
      retry
    end

    def set_images_path
      random_string = SecureRandom.hex
      @temp_thumb_path ||= Pathname.new(@tmp_slide_dir).join("#{THUMB_PREFIX}#{random_string}#{IMAGE_EXTENSION}")
      @raw_image_path ||= Pathname.new(@tmp_slide_dir).join("#{RAW_IMAGE_PREFIX}#{random_string}#{IMAGE_EXTENSION}")
    end

    # Creates directory for keeping thumbnail
    # naming convention : <DIR_PREFIX>_<user_id>_<project_id>_<project_slide_id>
    def verify_thumb_dir
      temp_dir_name = self.class.slide_dir_name(@user.id, @project_slide)
      @tmp_slide_dir = BASE_TEMP_PATH.join(temp_dir_name)
      if File.directory? @tmp_slide_dir
        FileUtils.rm_r(Dir.glob("#{@tmp_slide_dir}/*"))
      else
        Dir.mkdir(@tmp_slide_dir)
      end
    end

    # Refresh auth token, with a retry pre-set limit
    def re_authorize
      @re_auth_tries ||= APP_CONSTANTS['authorization_tries_limit']
      return false if @re_auth_tries < 1
      refresh_access_token(@user)
      @user.reload
      @re_auth_tries -= 1
    end

    # Google Docs download url, dependent on service provider(Google Docs)
    def slide_download_url
      p_id = get_presentation_id(@slide.gurl)
      s_id = get_slide_id(@slide.gurl)
      'https://docs.google.com/presentation/d/' + p_id + '/export/png?id=' + p_id + '&pageid=' + s_id
    end
  end
end
