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
                "Description" => article[:short_description],
                "PicUrl" => article[:pic_url] + "?timestamp=" + DateTime.now.to_i.to_s,
                "Url" => article[:url]
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

  def self.gen_content_from_event(message)
    event = message[:event]
    content, function_name = [fallback_message(), :xml_gen]
    content = welcome_message() if is_subscribe_event?(event)
    { content: content, function_name: function_name }
  end

  private

  def self.update_session message
    Session.safe_get(message[:from])[:latest_message] = message[:content]
  end

  def self.gen_content(message)
    msg = message[:content].upcase
    content, function_name = [fallback_message(),:xml_gen]

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
    "可用命令：\n“radar”：查询技术雷达\n“*”：返回上级菜单\n“?”:查看帮助"
  end

  def self.welcome_message
    "哈喽极客们，欢迎关注TW技术雷达机器人! 技术雷达针对正在推进下一代软件开发的前沿技术，工具，语言和平台，提供见解和指导。\n回复“radar”获得本期技术雷达信息。\n如果不知道如何使用机器人，请回复“？”获得使用手册。"
  end

  def self.fallback_message
    "Hi, 机器人无法识别你的输入！输入“？”获得使用手册，输入“*”返回上一级菜单"
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
        pic_url: technology.pic_url,
        url: technology.url,
        short_description: technology.short_description + "\n输入“*”返回上一级菜单"
    }
  end

  def self.technologies_by_assess_id(msg)
    assessment = Assessment.find msg
    category = assessment.categories.first
    response = "#{category.title} - #{assessment.title}\n"
    assessment.technologies.each do |tech|
      response += "#{tech.id}: #{tech.title}\n"
    end
    response += "输入ID查看技术详情，输入“*”返回上一级菜单"
    response
  end

  def self.assessments_by_category_id(msg)
    category = Category.find msg
    response = "#{category.title}\n"

    category.assessments.each do |assess|
      response += "#{assess.id}: #{assess.title}\n"
    end
    response += "输入ID查看评估范围，输入“*”返回上一级菜单"
    response
  end

  def self.main_menu
    response = ""
    Category.all.each do |c|
      response += "#{c.id}: #{c.title}\n"
    end
    response += "输入ID查看类别，输入“*”返回上一级菜单"
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