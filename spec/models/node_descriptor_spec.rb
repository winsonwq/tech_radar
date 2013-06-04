require 'spec_helper'

describe NodeDescriptor do
  let!(:parent_node_descriptor){ FactoryGirl.create :node_descriptor }
  let!(:child_node_descriptor_1){ FactoryGirl.create :node_descriptor }
  let!(:child_node_descriptor_2){ FactoryGirl.create :node_descriptor }
  let!(:super_node_descriptor){ FactoryGirl.create :node_descriptor }

  let!(:field_descriptor_1){ FactoryGirl.create :field_descriptor }
  let!(:field_descriptor_2){ FactoryGirl.create :field_descriptor }

  before(:all) do
    parent_node_descriptor.child_node_descriptors.push child_node_descriptor_1
    parent_node_descriptor.child_node_descriptors.push child_node_descriptor_2
    parent_node_descriptor.parent_node_descriptors.push super_node_descriptor

    parent_node_descriptor.field_descriptors.push field_descriptor_1
    parent_node_descriptor.field_descriptors.push field_descriptor_2
  end

  describe "relations between node descriptors" do
    it "should contains multiple node descriptors" do
      parent_node_descriptor.child_node_descriptors(true).length.should == 2
    end

    specify "two child node descriptors have only one parent node descriptor " do
      child_node_descriptor_1.parent_node_descriptors.should == [parent_node_descriptor]
      child_node_descriptor_2.parent_node_descriptors.should == [parent_node_descriptor]
    end
  end

  describe "relations between node descriptor and field descriptors" do
    it "should contains multiple field descriptors" do
      parent_node_descriptor.field_descriptors(true).length.should == 2
    end

    specify "two field descriptors have only one parent node descriptor " do
      field_descriptor_1.node_descriptors.should == [parent_node_descriptor]
      field_descriptor_2.node_descriptors.should == [parent_node_descriptor]
    end
  end

  describe "callbacks when creating new model" do

    let!(:clazz) {TechRadar.const_get(parent_node_descriptor.name)}

    specify { clazz.should_not be_nil }

    specify { clazz.singleton_methods.should include(:all) }

    specify { clazz.singleton_methods.should include(:find) }

    describe "instance of clazz" do

      let!(:instance) {clazz.new}

      it "should have two field get methods" do
        instance.methods.should include(field_descriptor_1.name.underscore.to_sym)
        instance.methods.should include(field_descriptor_2.name.underscore.to_sym)
      end

      it "should have two field set methods" do
        instance.methods.should include((field_descriptor_1.name.underscore + '=').to_sym)
        instance.methods.should include((field_descriptor_2.name.underscore + '=').to_sym)
      end

      it "should have two child node methods" do
        instance.methods.should include(child_node_descriptor_1.name.pluralize.underscore.to_sym)
        instance.methods.should include(child_node_descriptor_2.name.pluralize.underscore.to_sym)
      end

      it "should have one parent node methods" do
        instance.methods.should include(super_node_descriptor.name.pluralize.underscore.to_sym)
      end

    end

  end
end
