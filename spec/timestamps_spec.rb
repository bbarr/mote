require File.expand_path("../spec_helper", __FILE__)

describe Mote::Timestamps do

  class Person < Mote::Document
    include Mote::Timestamps
  end

  it "should include Mote::Callbacks into the model if it does not already include it" do
    Person.should include Mote::Callbacks
  end

  context "With Keys Module" do

    class PersonWithKeys< Mote::Document
        include Mote::Keys
        include Mote::Timestamps

        key :name
      end

      it "should create keys on the document for created_at and updated_at" do
        PersonWithKeys.keys.should include "created_at"
        PersonWithKeys.keys.should include "updated_at"
      end

      describe "Callbacks" do

        before do
          @person = PersonWithKeys.new(:name => "Damian")
        end
        
        it "should timestamp created_at on insert" do
          @person.created_at.should be nil
          @person.insert
          @person.created_at.should be_a Time
        end

        it "should timestamp the update_ad on insert" do
          @person.updated_at.should be nil
          @person.insert
          @person.updated_at.should be_a Time
        end

        it "should have the same timestamp for updated and created at when inserting" do
          @person.insert
          @person.updated_at.should == @person.created_at
        end

        it "should not change the created at time when updating" do
          @person.insert

          insert_time = @person.created_at

          @person.update
          @person.created_at.should == insert_time
        end

        it "should change the updated at time when updating" do
          @person.insert
          @person.update
          @person.updated_at.should_not == @person.created_at
        end
        
      end
  end

end
