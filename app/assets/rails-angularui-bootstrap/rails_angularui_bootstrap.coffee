angular.module('rails-angularui-bootstrap',[]).run(['$templateCache', ($templateCache)->
	templates = ['accordion']

	for template in templates
		generatedTemplate = JST["rails_angularui_bootstrap/templates/#{template}"]
		if generatedTemplate
			$templateCache.put("template/#{template}/#{template}.html", generatedTemplate())
])