#encoding: utf-8
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

  def self.xml_gen_graphical_information article, from ="client", to = "webot"
    article_objects = {
        "item" => {
                "Title" => article[:title],
                "Description" => article[:content],
                "PicUrl" => "http://121.199.50.6/images/nodejs.png", # article[:pic_url]
                "Url" => "http://ishouldbeageek.me" #article[:url]
            }
    }

    body_obj = {"ToUserName"=>to,
                "FromUserName" => from,
                "CreateTime" => DateTime.now.to_i.to_s,
                "MsgType" => "news",
                "Content" => "",
                "ArticleCount" => "1",
                "Articles" => article_objects
    }
    body_obj.to_xml root: "xml"
  end

  def self.gen_response_body message
    if message[:event].present?
      ret = gen_content_from_event message
    else
      ret = gen_content(message)
    end
    xml = Weixin.send ret[:function_name], ret[:content], message[:to], message[:from]
    update_session message
    xml
  end

  def self.parse xml
    parsed_xml = XmlSimple.xml_in(xml, "ForceArray" => false)
    if parsed_xml["MsgType"] == "event"
      obj = {
          to: parsed_xml["ToUserName"],
          from: parsed_xml["FromUserName"],
          event: parsed_xml["Event"].strip,
          event_key: parsed_xml["EventKey"],
          type: parsed_xml["MsgType"],
          created_at: parsed_xml["CreateTime"]
      }
    else
      obj = {
          to: parsed_xml["ToUserName"],
          from: parsed_xml["FromUserName"],
          content: parsed_xml["Content"].strip,
          type: parsed_xml["MsgType"],
          created_at: parsed_xml["CreateTime"]
      }
    end
    obj
  end

  def self.update_session message
    Session.safe_get(message[:from])[:latest_message] = message[:content]
  end

  private

  def self.gen_content_from_event(message)
    event = message[:event]
    content, function_name = ["Tech Radar!", :xml_gen]
    content = welcome_message() + help_message() if is_subscribe_event?(event)
    { content: content, function_name: function_name }
  end

  def self.gen_content(message)
    msg = message[:content].upcase
    content, function_name = ["Tech Radar!",:xml_gen]

    content = main_menu() if search_main_menu?(msg)
    content = assessments_by_category_id(msg) if search_categories?(msg)
    content = technologies_by_assess_id(msg) if search_assessments?(msg)

    if search_technology? msg
      content = details_of_technology(msg)
      function_name = :xml_gen_graphical_information
    end

    if search_up_level? msg
      message[:content] = retrieve_up_level Session.safe_get(message[:from])[:latest_message].upcase
      content = gen_content(message)[:content]
    end

    if search_help? msg
      content = help_message()
    end

    { content: content, function_name: function_name }
  end

  def self.help_message
    "Available commands:\n\"radar\": Go to main menu of Tech Radar\n\"*\": Return to previous menu\n\"?\": Help"
  end

  def self.welcome_message
    "Welcome to subscribe Tech Radar Weixin.\n"
  end

  def self.retrieve_up_level msg
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

    {
        title: "#{category.title} - #{assessment.title} - #{technology.title}",
        content: technology.content,
        pic_url: "",
        url: ""
    }
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

  def self.search_help?(msg)
    (/^(\?|？)$/i =~ msg).present?
  end

  def self.is_subscribe_event?(event)
    event == "subscribe"
  end
end