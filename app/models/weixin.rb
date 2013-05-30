require 'xmlsimple'
include TechRadar

class Weixin

  def self.xml_gen content, send_from_client = false
    body_obj = { "ToUserName" => send_from_client ? "webot" : "client",
                 "FromUserName" => send_from_client ? "client" : "webot",
                 "CreateTime" => DateTime.now.to_i.to_s,
                 "MsgType" => "text",
                 "Content" => content,
                 "MsgId" => "1234567890123459"
    }
    body_obj.to_xml root: "xml"
  end

  def self.gen_response_body(xml)
    response_body = Weixin.xml_gen "world"
    parsed_xml = XmlSimple.xml_in(xml, "ForceArray" => false)
    if parsed_xml["Content"] == "radar"
      response_body = Weixin.xml_gen "1. Techniques\n2. Tools\n3. Platforms\n4. Languages"
    end
    response_body
  end
end