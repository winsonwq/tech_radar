require 'spec_helper'

describe Weixin do

  let!(:category_descriptor) { FactoryGirl.create :node_descriptor, name: "Category" }
  let!(:assessment_descriptor) { FactoryGirl.create :node_descriptor, name: "Assessment" }
  let!(:technology_descriptor) { FactoryGirl.create :node_descriptor, name: "Technology" }

  let!(:id_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Id" }
  let!(:title_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Title" }
  let!(:content_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Content" }

  before :all do
    category_descriptor.field_descriptors.push title_field_descriptor
    category_descriptor.field_descriptors.push id_field_descriptor
    category_descriptor.child_node_descriptors.push assessment_descriptor
    assessment_descriptor.child_node_descriptors.push technology_descriptor

    assessment_descriptor.field_descriptors.push id_field_descriptor
    assessment_descriptor.field_descriptors.push title_field_descriptor
    technology_descriptor.field_descriptors.push id_field_descriptor
    technology_descriptor.field_descriptors.push title_field_descriptor
    technology_descriptor.field_descriptors.push content_field_descriptor

    techniques = Category.new
    techniques.title = "Techniques"
    techniques.id = "C1"

    languages = Category.new
    languages.title = "Languages"
    languages.id = "C2"

    adopt = Assessment.new
    adopt.title = "Adopt"
    adopt.id = "A2"
    languages.add adopt

    trial = Assessment.new
    trial.title = "Trial"
    trial.id = "A3"
    languages.add trial

    clojure = Technology.new
    clojure.title = "Clojure"
    clojure.id = "81"
    clojure.content = 'This is content of Clojure'
    adopt.add clojure

    css_framework = Technology.new
    css_framework.title = "CSS Framework"
    css_framework.id = "82"
    adopt.add css_framework
  end

  describe :gen_response_body do

    it "should return 2 categories when send 'radar'" do
      response_body = send_content 'rAdAr'
      response_body.should include("C1: Techniques\nC2: Languages")
    end

    it "should return children of assessment when send a category id" do
      response_body = send_content 'c2'
      response_body.should include("A2: Adopt\nA3: Trial")
    end

    it "should return children of technologies when send a assessment id" do
      response_body = send_content 'A2'
      response_body.should include("81: Clojure\n82: CSS Framework")
    end

    it "should return title and content when send a technology id" do
      response_body = send_content '81'
      response_body.should include("Clojure\n\nThis is content of Clojure")
    end

    it "should return 'Tech Radar!' back when send invalid command" do
      response_body = send_content 'c'
      response_body.should include("Tech Radar!")
    end

    it "should return 'Tech Radar!' back when send invalid tech id" do
      response_body = send_content '1'
      response_body.should include("Tech Radar!")
    end
  end
end