require 'spec_helper'
require 'xmlsimple'

describe WeixinController do

  describe :index do
    it "should return 'world' in xml format" do
      raw_post :index, {}, Weixin.xml_gen("hello", true)
      response.body.should include("world")
    end

    it "should return 4 categories when send 'radar'" do
      raw_post :index, {}, Weixin.xml_gen("radar", true)
      message = "1. Techniques\n2. Tools\n3. Platforms\n4. Languages"
      response.body.should include(message)
    end
  end

end
