class FieldDescriptor < ActiveRecord::Base
  has_and_belongs_to_many :node_descriptors
  attr_accessible :name, :field_type
end
