require 'active_support/inflector'

class NodeDescriptor < ActiveRecord::Base
  has_and_belongs_to_many :field_descriptors, after_add: :after_add_field
  has_many :child_relation_descriptors,
           foreign_key: :node_descriptor_id,
           class_name: :RelationDescriptor

  has_many :parent_relation_descriptors,
           foreign_key: :child_node_descriptor_id,
           class_name: :RelationDescriptor

  has_many :child_node_descriptors,
           through: :child_relation_descriptors,
           foreign_key: :node_descriptor_id,
           inverse_of: :parent_node_descriptors,
           after_add: [:after_add_node_descriptor, :complete_node_descriptor_relation]

  has_many :parent_node_descriptors,
           through: :parent_relation_descriptors,
           foreign_key: :child_node_descriptor_id,
           inverse_of: :child_node_descriptors,
           after_add: [:after_add_node_descriptor, :complete_node_descriptor_relation]

  attr_accessible :name
  after_create :create_model

  def clazz
    Global.const_get self.name.to_sym
  end

  private

  def clazz= new_clazz
    Global.const_set self.name, new_clazz
  end

  def create_model
    descriptor = self
    self.clazz = Class.new do
      attr :node

      define_method :initialize do
        @node = Node.create({ node_descriptor: descriptor })
      end

      # TODO: should use ActiveRecord:Relation class
      define_method :add do |elem|
        self.node.child_nodes.push elem.node if descriptor.child_node_descriptors.include? elem.node.node_descriptor
        self.node.parent_nodes.push elem.node if descriptor.parent_node_descriptors.include? elem.node.node_descriptor
      end
    end
  end

  def after_add_field(field_descriptor)
    field_get_sym = field_descriptor.name.underscore.to_sym
    field_set_sym = (field_descriptor.name.underscore + '=').to_sym

    self.clazz.class_eval do

      attr_accessor field_get_sym

      # TODO: have different data type
      define_method field_get_sym do
        target_field = node_field(field_descriptor)
        target_field.data if target_field.present?
      end

      define_method field_set_sym do |val|
        target_field = node_field(field_descriptor)

        if target_field.nil?
          target_field = Field.create({ node: self.node, field_descriptor: field_descriptor })
        end

        target_field.data = val
        target_field.save
      end

      def node_field(field_descriptor)
        self.node.fields(true).select do |f|
          f.field_descriptor.id == field_descriptor.id
        end.first
      end
    end
  end


  def after_add_node_descriptor descriptor
    relations_sym = descriptor.name.pluralize.underscore.to_sym

    self.clazz.class_eval do

      attr relations_sym

      define_method relations_sym do
        relations = (self.node.child_nodes + self.node.parent_nodes).select do |node|
          node.node_descriptor.id == descriptor.id
        end

        relations = relations.map do |node|
          clazz = Global.const_get(node.node_descriptor.name)
          elem = clazz.new
          elem.instance_variable_set("@node", node)
          elem
        end

        self.instance_variable_set("@" + relations_sym.to_s, relations)
      end
    end
  end

  def complete_node_descriptor_relation descriptor
    clazz_name = descriptor.name
    clazz = Global.const_get(clazz_name)

    if clazz.instance_methods.index(self.name.pluralize.underscore.to_sym).nil?
      descriptor.send(:after_add_node_descriptor, self)
    end
  end

end

# TODO: should use global variable in order to call Classes directly
module Global

end
