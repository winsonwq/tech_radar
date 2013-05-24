class NodeDescriptor < ActiveRecord::Base
  has_and_belongs_to_many :field_descriptors
  has_many :child_relation_descriptors, foreign_key: :node_descriptor_id, class_name: :RelationDescriptor
  has_many :parent_relation_descriptors, foreign_key: :child_node_descriptor_id, class_name: :RelationDescriptor

  has_many :child_node_descriptors,
           through: :child_relation_descriptors,
           foreign_key: :node_descriptor_id,
           inverse_of: :parent_node_descriptors

  has_many :parent_node_descriptors,
           through: :parent_relation_descriptors,
           foreign_key: :child_node_descriptor_id,
           inverse_of: :child_node_descriptors

  attr_accessible :name, :field_descriptors
end
