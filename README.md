## Rails AngularUI Bootstrap - wraps [AngularUI Bootstrap](https://github.com/angular-ui/bootstrap) for rails using hamlcoffee.

***

## How it works.

It relies on [Haml Coffee Assets](https://github.com/netzpirat/haml_coffee_assets) for easily writing 
javascript templates in haml. It's currently using AngularUI Bootstrap's version at 0.6.0, until I find a way to automate the integration of all
the templates. I'm open to suggestions!

## Installation

I've tested this on Rails 4. Should also work with Rails 3.

1. Make sure you have angularjs included in your `application.js` file first.

2. Add rails_angularui_bootstrap to your rails Gemfile with

```ruby
	gem 'rails_angularui_bootstrap'
```

3. Install it: 

```console
	bundle install
```

4. Include all the *default* templates by adding:

```javascript
	//= require rails-angularui-bootstrap
```
to your `app/assets/javascripts/application.js` file.

5. Include Bootstrap 3 in your css [https://github.com/anjlab/bootstrap-rails](There's a gem for this,too), and include the ui-bootstrap
in your javascript `application.js` with

```coffeescript 
	@app = angular.module('app', [
  	'ui.bootstrap'
	])
```

You're done.

## Generating the templates

There's a rake task for that. Run

`rake angularui:generate` to create all the haml templates in your app. 

You can specify an angularui bootstrap fork and a branch with:

`rake angularui:generate[https://github.com/elerch/bootstrap.git,bootstrap3_bis2]`

If you're using zsh like me, use:

`rake 'angularui:generate[https://github.com/elerch/bootstrap.git,bootstrap3_bis2]'`

Note: this task depends on NPM/grunt.

***

If you don't want to include every template, you can include each template individually with

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

`app/assets/javascripts/templates/rails-angularui-bootstrap/accordion/accordion.hamlc`

See [the original AngularUI Bootstrap files](https://github.com/angular-ui/bootstrap/tree/master/template) for examples.

# How up to date is this project?

Not very. It uses the `ui-bootstrap-0.6.0-SNAPSHOT.js` from *@elerch*s fork of angularui/bootstrap [angular-ui/bootstrap:bootstrap3_bis2](https://github.com/elerch/bootstrap/tree/bootstrap3_bis2) because the collapse directive works in that. I'm still working on tucking all this away so it's easy to just download the magic and go! Right now, i'm just manually maintaining it, so use at your own risk.

Released under the terms of the MIT-LICENSE