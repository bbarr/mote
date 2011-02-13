require "active_model/callbacks"

module Mote
  module Callbacks
    extend ActiveSupport::Concern

    included do
      extend ::ActiveModel::Callbacks
      define_model_callbacks :insert, :update, :save, :only => [:before, :after]
    end

    def insert
      run_callbacks(:insert) { super }
    end

    def update
      run_callbacks(:update) { super }
    end

  end
end
