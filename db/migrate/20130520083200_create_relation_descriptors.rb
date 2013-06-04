class CreateRelationDescriptors < ActiveRecord::Migration
  def change
    create_table :relation_descriptors do |t|
      t.string :name
      t.integer :node_descriptor_id
      t.integer :child_node_descriptor_id
    end
  end
end
