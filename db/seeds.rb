require "yaml"
require 'socket'

dirname = File.dirname(File.expand_path(__FILE__))
file_path = dirname + ('/models/radar_model.yml')

@model_loader = ModelLoader.new file_path

def my_public_ipv4
  ip_list = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
  ip_list.nil? ? "localhost:3000" : ip_list.ip_address.to_s
end

technology_id = 1
%w{ techniques.yml platforms.yml tools.yml languages.yml }.each_with_index do |file, idx|
  file_path = File.join(dirname, '/models', file)
  source = YAML::load_file(file_path)

  category = TechRadar::Category.new
  category_name = source.keys.first
  category.title = category_name
  category.id = source[category_name]["id"]

  source[category_name].each do |key, obj|
    if key != 'id'
      assess = TechRadar::Assessment.new
      assess.id = obj['id']
      assess.title = key
      category.add assess

      obj['technologies'].each do |item|
        tech = TechRadar::Technology.new
        tech.title = item["title"]
        tech.content = item["content"]
        tech.pic_url = "http://" + my_public_ipv4 + "/images/" + (item["pic_url"] || "")
        tech.url = "http://" + my_public_ipv4 + "/technology/" + technology_id.to_s  unless my_public_ipv4.nil?
        tech.short_description = item["description"]
        tech.id = technology_id
        technology_id += 1
        assess.add tech
      end
    end
  end
end