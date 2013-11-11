$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_angularui_bootstrap/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_angularui_bootstrap"
  s.version     = RailsAngularuiBootstrap::VERSION
  s.authors     = ["Cameron Ellis"]
  s.email       = ["cameron@lindenlab.com"]
  s.homepage    = "https://github.com/cellis/rails-angularui-bootstrap/"
  s.summary     = "Automatically include default templates in angularui bootstrap"
  s.description = "Automatically include default templates in angularui bootstrap"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "haml_coffee_assets", "~> 1.14.0"
  s.add_dependency "html2haml", "~> 1.0.1"
end
