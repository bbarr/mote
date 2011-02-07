module Mote

  # Wrap a Mongo::Cursor for managinag results as Mote::Documents
  class Cursor
    include Enumerable
    
    def initialize(obj_class, mongo_cursor)
      @obj_class = obj_class
      @mongo_cursor = mongo_cursor
    end

    # Loop through each cursor entry and create a Mote::Document for
    # each document found in the cursor
    def each
      @mongo_cursor.each do |doc|
        yield(@obj_class.new(doc, false))
      end
    end

    # Creates an array of Mote::Documents for the entire cursor
    #
    # @return [Array <Mote::Document>] Array of Mote::Documents for each entry found
    def to_a
      document_array = [].tap do |arr|
        self.each { |doc| arr << doc }
      end
    end

  end
end
