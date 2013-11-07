# Rails AngularUI Bootstrap

## What it does
This is a gem that allows you to use the AngularUI bootstrap project and override the default templates.
It relies on [Haml Coffee Assets](https://github.com/netzpirat/haml_coffee_assets) for easily writing 
javascript templates in haml.

## Installation

Add it to your rails Gemfile with

```ruby
	gem 'rails_angularui_bootstrap'
```

And 

```console
	bundle install
```

After that, you can include all the *default* templates by adding

```javascript
	//= require rails-angularui-bootstrap
```
to your app/assets/javascripts/application.js file.

You're done.

Don't want to include every template?

You can include each template individually with

```javascript
	//= require templates/rails-angularui-bootstrap/<name_of_template_1>
	//= require templates/rails-angularui-bootstrap/<name_of_template_2>
```

Just remember to include rails_angularui_bootstrap.coffee *after* including the templates
in your app/assets/javascripts/application.js file.

```javascript
	//= require rails-angularui-bootstrap/rails_angularui_bootstrap
```

You can override templates by simply adding the template hamlc file in a directory called app/assets/javascripts/templates/rails-angularui-bootstrap/

For instance, to override the accordion,
create:

app/assets/javascripts/templates/rails-angularui-bootstrap/accordion.hamlc.

This project rocks and uses MIT-LICENSE.

