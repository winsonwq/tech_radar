class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :node_descriptor_id
    end
  end
end
