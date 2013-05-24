class NodeRelation < ActiveRecord::Base
  belongs_to :parent_node, foreign_key: :parent_node_id, class_name: :Node
  belongs_to :child_node, foreign_key: :child_node_id, class_name: :Node

  attr_accessible :parent_node, :child_node
end
