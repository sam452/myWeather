class S3Manager

  require 'aws/s3'

  attr_accessor :content_folder

  def init
    puts "Initing S3."

    begin
      info = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]
    rescue Exception
      puts "Warning! Can't find YAML file. Looking for S3 creds in env vars"
      info = {}
      info["s3_key"] = ENV["AWS_ACCESS_KEY_ID"]
      info["s3_secret"] = ENV["AWS_SECRET_ACCESS_KEY"]
    end

    #need to xfer to Uniguest amazon account soon!
    AWS::S3::Base.establish_connection!(
        :access_key_id => info["s3_key"],
        :secret_access_key => info["s3_secret"]
    )
  end

  #return URL
  def store_slide_content(filename, content)
    AWS::S3::S3Object.store("customer_portal/slide_content/#{filename}", content.to_s, "web_apps", :access=> :public_read)
    obj = AWS::S3::S3Object.find "customer_portal/slide_content/#{filename}", "web_apps"
    if obj
      puts "Stored s3 obj #{filename}"
      obj
    else
      puts "ERROR! Couldn't store obj #{filename}"
      nil
    end
  end

  #return URL
  def store_user_image(filename, image)
    AWS::S3::S3Object.store("customer_portal/user_images/#{filename}", image, "web_apps", :access=> :public_read)
  end

end