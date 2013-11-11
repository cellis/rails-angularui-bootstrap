require 'rails_angularui_bootstrap'
require 'rails'

module RailsAngularuiBootstrap
  class Railtie < Rails::Railtie
    rake_tasks do
    	load File.expand_path('../../tasks/rails_angularui_bootstrap.rake', __FILE__)
    end
  end
end