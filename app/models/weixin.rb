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

  def self.gen_response_body message
    xml = Weixin.xml_gen(gen_content(message), message[:to], message[:from])
    update_session message
    xml
  end


  def self.parse xml
    parsed_xml = XmlSimple.xml_in(xml, "ForceArray" => false)
    {
      to: parsed_xml["ToUserName"],
      from: parsed_xml["FromUserName"],
      content: parsed_xml["Content"].strip,
      type: parsed_xml["MsgType"],
      created_at: parsed_xml["CreateTime"]
    }
  end

  private

  def self.update_session message
    Session.safe_get(message[:from])[:latest_message] = message[:content]
  end

  def self.gen_content(message)
    msg = message[:content].upcase
    content = "Tech Radar!"
    return content.strip unless TechRadar.local_constant_names.include? "Category"
    content = main_menu() if search_main_menu?(msg)
    content = assessments_by_category_id(msg) if search_categories?(msg)
    content = technologies_by_assess_id(msg) if search_assessments?(msg)
    content = details_of_technology(msg) if search_technology?(msg)

    if search_up_level? msg
      message[:content] = retrive_up_level Session.safe_get(message[:from])[:latest_message].upcase
      content = gen_content message
    end
    content.strip
  end

  def self.retrive_up_level msg
    content = 'radar'
    content = Technology.find(msg).assessments.first.id if search_technology? msg
    content = Assessment.find(msg).categories.first.id if search_assessments? msg
    content = 'radar' if search_categories? msg
    content
  end

  def self.details_of_technology(msg)
    technology = Technology.find msg
    assessment = technology.assessments.first
    category = assessment.categories.first
    "#{category.title} - #{assessment.title} - #{technology.title}\n\n#{technology.content}"
  end

  def self.technologies_by_assess_id(msg)
    assessment = Assessment.find msg
    category = assessment.categories.first
    response = "#{category.title} - #{assessment.title}\n"
    assessment.technologies.each do |tech|
      response += "#{tech.id}: #{tech.title}\n"
    end
    response
  end

  def self.assessments_by_category_id(msg)
    category = Category.find msg
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

  def self.search_main_menu?(msg)
    msg == "RADAR"
  end

  def self.search_technology?(msg)
    (/^\d+$/i =~ msg).present? and Technology.find(msg).present?
  end

  def self.search_assessments?(msg)
    (/^A\d+$/i =~ msg).present?
  end

  def self.search_categories?(msg)
    (/^C\d+$/i =~ msg).present?
  end

  def self.search_up_level?(msg)
    (/^\*$/i =~ msg).present?
  end
end