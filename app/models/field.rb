class Field < ActiveRecord::Base
  belongs_to :field_descriptor
  belongs_to :node

  attr_accessible :data, :field_descriptor, :node
end
