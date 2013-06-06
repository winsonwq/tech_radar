class WeixinController < ApplicationController

  layout false

  before_filter :validate_weixin_token

  def index
    render xml: Weixin.gen_response_body(request.body)
  end

  def validate_echostr
    render :text => params[:echostr]
  end

  private
  def validate_weixin_token
    array = [Rails.configuration.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

end
