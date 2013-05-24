class CreateFieldDescriptorsNodeDescriptors < ActiveRecord::Migration
  def change
    create_table :field_descriptors_node_descriptors do |t|
      t.integer :node_descriptor_id
      t.integer :field_descriptor_id

      t.timestamps
    end
  end
end
