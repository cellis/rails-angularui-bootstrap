# require the ui-bootstrap module, in case the user wants to selectively load 
#= require rails-angularui-bootstrap/ui-bootstrap-0.6.0-SNAPSHOT.js 
#= require hamlcoffee
angular.module('rails-angularui-bootstrap',[]).run(['$templateCache', ($templateCache)->
	JST = window.JST
	if JST
		namespace = "rails_angularui_bootstrap/"
		for own key, template of JST
			if key.indexOf(namespace) is 0
				# this is a rails-angularui-bootstrap template, so cache it as an angular-ui template
				angularUIBootstrapName = key.replace(namespace,"")
				angularUIBootstrapDir  = angularUIBootstrapName.split("/")[0]
				cacheKey = "template/#{angularUIBootstrapName}.html".replace("_","-")
				$templateCache.put(cacheKey, template(null))
	return
]) 