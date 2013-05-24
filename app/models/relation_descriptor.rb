class RelationDescriptor < ActiveRecord::Base
  belongs_to :parent_node_descriptor, class_name: :NodeDescriptor, foreign_key: :node_descriptor_id
  belongs_to :child_node_descriptor, class_name: :NodeDescriptor, foreign_key: :child_node_descriptor_id

  attr_accessible :name, :parent_node_descriptor, :child_node_descriptor
end
