class Node < ActiveRecord::Base
  has_many :fields
  has_many :child_node_relations,
           class_name: :NodeRelation,
           foreign_key: :parent_node_id

  has_many :parent_node_relations,
           class_name: :NodeRelation,
           foreign_key: :child_node_id

  has_many :child_nodes,
           through: :child_node_relations,
           foreign_key: :parent_node_id,
           inverse_of: :parent_nodes

  has_many :parent_nodes,
           through: :parent_node_relations,
           foreign_key: :child_node_id,
           inverse_of: :child_nodes

  belongs_to :node_descriptor

  attr_accessible :node_descriptor

end
