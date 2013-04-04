# To change this template, choose Tools | Templates
# and open the template in the editor.



  class ApiMethods

    include GlobalModelMethods

    API_USER_TOKEN = "7b69596bfced2b5374648ad04b7d5c46"
    API_USER_ID = 16

    def initialize
      @token_attempt_count = 0
    end

    def get_valid_templates_for_venue(venue_id)
      get_valid_templates_for_venue_or_device "venue", venue_id
    end

    def get_valid_templates_for_device(device_id)
      get_valid_templates_for_venue_or_device "device", device_id
    end


    def update_slide_content_asset(slide_id, remote_content_path)
      obj = {:entity_item => {:assets => [{:field_asset_id => 84, :remote_path => remote_content_path}]}}
      url = "/entity_items/#{slide_id}?access_token=#{access_token}"
      response = check_token_status(get_json_api_put_response(url, obj), url, method(__method__), [slide_id, remote_content_path])
      loginfo "update_slide_content_asset() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def destroy_pulse_entity_item(item_id)
      url = "/entity_items/#{item_id}?access_token=#{access_token}"
      response = check_token_status(get_json_api_delete_response(url), url, method(__method__), [item_id])
      loginfo "destroy_pulse_entity_item() Response to #{url} was successful." if response.respond_to?(:success) &&  response.success

      response
    end

    def update_pulse_entity_item(item_id, item_obj)
      url = "/entity_items/#{item_id}?access_token=#{access_token}"
      response = check_token_status(get_json_api_put_response(url, item_obj), url, method(__method__), [item_id, item_obj])
      loginfo "update_pulse_entity_item() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def create_pulse_entity_item(item_obj)
      url = "/entity_items?access_token=#{access_token}"
      response = check_token_status(get_json_api_post_response(url, item_obj), url, method(__method__), [item_obj])
      loginfo "create_pulse_entity_item() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def publish_pulse_manifest(manifest_id)
      url = "/user_manifests/#{manifest_id}/publish?access_token=#{access_token}"
      response = check_token_status(get_json_api_put_response(url), url, method(__method__), [])
      loginfo "publish_pulse_manifest() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def update_pulse_manifest(manifest_id, manifest_json)
      url = "/user_manifests/#{manifest_id}?access_token=#{access_token}"
      response = check_token_status(get_json_api_put_response(url, manifest_json), url, method(__method__), [manifest_id, manifest_json])
      loginfo "update_pulse_manifest() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def destroy_pulse_manifest(pulse_manifest_id)
      if pulse_manifest_id.nil?
        loginfo "ERROR! You must pass pulse manifest ID"
        return BaseApiToolResult.new(false)
      end

      url = "/user_manifests/#{pulse_manifest_id}"
      token = access_token #get this beforehand in case it needs to run
      response = check_token_status(get_json_api_delete_response(url, {:access_token => token}), url, method(__method__), [pulse_manifest_id])
      loginfo "destroy_pulse_manifest() Response to #{url} was successful." if response.success

      response
    end

    def create_pulse_manifest(manifest_type_id, label, targets=nil)
      loginfo "create_pulse_manifest[0] label = #{label}"

      url = "/user_manifests"
      man_hash = {:label => label, :manifest_type_id => manifest_type_id, :active => true, :targets => targets}
      obj = {:access_token => access_token, :user_manifest => man_hash}

      loginfo "create_pulse_manifest label = #{label}"

      #does the call, checks for invalid token, and recalls this method after resetting token if needed, in one step.
      response = check_token_status(get_json_api_post_response(url, obj), url, method(__method__), [manifest_type_id, label, targets])

      loginfo "create_pulse_manifest() Response to #{url} was successful." if response.success

      response
    end

    def check_token_status(existing_response, url_called, callback_method, callback_params)
      if existing_response.respond_to? :code
        case existing_response.code
          when "407", "401"
            if @token_attempt_count < 10
              loginfo "check_token_status() Response to #{url_called} failed: Token isn't fresh or is invalid. Getting new token."
              @token_attempt_count += 1
              invalidate_access_token
              puts "Our new access token is #{access_token}"

              sleep 1
              callback_method.call(*callback_params) #might call back create_pulse_manifest with all the original arguments, for example.
            else
              logerr "We can't try anymore for a token. Aborting."
              @token_attempt_count = 0
              existing_response
            end
          when "402", "403"
            logerr "Code #{existing_response.code}: Your token credentials are invalid. Unable to proceed."
            existing_response
          else
            loginfo "check_token_status() code = #{existing_response.code}"
            existing_response
        end
      else
        loginfo "check_token_status() ERROR! Unknown error #{existing_response.inspect}"
        existing_response
      end
    end

    def access_token
      if current_access_token.nil?
        loginfo "access_token() We need an access token first for the #{self.class.name} env"

        10.times do
          loginfo "Trying again to get access token..."
          token_req = get_json_api_post_response("/handshake.json", {:api_user_id => API_USER_ID, :api_user_token => API_USER_TOKEN})
          if token_req.success
            loginfo "access_token() Got token: #{token_req.result}"
            set_access_token token_req.result
            break
          else
            loginfo "access_token() Couldn't get access token, trying again in 5 seconds."
            sleep 5
          end
        end
      else
        loginfo "access_token() Using existing token: #{current_access_token}"
      end

      current_access_token
    end

    def get_json_api_post_response(url, post_obj={})
      http = EM::Synchrony.sync EventMachine::HttpRequest.new(self.base_uri+"#{url}").post(:body => post_obj)
      process_response self.class.post(url, :body => post_obj).body
      #http.callback {
       # json = JSON.parse(http.response)
      #  code = json['response']
      #}
     # http = EM::Synchrony.sync EventMachine::HttpRequest.new('http://pulse-dev.uniguest.com/api/handshake').post(:body => @j )

      #process_response self.class.post(url, :body => post_obj).body
    end

    def get_json_api_put_response(url, post_obj={})
      begin
        body = self.class.put(url, :body => post_obj).body
        process_response(body)
      rescue Exception => e
        puts "get_json_api_put_response() Exception! e = #{e.inspect}"
        return {:code => e.inspect.to_s}
      end
    end

    def get_json_api_delete_response(url, post_obj={})
      process_response self.class.delete(url, :body => post_obj).body
    end

    def get_json_api_get_response(url)
      process_response self.class.get(url).body
    end

    #leave off access code, it will add it automatically.
    def get_valid_templates_for_venue_or_device(filterable_type, id)
      filterable_type = filterable_type.downcase
      url = "/entities/76/entity_items?field_strings=true&valid_for_#{filterable_type}=#{id}"
      response = make_index_request(url, access_token)
      loginfo "get_valid_templates_for_#{filterable_type}() Response to #{url} was successful." if response.respond_to?(:success) && response.success

      response
    end

    def make_index_request(base_url, cur_access_token)
      #we will make this request but are expecting a 201 with a bkg_task_key back so we can go back from our data at a certain interval
      #if we have an access token, split it off
      base_url = base_url.split("&access_token=")[1].nil? ? base_url : base_url.split("&access_token=").first
      base_url += "&access_token=#{cur_access_token}"

      task_response = check_token_status(get_json_api_get_response(base_url), base_url,
                                         method(__method__), [base_url, access_token]) #the last param should call the getter to ensure we have a current token.

      task_key = task_response["result"]["bkg_task_key"]
      url = "#{base_url}&bkg_task_key=#{task_key}"
      loginfo "BaseApiTool.make_index_request() Making request to get assets at URL #{base_url} with key #{task_key}..waiting for results..."

      36.times do
        #check for progress.
        response = check_token_status(get_json_api_get_response(url), url, method(__method__), [base_url])

        if response.success
          return BaseApiToolResult.new(true, response["result"])
        else
          loginfo "BaseApiTool.make_index_request() Still waiting on request to come back, trying again in 10s..."
        end

        sleep 10 #wait 10s before trying again.
      end

      BaseApiToolResult.new(false, nil)
    end

    #class Unitrack < ApiMethods
    #  require 'em-http-request'
    #  format :json
    #  #base_uri "http://localhost:3003/api"
    #  base_uri "http://tracking.uniguest.com/api"
    #  #debug_output $stderr
    #end
    #
    #class PulseLocal < ApiMethods
    #  require 'em-http-request'
    #  format :json
    #  base_uri "http://localhost:3001/api"
    #  #debug_output $stderr
    #end
    #
    #class PulseOld < ApiMethods
    #  include em-http-request
    #  format :json
    #  base_uri "http://pulse.uniguest.com/api"
    #  #debug_output $stderr
    #end

    class PulseDev < ApiMethods
      require 'em-http-request'
      #format :json
      #base_uri = "http://pulse-dev.uniguest.com/api"
      def base_uri
        "http://pulse-dev.uniguest.com/api"
      end
      #debug_output $stderr
    end

    #class PulseStaging < ApiMethods
    #  include em-http-request
    #  format :json
    #  base_uri "http://pulse-staging.uniguest.com/api"
    #  #debug_output $stderr
    #end
    #
    #class PulseDemo < ApiMethods
    #  include em-http-request
    #  format :json
    #  base_uri "http://pulse-demo.uniguest.com/api"
    #  #debug_output $stderr
    #end
    #
    #class PulseProd < ApiMethods
    #  include em-http-request
    #  format :json
    #  base_uri "http://unicore-pulse-prod.herokuapp.com/api"
    #  #debug_output $stderr
    #end

    private

    def process_response(result)
      #sometimes it requires full namespace, sometimes not.
      begin
        klass = BaseApiToolResult
      rescue Exception => e
        klass = Utils::Api::BaseApiToolResult
      end
      response = ActiveSupport::JSON.decode(result)
      if response["code"].to_i == 200
        klass.new(true, response["result"], 200)
      else
        klass.new(false, response["result"], response["code"])
      end
    end

    def current_access_token
      Rails.cache.read("access_token:ibadmin")
    end

    def set_access_token(token)
      Rails.cache.write("access_token:ibadmin", token, :expires_in=>20.minutes)
    end

    def invalidate_access_token
      Rails.cache.delete("access_token:ibadmin")
    end

  end

