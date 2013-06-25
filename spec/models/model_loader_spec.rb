require 'spec_helper'

describe ModelLoader do

  let(:file_path) { File.expand_path(File.dirname(__FILE__) + '/../fixtures/radar_models.yml') }

  describe :new do

    context "validate fail" do

      it "should not be empty" do
        expect{ ModelLoader.new "" }.to raise_error(ArgumentError)
        expect{ ModelLoader.new " " }.to raise_error(ArgumentError)
        expect{ ModelLoader.new "\t" }.to raise_error(ArgumentError)
      end

      it "to fail when it is not string" do
        expect{ ModelLoader.new nil }.to raise_error(ArgumentError)
        expect{ ModelLoader.new({}) }.to raise_error(ArgumentError)
        expect{ ModelLoader.new(1) }.to raise_error(ArgumentError)
      end

      it "should be a yml path" do
        expect{ ModelLoader.new "radar.rb" }.to raise_error(ArgumentError)
      end
    end

    context "validate success" do

      it "should be a string" do
        expect{ ModelLoader.new file_path }.not_to raise_error
      end

    end

  end
  
  describe :fields do

    before :each do
      @model_loader = ModelLoader.new file_path
    end

    context "load fields successfully" do

      specify { @model_loader.fields.count.should == 3 }

      it "should have correct fields" do
        @model_loader.fields.keys.should == ['id1', 'title1', 'content1']
      end

    end

    context "load nodes successfully" do

      specify { @model_loader.nodes.count.should == 3 }

      it "should have correct nodes" do
        @model_loader.nodes.keys.should == ['student', 'course', 'room']
      end

      it "should have correct fields for each node" do
        author_descriptor = @model_loader.nodes.values.first
        author_descriptor.field_descriptors.map(&:name).should == ['id1', 'title1', 'content1']
      end

      it "should have correct sub-classes relationship" do
        author_descriptor = @model_loader.nodes.values.first
        author_descriptor.child_node_descriptors.map(&:name).should == ['Course']
      end

    end

  end

end