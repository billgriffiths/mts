require "spec_helper"

describe AnswerRecordsController do
  describe "routing" do

    it "routes to #index" do
      get("/answer_records").should route_to("answer_records#index")
    end

    it "routes to #new" do
      get("/answer_records/new").should route_to("answer_records#new")
    end

    it "routes to #show" do
      get("/answer_records/1").should route_to("answer_records#show", :id => "1")
    end

    it "routes to #edit" do
      get("/answer_records/1/edit").should route_to("answer_records#edit", :id => "1")
    end

    it "routes to #create" do
      post("/answer_records").should route_to("answer_records#create")
    end

    it "routes to #update" do
      put("/answer_records/1").should route_to("answer_records#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/answer_records/1").should route_to("answer_records#destroy", :id => "1")
    end

  end
end
