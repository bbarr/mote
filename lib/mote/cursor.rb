module Mote

  # Wrap a Mongo::Cursor for managinag results as Mote::Documents
  class Cursor
    include Enumerable
    
    def initialize(obj_class, mongo_cursor)
      @obj_class = obj_class
      @mongo_cursor = mongo_cursor
    end

    def each
      @mongo_cursor.each do |doc|
        yield(@obj_class.new(doc))
      end
    end
  end

end

