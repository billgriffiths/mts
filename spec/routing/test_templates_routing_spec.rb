require "spec_helper"

describe TestTemplatesController do
  describe "routing" do

    it "routes to #index" do
      get("/test_templates").should route_to("test_templates#index")
    end

    it "routes to #new" do
      get("/test_templates/new").should route_to("test_templates#new")
    end

    it "routes to #show" do
      get("/test_templates/1").should route_to("test_templates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/test_templates/1/edit").should route_to("test_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/test_templates").should route_to("test_templates#create")
    end

    it "routes to #update" do
      put("/test_templates/1").should route_to("test_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/test_templates/1").should route_to("test_templates#destroy", :id => "1")
    end

  end
end
