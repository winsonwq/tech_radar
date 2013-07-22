class AddIsolateToNodeDescriptors < ActiveRecord::Migration
  def change
  	add_column :node_descriptors, :isolate, :string
  end
end
