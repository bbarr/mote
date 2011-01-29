module Mote

  # Very stripped down callback set up for models providing a way to run before_save, etc
  # The workflow was borrowed from MongoMapper
  # @see https://github.com/jnunemaker/mongomapper/blob/master/lib/mongo_mapper/plugins/callbacks.rb
  module Callbacks

    def self.included(base)
      callbacks = [:before_save]

      callbacks.each do |callback|
        base.class_eval <<-"end_eval"
          def self.#{callback}(method, &block)
            callbacks = CallbackChain.build(:#{callback}, method, &block)
            @#{callback}_callbacks ||= CallbackChain.new
            @#{callback}_callbacks.concat callbacks
          end

          def self.#{callback}_callback_chain
            @#{callback}_callbacks ||= CallbackChain.new
          end
        end_eval
      end
    end

    # Run through and execute any callbacks for the given type on the instance
    #
    # @param [Symbol, String] kind The kind of callback to run
    # @param [Hash] options Optional set of options to send along with callback execution
    # @param [Block] &block Optional block
    def run_callbacks(kind, options={}, &block)
      callback_chain_method = "#{kind}_callback_chain"
      return unless self.class.respond_to?(callback_chain_method)
      self.class.send(callback_chain_method).run(self, options, &block)
    end

    # Custom array for holding onto a collection fo callbacks
    class CallbackChain < Array
      
      class << self
        def build(kind, *methods, &block)
          methods, options = extract_options(*methods, &block)
          methods.map! { |method| Callback.new(kind, method, options) }
          new(methods)
        end

        def extract_options(*methods, &block)
          methods.flatten!
          options = methods.extract_options!
          methods << block if block_given?
          return methods, options
        end
      end
      
      # Enumerate through the callbacks that exist and call them
      def run(object, options={}, &terminator)
        enumerator = options[:enumerator] || :each
        unless block_given?
          send(enumerator) { |callback| callback.call(object) }
        else
          send(enumerator) do |callback|
            result = callback.call(object)
            break result if terminator.call(result, object)
          end
        end
      end

    end
    
    # Custom callback class to define callbacks for our model
    class Callback

      def initialize(kind, method, opts={})
        @kind = kind
        @method = method
        @options = opts
      end

      # Run the callback
      def call(*args, &block)
        evaluate_method(@method, *args, &block)
      end

      # Evaluates a callback method based on the way it was passed in, be it a
      # Symbol, String, Proc or Method
      def evaluate_method(method, *args, &block)
        case method
        when Symbol
          object = args.shift
          object.send(method, *args, &block)
        when String
          eval(method, args.first.instance_eval { binding })
        when Proc, Method
          method.call(*args, &block)
        else
          if method.respond_to? kind
            method.send(kind, *args, &block)
          end
        end
      end
    end

  end
end
