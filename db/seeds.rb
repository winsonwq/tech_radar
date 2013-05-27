# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category_descriptor = NodeDescriptor.create({name: 'Category'})
assessment_descriptor = NodeDescriptor.create({name: 'Assessment'})
technology_descriptor = NodeDescriptor.create({name: 'Technology'})

title_field_descriptor = FieldDescriptor.create({name: 'Title', field_type: 'Text'})
content_field_descriptor = FieldDescriptor.create({name: 'Content', field_type: 'Long Text'})

category_descriptor.child_node_descriptors.push assessment_descriptor
assessment_descriptor.child_node_descriptors.push technology_descriptor

# TODO: support creating relation like this
RelationDescriptor.create({name: 'Contains multiple assessments', parent_node_descriptor: category_descriptor, child_node_descriptor: assessment_descriptor})
RelationDescriptor.create({name: 'Contains multiple technologies', parent_node_descriptor: assessment_descriptor, child_node_descriptor: technology_descriptor})

category_descriptor.field_descriptors.push title_field_descriptor
category_descriptor.field_descriptors.push content_field_descriptor

assessment_descriptor.field_descriptors.push title_field_descriptor
assessment_descriptor.field_descriptors.push content_field_descriptor

technology_descriptor.field_descriptors.push title_field_descriptor
technology_descriptor.field_descriptors.push content_field_descriptor

category_clazz = Global::Category
assessment_clazz = Global::Assessment
technology_clazz = Global::Technology

techniques = category_clazz.new
techniques.title = "Techniques"
techniques.content = "Techniques trends."

adopt_techniques = assessment_clazz.new
adopt_techniques.title = "Techniques - Adopt"
adopt_techniques.content = "Adopt techniques"

trial_techniques = assessment_clazz.new
trial_techniques.title = "Techniques - Trial"
trial_techniques.content = "Trial techniques"

aggregates_as_documents = technology_clazz.new
aggregates_as_documents.title = "Aggregates as documents"
aggregates_as_documents.content = "No explanation"

analyzing_test_runs = technology_clazz.new
analyzing_test_runs.title = "Analyzing test runs"
analyzing_test_runs.content = "Failing tests reveal bugs in production..."

techniques.add adopt_techniques
techniques.add trial_techniques

adopt_techniques.add aggregates_as_documents
trial_techniques.add analyzing_test_runs

tools = category_clazz.new
tools.title = "Tools"
tools.content = "Tools Trends"

adopt_tools = assessment_clazz.new
adopt_tools.title = "Tools - Adopt"
adopt_tools.content = "Adopt tools"

d3 = technology_clazz.new
d3.title = "D3"
d3.content = "D3 continues to gain traction as..."

tools.add adopt_tools
adopt_tools.add d3


