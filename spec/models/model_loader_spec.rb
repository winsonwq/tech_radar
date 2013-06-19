require 'spec_helper'

describe ModelLoader do
  before(:each) do

  end

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
        expect{ ModelLoader.new "radar.yml" }.not_to raise_error
      end

    end

  end

end