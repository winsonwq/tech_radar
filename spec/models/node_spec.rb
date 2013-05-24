require 'spec_helper'

describe Node do

	let!(:blog_descriptor){ FactoryGirl.create :node_descriptor }
	let!(:comment_descriptor){ FactoryGirl.create :node_descriptor }

	let!(:blog) { FactoryGirl.create :node, node_descriptor: blog_descriptor }
	let!(:comment1) { FactoryGirl.create :node, node_descriptor: comment_descriptor }
	let!(:comment2) { FactoryGirl.create :node, node_descriptor: comment_descriptor }

	let!(:title_field_descriptor){ FactoryGirl.create :field_descriptor }
	let!(:content_field_descriptor){ FactoryGirl.create :field_descriptor }

	let!(:blog_title_field) { FactoryGirl.create :field, field_descriptor: title_field_descriptor }
	let!(:blog_content_field) { FactoryGirl.create :field, field_descriptor: content_field_descriptor }
	let!(:comment1_content_field) { FactoryGirl.create :field, field_descriptor: content_field_descriptor }
	let!(:comment2_content_field) { FactoryGirl.create :field, field_descriptor: content_field_descriptor }

	before :all do
		blog_descriptor.child_node_descriptors.push comment_descriptor
		blog_descriptor.field_descriptors.push title_field_descriptor
		blog_descriptor.field_descriptors.push content_field_descriptor

		comment_descriptor.field_descriptors.push content_field_descriptor

		blog.fields.push blog_title_field
		blog.fields.push blog_content_field

		comment1.fields.push comment1_content_field
		comment2.fields.push comment2_content_field

		blog.child_nodes.push comment1
		blog.child_nodes.push comment2
	end

	specify "parent node have correct node node descriptor" do
		blog.node_descriptor.name.should == blog_descriptor.name
	end

  describe "relations between node and node" do

    it "should contains multiple nodes" do
      blog.child_nodes.should == [comment1, comment2]
    end
    
    specify "two child nodes have only one parent node" do
    	comment1.parent_nodes.should == [blog]
    	comment2.parent_nodes.should == [blog]
    end

  end

  describe "relations between node and fields" do

  	it "should have multiple fields" do
  		blog.fields(true).should == [blog_title_field, blog_content_field]
  	end

  	specify "two fields have only one node" do
  		blog_title_field.node.should == blog
  		blog_content_field.node.should == blog
  	end

  end
  
end
