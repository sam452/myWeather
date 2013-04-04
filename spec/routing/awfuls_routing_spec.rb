require "spec_helper"

describe AwfulsController do
  describe "routing" do

    it "routes to #index" do
      get("/awfuls").should route_to("awfuls#index")
    end

    it "routes to #new" do
      get("/awfuls/new").should route_to("awfuls#new")
    end

    it "routes to #show" do
      get("/awfuls/1").should route_to("awfuls#show", :id => "1")
    end

    it "routes to #edit" do
      get("/awfuls/1/edit").should route_to("awfuls#edit", :id => "1")
    end

    it "routes to #create" do
      post("/awfuls").should route_to("awfuls#create")
    end

    it "routes to #update" do
      put("/awfuls/1").should route_to("awfuls#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/awfuls/1").should route_to("awfuls#destroy", :id => "1")
    end

  end
end
