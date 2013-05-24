class CreateNodeDescriptors < ActiveRecord::Migration
  def change
    create_table :node_descriptors do |t|
      t.string :name

      t.timestamps
    end
  end
end
