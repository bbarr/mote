module Mote
  module Generators
    
    class ModelGenerator < ::Rails::Generators::NamedBase
      desc "Creates a Mote Model"

      def create_model_file
        template "model.rb", File.join("app/modesl", class_path, "#{file_name}.rb")
      end

    end

  end
end
