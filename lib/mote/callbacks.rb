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

    def update(doc_hash=@doc, opts={})
      run_callbacks(:update) { super }
    end

    def save
      run_callbacks(:save) { super }
    end
  end
end
