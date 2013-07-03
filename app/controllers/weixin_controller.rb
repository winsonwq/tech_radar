require 'xmlsimple'

class WeixinController < ApplicationController

  layout false

  before_filter :validate_weixin_token, :parse_message, :except => :technology

  def index
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST'
    response.headers['Access-Control-Max-Age'] = '60'
    render xml: Weixin.gen_response_body(@message)
  end

  def technology
    @technology = Weixin.details_of_technology(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @technology }
    end
  end


  def validate_echostr
    render :text => params[:echostr]
  end

  private

  def parse_message
    @message = Weixin.parse request.body
  end

  def validate_weixin_token
    array = [Rails.configuration.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

end
