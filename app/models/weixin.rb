require 'xmlsimple'
include TechRadar

class Weixin

  def self.xml_gen content, from = "client", to = "webot"
    body_obj = { "ToUserName" => to,
                 "FromUserName" => from,
                 "CreateTime" => DateTime.now.to_i.to_s,
                 "MsgType" => "text",
                 "Content" => content,
                 "MsgId" => "1234567890123459"
    }
    body_obj.to_xml root: "xml"
  end

  def self.gen_response_body(message)
    content_id = message[:content].upcase.strip
    body = "Tech Radar!"
    return Weixin.xml_gen(body.strip, message[:to], message[:from]) unless TechRadar.local_constant_names.include? "Category"

    body = main_menu() if search_main_menu?(content_id)
    body = assessments_by_category_id(content_id) if search_categories?(content_id)
    body = technologies_by_assess_id(content_id) if search_assessments?(content_id)
    body = details_of_technology(content_id) if search_technology?(content_id)

    body = Weixin.xml_gen body.strip, message[:to], message[:from]
    body
  end


  def self.parse xml
    parsed_xml = XmlSimple.xml_in(xml, "ForceArray" => false)
    {
      to: parsed_xml["ToUserName"],
      from: parsed_xml["FromUserName"],
      content: parsed_xml["Content"],
      type: parsed_xml["MsgType"],
      created_at: parsed_xml["CreateTime"]
    }
  end

  private

  def self.details_of_technology(content_id)
    technology = Technology.find content_id
    assessment = technology.assessments.first
    category = assessment.categories.first
    "#{category.title} - #{assessment.title} - #{technology.title}\n\n#{technology.content}"
  end

  def self.technologies_by_assess_id(content_id)
    assessment = Assessment.find content_id
    category = assessment.categories.first
    response = "#{category.title} - #{assessment.title}\n"
    assessment.technologies.each do |tech|
      response += "#{tech.id}: #{tech.title}\n"
    end
    response
  end

  def self.assessments_by_category_id(content_id)
    category = Category.find content_id
    response = "#{category.title}\n"
    category.assessments.each do |assess|
      response += "#{assess.id}: #{assess.title}\n"
    end
    response
  end

  def self.main_menu
    response = ""
    Category.all.each do |c|
      response += "#{c.id}: #{c.title}\n"
    end
    response
  end

  def self.search_main_menu?(content_id)
    content_id == "RADAR"
  end

  def self.search_technology?(content_id)
    (/^\d+$/ =~ content_id).present? and Technology.find(content_id).present?
  end

  def self.search_assessments?(content_id)
    (/^A\d+$/ =~ content_id).present?
  end

  def self.search_categories?(content_id)
    (/^C\d+$/ =~ content_id).present?
  end
end