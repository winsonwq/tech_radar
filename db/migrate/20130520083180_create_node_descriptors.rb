class CreateNodeDescriptors < ActiveRecord::Migration
  def change
    create_table :node_descriptors do |t|
      t.string :name
    end
  end
end
