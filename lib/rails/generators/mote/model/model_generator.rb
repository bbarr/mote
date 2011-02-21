require "rails/generators/named_base"

module Mote
  module Generators
    
    class ModelGenerator < ::Rails::Generators::NamedBase
      desc "Creates a Mote Model"

      def create_model_file
        base = File.expand_path "../templates", __FILE__
        template base + "model.rb", File.join("app/models", class_path, "#{file_name}.rb")
      end

    end

  end
end
