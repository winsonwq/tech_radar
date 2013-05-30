class WeixinController < ApplicationController

  layout false

  def index
    response_body = Weixin.gen_response_body(request.body)
    render xml: response_body
  end

end
