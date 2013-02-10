module SpreeGroupon
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "//= require store/spree_groupon\n" 
        append_file "app/assets/javascripts/admin/all.js", "//= require admin/spree_groupon\n" 
      end

      def add_stylesheets
        inject_into_file "app/assets/stylesheets/store/all.css", " *= require store/spree_groupon\n", :before => /\*\//, :verbose => true
      end
      
      
      desc "Installs required migrations for spree_groupon"
      
      def copy_migrations
        rake "spree_groupon:install:migrations"
      end

    end
  end
end
