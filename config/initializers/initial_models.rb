unless ENV['RELOAD'].present?
  category_descriptor = NodeDescriptor.select { |nd| nd.name == 'Category' }.first
  category_descriptor.create_model

  assessment_descriptor = NodeDescriptor.select { |nd| nd.name == 'Assessment' }.first
  assessment_descriptor.create_model

  technology_descriptor = NodeDescriptor.select { |nd| nd.name == 'Technology' }.first
  technology_descriptor.create_model

  id_field_descriptor = FieldDescriptor.select { |fd| fd.name == 'id' && fd.field_type == 'text' }.first
  title_field_descriptor = FieldDescriptor.select { |fd| fd.name == 'title' && fd.field_type == 'text' }.first
  content_field_descriptor = FieldDescriptor.select { |fd| fd.name == 'content' && fd.field_type == 'long_text' }.first

  pic_field_descriptor = FieldDescriptor.select { |fd| fd.name == 'pic_url' && fd.field_type == 'text' }.first
  url_field_descriptor = FieldDescriptor.select { |fd| fd.name == 'url' && fd.field_type == 'text' }.first
  short_description_descriptor = FieldDescriptor.select { |fd| fd.name == 'short_description' && fd.field_type == 'text' }.first

  pic_field_descriptor = FieldDescriptor.select{ |fd| fd.name == 'Pic_url' && fd.field_type == 'Text' }.first
  url_field_descriptor = FieldDescriptor.select{ |fd| fd.name == 'Url' && fd.field_type == 'Text' }.first
  short_description_descriptor = FieldDescriptor.select{ |fd| fd.name == 'Short_Description' && fd.field_type == 'Text'}.first

  category_descriptor.child_node_descriptors.push assessment_descriptor
  assessment_descriptor.child_node_descriptors.push technology_descriptor

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
end