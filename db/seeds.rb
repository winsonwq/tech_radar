# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

blog_descriptor = NodeDescriptor.create({name: 'Blog'})
comment_descriptor = NodeDescriptor.create({name: 'Comment'})

title_field_descriptor = FieldDescriptor.create({name: 'Title', field_type: 'Text'})
published_field_descriptor = FieldDescriptor.create({name: 'Published', field_type: 'Boolean'})
content_field_descriptor = FieldDescriptor.create({name: 'Content', field_type: 'Long Text'})

RelationDescriptor.create({name: 'Contains multiple comments', parent_node_descriptor: blog_descriptor, child_node_descriptor: comment_descriptor})

blog_descriptor.field_descriptors.push title_field_descriptor
blog_descriptor.field_descriptors.push published_field_descriptor
blog_descriptor.field_descriptors.push content_field_descriptor

comment_descriptor.field_descriptors.push title_field_descriptor
comment_descriptor.field_descriptors.push content_field_descriptor

blog1 = Node.create({node_descriptor: blog_descriptor})
title_field = Field.create({field_descriptor: title_field_descriptor, node: blog1, data: "this is a blog title"})
content_field = Field.create({field_descriptor: content_field_descriptor, node: blog1, data: "this is a blog content... this is a blog content... "})
published_field = Field.create({field_descriptor: published_field_descriptor, node: blog1, data: "1"})

comment1 = Node.create({node_descriptor: comment_descriptor})
comment1_title_field = Field.create({field_descriptor: title_field_descriptor, node: comment1, data: "this is a comment1 title"})
comment1_content_field = Field.create({field_descriptor: content_field_descriptor, node: comment1, data: "this is a comment1 content... this is a comment1 content... "})

comment2 = Node.create({node_descriptor: comment_descriptor})
comment2_title_field = Field.create({field_descriptor: title_field_descriptor, node: comment2, data: "this is a comment2 title"})
comment2_content_field = Field.create({field_descriptor: content_field_descriptor, node: comment2, data: "this is a comment2 content... this is a comment2 content... "})


blog1.child_nodes.push comment1
blog1.child_nodes.push comment2