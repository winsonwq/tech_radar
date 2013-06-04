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
    content_id = parsed_xml["Content"]

    response_body = list_main_menu() if search_main_menu?(content_id)
    response_body = list_assessments_by_category_id(content_id) if search_categories?(content_id)
    response_body = list_technologies_by_assessment_id(content_id) if search_assessments?(content_id)
    response_body = details_of_technology(content_id) if search_technology?(content_id)

    response_body = Weixin.xml_gen response_body.strip
    response_body
  end

  private

  def self.details_of_technology(content_id)
    technology = Technology.find content_id
    "#{technology.title}\n\n#{technology.content}"
  end

  def self.list_technologies_by_assessment_id(content_id)
    response = ""
    assessment = Assessment.find content_id
    assessment.technologies.each do |tech|
      response += "#{tech.id}: #{tech.title}\n"
    end
    response
  end

  def self.list_assessments_by_category_id(content_id)
    response = ""
    category = Category.find content_id
    category.assessments.each do |assess|
      response += "#{assess.id}: #{assess.title}\n"
    end
    response
  end

  def self.list_main_menu
    response = ""
    Category.all.each do |c|
      response += "#{c.id}: #{c.title}\n"
    end
    response
  end

  def self.search_main_menu?(content_id)
    content_id.upcase == "RADAR"
  end

  def self.search_technology?(content_id)
    content_id.to_i != 0
  end

  def self.search_assessments?(content_id)
    content_id.upcase.index('A') == 0
  end

  def self.search_categories?(content_in_xml)
    content_in_xml.upcase.index('C') == 0
  end
end