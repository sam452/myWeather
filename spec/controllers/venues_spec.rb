require 'spec_helper'

describe VenuesController do
	#subject { post "http://pulse-dev.uniguest.com/api/handshake", {api_user_token: ENV['UNI_WEATHER_TOKEN'], api_user_id: ENV['UNI_WEATHER_USER_ID'], { 'Content-Type' => 'application/json' } } }
	
	describe "get_logo" do
		it "should return 200 from Pulse" do
		  subject
		  response.code.should == '200'
	    end

	    it "should return an access token from Pulse" do
	      subject
	      response.body.should =~ /\S{32}/
	    end
	end

end
