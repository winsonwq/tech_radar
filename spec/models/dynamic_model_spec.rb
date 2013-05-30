require 'spec_helper'

include TechRadar

describe "dynamic model" do

  let!(:blog_descriptor) { FactoryGirl.create :node_descriptor, name: "Blog" }
  let!(:comment_descriptor) { FactoryGirl.create :node_descriptor, name: "Comment" }

  let!(:title_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Title" }
  let!(:content_field_descriptor) { FactoryGirl.create :field_descriptor, name: "Content" }

  before :all do
    comment_descriptor.parent_node_descriptors.push blog_descriptor
    blog_descriptor.field_descriptors.push title_field_descriptor
    blog_descriptor.field_descriptors.push content_field_descriptor

    comment_descriptor.field_descriptors.push content_field_descriptor
  end

  before :each do
    @blog = Blog.new
    @comment1 = Comment.new
    @comment2 = Comment.new

    @blog.title = "blog title"
    @blog.content = "blog content"

    @comment1.content = "comment1 content"
    @comment2.content = "comment2 content"
  end

  specify { @blog.node.should_not be_nil }
  specify { @blog.node.node_descriptor.should == blog_descriptor }
  specify { @blog.comments.length.should == 0 }

  describe "Comment Class" do
    it "should return all comments" do
      Comment.all.length.should == 2
      Comment.all.first.content.should == @comment1.content
    end
  end

  describe "fields" do
    it "should have correct count of fields" do
      @blog.node.fields.count.should == 2
    end

    it "should have correct value" do
      @blog.title.should == "blog title"
      @blog.content.should == "blog content"

      @blog.title = "blog title1"
      @blog.title.should == "blog title1"
    end
  end

  describe "relations" do

    it "should have correct children relations" do
      @blog.add @comment1
      @blog.add @comment2
      @blog.comments.length.should == 2
      @blog.comments.first.content.should == @comment1.content
      @blog.comments.last.content.should == @comment2.content
    end

    it "should have correct parents relations" do
      @comment1.add @blog
      @comment2.add @blog

      @comment1.blogs.length.should == 1
      @comment1.blogs.first.title.should == @blog.title
      @comment1.blogs.first.content.should == @blog.content
    end

  end


end
