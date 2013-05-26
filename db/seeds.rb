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

RelationDescriptor.create({name: 'Contains multiple assessments', parent_node_descriptor: category_descriptor, child_node_descriptor: assessment_descriptor})
RelationDescriptor.create({name: 'Contains multiple technologies', parent_node_descriptor: assessment_descriptor, child_node_descriptor: technology_descriptor})

category_descriptor.field_descriptors.push title_field_descriptor
category_descriptor.field_descriptors.push content_field_descriptor

assessment_descriptor.field_descriptors.push title_field_descriptor
assessment_descriptor.field_descriptors.push content_field_descriptor

technology_descriptor.field_descriptors.push title_field_descriptor
technology_descriptor.field_descriptors.push content_field_descriptor

techniques = Node.create({node_descriptor: category_descriptor})
title_field = Field.create({field_descriptor: title_field_descriptor, node: techniques, data: "Techniques"})
content_field = Field.create({field_descriptor: content_field_descriptor, node: techniques, data: "Techniques trends."})

adopt_techniques = Node.create({node_descriptor: assessment_descriptor})
adopt_techniques_title_field = Field.create({field_descriptor: title_field_descriptor, node: adopt_techniques, data: "Techniques - Adopt"})
adopt_techniques_content_field = Field.create({field_descriptor: content_field_descriptor, node: adopt_techniques, data: "Adopt techniques."})

trial_techniques = Node.create({node_descriptor: assessment_descriptor})
adopt_techniques_title_field = Field.create({field_descriptor: title_field_descriptor, node: trial_techniques, data: "Techniques - Trial"})
adopt_techniques_content_field = Field.create({field_descriptor: content_field_descriptor, node: trial_techniques, data: "Trial techniques."})

aggregates_as_documents = Node.create({node_descriptor: technology_descriptor})
aggregates_as_documents_title_field = Field.create({field_descriptor: title_field_descriptor, node: aggregates_as_documents, data: "Aggregates as documents"})
aggregates_as_documents_content_field = Field.create({field_descriptor: content_field_descriptor, node: aggregates_as_documents, data: "No explanation."})

automated_deployment_pipeline = Node.create({node_descriptor: technology_descriptor})
automated_deployment_pipeline_title_field = Field.create({field_descriptor: title_field_descriptor, node: automated_deployment_pipeline, data: "Automated deployment pipeline"})
automated_deployment_pipeline_content_field = Field.create({field_descriptor: content_field_descriptor, node: automated_deployment_pipeline, data: "No explanation."})

analyzing_test_runs = Node.create({node_descriptor: technology_descriptor})
analyzing_test_runs_title_field = Field.create({field_descriptor: title_field_descriptor, node: analyzing_test_runs, data: "Analyzing test runs"})
analyzing_test_runs_content_field = Field.create({field_descriptor: content_field_descriptor, node: analyzing_test_runs, data: "Failing tests reveal bugs in production..."})

techniques.child_nodes.push adopt_techniques
techniques.child_nodes.push trial_techniques

adopt_techniques.push aggregates_as_documents
adopt_techniques.push automated_deployment_pipeline

trial_techniques.push analyzing_test_runs


