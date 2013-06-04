class CreateNodeRelations < ActiveRecord::Migration
  def change
    create_table :node_relations do |t|
      t.integer :parent_node_id
      t.integer :child_node_id
    end
  end
end
