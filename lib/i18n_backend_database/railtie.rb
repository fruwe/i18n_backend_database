require 'i18n_backend_database'
require 'rails'

module I18nBackendDatabase
  class Railtie < Rails::Railtie
    initializer "i18n_backend_database.initialize" do |app|
      # other gems (e.g. devise) might call I18n.t before the locales and translations table exists. Thus use the Database backend only,
      # if the tables exists.
      @is_rake_task ||= false
      if @is_rake_task
        if ActiveRecord::Base.connection.tables.include?("locales") && ActiveRecord::Base.connection.tables.include?("translations")
          I18n.backend = I18n::Backend::Database.new
        end
      else
        I18n.backend = I18n::Backend::Database.new
      end
    end

    rake_tasks do
      @is_rake_task = true
      load File.join(File.dirname(__FILE__), '../tasks/i18n.rake')
    end
  end
end
