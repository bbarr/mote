module Mote

  # Mote module for automatically generating timestamps on entries in the database
  # Depends on Mote::Callbacks
  #
  # @see Mote::Callbacks
  module Timestamps
    extend ActiveSupport::Concern

    included do
      include Mote::Callbacks

      # Auto generate keys for created_at and updated_at if the Mote::Keys
      # module has been included in the model
      # 
      # TODO: Currently for this to work, keys must be included before timestamps
      #   it would be nice to not have to worry about the order that these 2 modules
      #   are included in
      if keys?
        key :created_at
        key :updated_at
      end

      before_insert :update_timestamps
      before_update :update_timestamps
    end

    # Timestamp the query
    def update_timestamps
      time = Time.new
      self.created_at = time if is_new?
      self.updated_at = time
    end

  end
end
