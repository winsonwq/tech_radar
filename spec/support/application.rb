module ReEducation
  module TestHelpers
    def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = post(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
    end

    def send_content(text, from = "webot", to = "client")
      Weixin.gen_response_body(Weixin.xml_gen(text, from, to))
    end
  end
end

RSpec.configure do |config|
  config.include ReEducation::TestHelpers
end
