module TechRadar
  module TestHelpers
    def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = post(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
    end

    def send_content(text, from = "webot", to = "client")
      Weixin.gen_response_body Weixin.parse(Weixin.xml_gen(text, from, to))
    end

    def send_event(event, from = "webot", to = "client")
      body_obj = { "ToUserName" => to,
                   "FromUserName" => from,
                   "CreateTime" => DateTime.now.to_i.to_s,
                   "MsgType" => "event",
                   "Event" => event,
                   "MsgId" => "1234567890123459"
      }
      Weixin.gen_response_body Weixin.parse(body_obj.to_xml root: "xml")
    end
  end
end

RSpec.configure do |config|
  config.include TechRadar::TestHelpers
end
