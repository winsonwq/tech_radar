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
    return response_body unless TechRadar.local_constant_names.include? "Category"

    parsed_xml = XmlSimple.xml_in(xml, "ForceArray" => false)
    content_in_xml = parsed_xml["Content"]

    if content_in_xml == "radar"
      response_body = ""
      Category.all.each do |c|
        response_body += "#{c.id}: #{c.title}\n"
      end
    else
      response_body = ""
      if content_in_xml.index('C') == 0
        category = Category.find content_in_xml
        category.assessments.each do |assess|
          response_body += "#{assess.id}: #{assess.title}\n"
        end
      elsif content_in_xml.index('A') == 0
        assessment = Assessment.find content_in_xml
        assessment.technologies.each do |tech|
          response_body += "#{tech.id}: #{tech.title}\n"
        end
      elsif content_in_xml.to_i != 0
        technology = Technology.find content_in_xml
        response_body = "#{technology.title}\n\n#{technology.content}"
      end
    end
    response_body = Weixin.xml_gen response_body.strip
    response_body
  end
end