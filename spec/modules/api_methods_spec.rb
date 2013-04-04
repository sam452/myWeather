require 'spec_helper'

describe ApiMethods do
  class DummyClass
  end

  context "PulseDev" do
     describe "get_json_api_post_response" do
       it "should return 200" do
         @dev = ApiMethods::PulseDev.new
         @dev.extend  ApiMethods::PulseDev
         pulse_credentials =   {api_user_token: ENV['UNI_WEATHER_TOKEN'], api_user_id: ENV['UNI_WEATHER_USER_ID']}
         @dev.get_json_api_post_response('/handshake', pulse_credentials)
       end
     end
   end
end