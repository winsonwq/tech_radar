require 'spec_helper'

describe Weixin do

  let!(:category_descriptor) { FactoryGirl.create :node_descriptor, name: "Category" }
  let!(:name_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Title" }

  before :all do
    category_descriptor.field_descriptors.push name_field_descriptor
  end

  before :each do
    @techniques = Category.new
    @techniques.title = "Techniques"

    @languages = Category.new
    @languages.title = "Languages"
  end

  describe :xml_gen do

  end
  
  describe :gen_response_body do

    it "should return 2 categories when send 'radar'" do
      response_body = Weixin.gen_response_body(Weixin.xml_gen('radar', true))
      response_body.should include("1. Techniques\n2. Languages")
    end
  end
end