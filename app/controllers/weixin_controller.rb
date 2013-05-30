class WeixinController < ApplicationController

  layout false

  def index
    render xml: Weixin.gen_response_body(request.body)
  end

end
