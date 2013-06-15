require 'spec_helper'
require 'xmlsimple'

include TechRadar

describe WeixinController do
  let!(:validation) do
    {:signature => "1dd201087b718bc77eb5665ebe0491050934eea5",
     :timestamp => "1370490314",
     :nonce => "1371030824"}
  end

  describe :index do
    it "should return message in xml format" do
      raw_post :index, validation, Weixin.xml_gen("hello")
      response.headers['Content-Type'].should include "application/xml"
    end
  end

  describe :session do

    before :all do
      Session.clear
    end

    it "should create session record" do
      raw_post :index, validation, Weixin.xml_gen("hello", "from", "to")
      Session.get("from")[:latest_message].should == "hello"
    end
  end

end
