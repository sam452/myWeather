class Api::VenuesController < ApplicationController
  respond_to :js, :html

  def index
    @j = {api_user_token: ENV['UNI_WEATHER_TOKEN'], api_user_id: ENV['UNI_WEATHER_USER_ID']}
    #http = EM::Synchrony.sync EventMachine::HttpRequest.new('http://pulse-dev.uniguest.com/api/handshake').post(:body => @j )
    http = ApiMethods::PulseDev.new.get_json_api_post_response('/handshake', @j)
    #http.callback {
    #  puts "req completed"
    #  json = JSON.parse(http.response)
    #  p ApiMethods
    #
    #  p json
    #  code = json['response']
    #}
    puts "rendering response"
    respond_with(http) do |format|
      format.json do
        render
      end
    end
  end

end
