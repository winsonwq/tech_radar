require 'spec_helper'
require 'xmlsimple'

include TechRadar

describe WeixinController do

  describe :index do

    it "should return message in xml format" do
      raw_post :index, {}, Weixin.xml_gen("hello", true)
      response.headers['Content-Type'].should include "application/xml"
    end
  end

end
