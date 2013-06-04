class CreateFieldDescriptors < ActiveRecord::Migration
  def change
    create_table :field_descriptors do |t|
      t.string :name
      t.string :field_type
    end
  end
end
