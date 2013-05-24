class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :node_id
      t.integer :field_descriptor_id
      t.string :data

      t.timestamps
    end
  end
end
