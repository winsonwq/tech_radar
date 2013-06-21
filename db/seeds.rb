require "yaml"
require "socket"

category_descriptor = NodeDescriptor.create({name: 'Category'})
assessment_descriptor = NodeDescriptor.create({name: 'Assessment'})
technology_descriptor = NodeDescriptor.create({name: 'Technology'})

id_field_descriptor = FieldDescriptor.create({name: 'Id', field_type: 'Text'})
title_field_descriptor = FieldDescriptor.create({name: 'Title', field_type: 'Text'})
content_field_descriptor = FieldDescriptor.create({name: 'Content', field_type: 'Long Text'})

pic_field_descriptor = FieldDescriptor.create({name: 'Pic_url', field_type: 'Text'})
url_field_descriptor = FieldDescriptor.create({name: 'Url', field_type: 'Text'})
short_description_descriptor = FieldDescriptor.create({name: 'Short_Description', field_type:'Text'})

category_descriptor.child_node_descriptors.push assessment_descriptor
assessment_descriptor.child_node_descriptors.push technology_descriptor

# TODO: support creating relation like this
# RelationDescriptor.create({name: 'Contains multiple assessments', parent_node_descriptor: category_descriptor, child_node_descriptor: assessment_descriptor})
# RelationDescriptor.create({name: 'Contains multiple technologies', parent_node_descriptor: assessment_descriptor, child_node_descriptor: technology_descriptor})

category_descriptor.field_descriptors.push id_field_descriptor
category_descriptor.field_descriptors.push title_field_descriptor
category_descriptor.field_descriptors.push content_field_descriptor

assessment_descriptor.field_descriptors.push id_field_descriptor
assessment_descriptor.field_descriptors.push title_field_descriptor
assessment_descriptor.field_descriptors.push content_field_descriptor

technology_descriptor.field_descriptors.push id_field_descriptor
technology_descriptor.field_descriptors.push title_field_descriptor
technology_descriptor.field_descriptors.push content_field_descriptor
technology_descriptor.field_descriptors.push pic_field_descriptor
technology_descriptor.field_descriptors.push url_field_descriptor
technology_descriptor.field_descriptors.push short_description_descriptor


dirname = File.dirname(File.expand_path(__FILE__))

def my_private_ipv4
  Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
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
        tech.pic_url = item["pic_url"]
        tech.url = "http://" + my_private_ipv4.ip_address.to_s + "/technology/" + technology_id.to_s  unless my_private_ipv4.nil?
        tech.short_description = item["description"]
        tech.id = technology_id
        technology_id += 1
        assess.add tech
      end
    end
  end
end

# TODO: Init techradar data
# TODO: Import latest tech radar info
# TODO: Navigation Logic