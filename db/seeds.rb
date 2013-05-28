# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "yaml"

category_descriptor = NodeDescriptor.create({name: 'Category'})
assessment_descriptor = NodeDescriptor.create({name: 'Assessment'})
technology_descriptor = NodeDescriptor.create({name: 'Technology'})

title_field_descriptor = FieldDescriptor.create({name: 'Title', field_type: 'Text'})
content_field_descriptor = FieldDescriptor.create({name: 'Content', field_type: 'Long Text'})

category_descriptor.child_node_descriptors.push assessment_descriptor
assessment_descriptor.child_node_descriptors.push technology_descriptor

# TODO: support creating relation like this
# RelationDescriptor.create({name: 'Contains multiple assessments', parent_node_descriptor: category_descriptor, child_node_descriptor: assessment_descriptor})
# RelationDescriptor.create({name: 'Contains multiple technologies', parent_node_descriptor: assessment_descriptor, child_node_descriptor: technology_descriptor})

category_descriptor.field_descriptors.push title_field_descriptor
category_descriptor.field_descriptors.push content_field_descriptor

assessment_descriptor.field_descriptors.push title_field_descriptor
assessment_descriptor.field_descriptors.push content_field_descriptor

technology_descriptor.field_descriptors.push title_field_descriptor
technology_descriptor.field_descriptors.push content_field_descriptor

dirname = File.dirname(File.expand_path(__FILE__))

%w{ techniques.yml languages.yml tools.yml platforms.yml }.each do |file|
  file_path = File.join(dirname, file)
  source = YAML::load_file(file_path)

  category = Global::Category.new

  source[source.keys.first].each do |key, arr|
    assess = Global::Assessment.new
    category.add assess

    arr.each do |item|
      tech = Global::Technology.new
      tech.title = item["title"]
      tech.content = item["content"]
      assess.add tech
    end
  end
end

# TODO: Import latest tech radar info
# TODO: Navigation Logic
