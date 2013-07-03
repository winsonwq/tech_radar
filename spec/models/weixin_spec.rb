#encoding: utf-8
require 'spec_helper'

describe Weixin do

  let!(:category_descriptor) { FactoryGirl.create :node_descriptor, name: "Category" }
  let!(:assessment_descriptor) { FactoryGirl.create :node_descriptor, name: "Assessment" }
  let!(:technology_descriptor) { FactoryGirl.create :node_descriptor, name: "Technology" }

  let!(:id_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Id" }
  let!(:title_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Title" }
  let!(:content_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Content" }
  let!(:pic_url_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Pic_url" }
  let!(:url_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Url" }
  let!(:short_description_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Short_Description" }

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
    technology_descriptor.field_descriptors.push pic_url_field_descriptor
    technology_descriptor.field_descriptors.push url_field_descriptor
    technology_descriptor.field_descriptors.push short_description_field_descriptor

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
    clojure.short_description = 'This is content of Clojure'
    clojure.pic_url = 'http://coffeescript.org/documentation/images/logo.png'
    clojure.url = "http://coffeescript.org/"
    adopt.add clojure

    css_framework = Technology.new
    css_framework.title = "CSS Framework"
    css_framework.id = "82"
    adopt.add css_framework
  end

  describe :gen_response_body do

    it "should return 2 categories when send 'radar'" do
      body = send_content 'rAdAr'
      body.should include("C1: Techniques\nC2: Languages")
    end

    it "should return children of assessment when send a category id" do
      body = send_content 'c2'
      body.should include("A2: Adopt\nA3: Trial")
    end

    it "should return children of technologies when send a assessment id" do
      body = send_content 'A2'
      body.should include("81: Clojure\n82: CSS Framework")
    end

    it "should return title content url and picUrl when send a technology id" do
      body = send_content '81'
      body.should include "<Description>This is content of Clojure"
      body.should include("<MsgType>news</MsgType>")
      body.should include("<PicUrl>http://coffeescript.org/documentation/images/logo.png</PicUrl>")
      body.should include("<Url>http://coffeescript.org/</Url>")
    end

    it "should return 'Tech Radar!' back when send invalid command" do
      body = send_content 'c'
      body.should include("无法识别")
    end

    it "should return 'Tech Radar!' back when send invalid tech id" do
      body = send_content '1'
      body.should include("无法识别")
    end

    it "should have correct from-user and to-user" do
      body = send_content '1', 'F', 'T'
      body.should include("<ToUserName>F</ToUserName>")
      body.should include("<FromUserName>T</FromUserName>")
    end

    it "should return up-level when send '*'" do
      send_content 'a2', 'F', 'T'
      body = send_content '*', 'F', 'T'
      body.should include("A2: Adopt\nA3: Trial")
    end

    it "should return help when send '?'" do
      body = send_content '?', 'F', 'T'
      body.should include("可用命令")
    end

    it "should return welcome message when subscribe" do
      body = send_event 'subscribe', 'F', 'T'
      body.should include("欢迎")
    end
  end

  describe :parse do
    it "should parse xml message to object" do
      message = Weixin.parse Weixin.xml_gen("content", "from", "to")
      message[:from].should == "from"
      message[:to].should == "to"
      message[:content].should == "content"
      message[:type].should == "text"
    end
  end
end