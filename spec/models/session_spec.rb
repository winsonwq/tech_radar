require 'spec_helper'

describe Session do

  before :each do
    Session.clear
  end

  describe :set do

    it "should add new session record" do
      Session.set 'username', { last_message: "A1" }
      Session.get('username')[:last_message].should == "A1"
    end

    it "should not set the session record with same key" do
      Session.set('username', { last_message: "A1" }).should be_true
      Session.set('username', { last_message: "AA" }).should be_false
      Session.get('username')[:last_message].should == "A1"
    end

  end

end