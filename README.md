# Rails AngularUI Bootstrap - wraps [AngularUI Bootstrap](https://github.com/angular-ui/bootstrap) and allows you to use the AngularUI and Bootstrap 3 project and override the default templates.

***

## How it works.

It relies on [Haml Coffee Assets](https://github.com/netzpirat/haml_coffee_assets) for easily writing 
javascript templates in haml. It's currently using AngularUI Bootstrap's version at 0.6.0, until I find a way to automate the integration of all
the templates. I'm open to suggestions!

## Installation

I've tested this on Rails 4. Should also work with Rails 3.

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
to your `app/assets/javascripts/application.js` file.

You're done.

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

Not very. It uses the `ui-bootstrap-0.6.0-SNAPSHOT.js` from [angular-ui/bootstrap:bootstrap3_bis2](https://github.com/angular-ui/bootstrap/tree/bootstrap3_bis2). I'm still working on tucking all this away so it's easy to just download the magic and go! Right now, i'm just manually maintaining it, so use at your own risk.

Released under the terms of the MIT-LICENSE