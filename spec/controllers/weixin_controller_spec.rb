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
      raw_post :index, validation, Weixin.xml_gen("hello", true)
      response.headers['Content-Type'].should include "application/xml"
    end
  end

end
