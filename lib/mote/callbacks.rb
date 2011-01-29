module Mote

  # Very stripped down callback set up for models providing a way to run before_save, etc
  module Callbacks

    def before_save(method, &block)
      callbacks = CallbackChain.build(:before_save, method, &block)
      @before_save_callbacks ||= CallbackChain.new
      @before_save_callbacks.concat callbacks
    end

    def before_save_callback_chain
      before_save_callbacks ||= CallbackChain.new
      if superclass.respond_to?(:before_save_callback_chain)
        CallbackChian.new(
          superclass.before_save_callback_chain @before_save_callbacks
        )
      else
        @before_save_callbacks
      end
    end

    def run_callbacks(kind, options={}, &block)
      callback_chain_method = "#{kind}_callback_chain"
      return unless self.respond_to?(callback_chain_method)
      self.send(callback_chain_method).run(self, options, &block)
    end

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
