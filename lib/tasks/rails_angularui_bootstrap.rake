require "json"
require "colorize"

namespace :angularui do
	##
	# @param filename [String] the name of the file to write the version to.
	# @param version_comments_list [String] the list of comment lines to write.
	# @param offset [String] the offset so subsequent runs don't pile up
	#
	def write_version(filename, version_comments_list, offset)
		old_file = File.open(filename, "r+")
		old_file_lines = old_file.readlines
		old_file.close

		# add the require line to the top
		new_file_with_version_lines = version_comments_list + old_file_lines.pop(old_file_lines.length - offset)

		new_file = File.new(filename, "w")
		new_file_with_version_lines.each do |line|
			new_file.write(line)
		end
		new_file.close
	end

	##
	#
	# @param [Hash] options
	# @option options [String] :repo The name of the angularui/bootstrap repo or fork
	# @option options [String] :branch The branch of the repo you wish to use
	# @option options [String] :ctx Whether this is to be generated for the gem default templates or for the app using the gem
	#
	@has_run = false # running twice in client app and have no idea why
	def gen_templates(options = {})
		if @has_run
			return
		end

		@has_run = true
		puts "running generate_templates with #{options.inspect}".colorize(:light_blue)

		defaults = {
			repo: 'https://github.com/elerch/bootstrap.git', # using elerchs branch because I just need collapse / accordion to work for now
			branch: 'bootstrap3_bis2',
			ctx: 'app'
		}

		options = defaults.merge!(options)

		# clean up
		if File.directory?('tmp/bootstrap')
			# remove the old git if it was there from previous run
			`rm -rf tmp/bootstrap`

			# remove any old bootstrap files
			`rm -rf #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/*`
		end

		# remove all the old templates
		`rm -rf #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/*`

		# clone the repo of angular ui
		`git clone -b #{options[:branch]} #{options[:repo]} tmp/bootstrap`
		
		# install dependencies, make use of the tmp directory

		npm_settings = JSON.parse( File.read("tmp/bootstrap/package.json"))

		js_version = npm_settings["version"]

		

		Dir.chdir('tmp/bootstrap')

		`npm install`

		# build the angular ui repo, even if tests fail.
		puts "Grunting...".colorize(:light_blue)
		`grunt --force`

		# now copy the built version of the js in dist, without the templates
		gem_js_directory = "#{options[:ctx]}/assets/javascripts/rails-angularui-bootstrap"
		if !File.directory?("../../#{ gem_js_directory }")
			`mkdir ../../#{ gem_js_directory }`
		end

		write_version("dist/ui-bootstrap-#{ js_version }.js", 
			["// generated from #{options[:repo]}:#{options[:branch]} version: #{ js_version } on #{Time.new().strftime("%m-%d-%Y %H:%M:%S")} \n"
			], 0)

		`cp dist/ui-bootstrap-#{ js_version }.js ../../#{ gem_js_directory }/`

		# pull the templates out into our <ctx>/assets/javascripts/templates/rails-angularui-bootstrap dir
		`cp -r template/* ../../#{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/`

		# move to the parent directory
		Dir.chdir('../..')
		
		# convert templates to haml
		puts 'Converting to hamlc...'.colorize(:light_blue)
		`for file in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.html; do html2haml -e $file ${file%html}hamlc 2>&1 && rm $file; done`

		# remove all js files
		puts 'Removing temp files...'
		`rm #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.js`
		`rm -rf tmp/bootstrap`


		if options[:ctx] == "app"
			source = File.join(Gem.loaded_specs["rails_angularui_bootstrap"].full_gem_path, "vendor/assets/javascripts/rails-angularui-bootstrap", "rails_angularui_bootstrap.coffee")
    	target = File.join(Rails.root, "app/assets/javascripts/rails-angularui-bootstrap", "rails_angularui_bootstrap.coffee")
    	`cp #{source} #{target}`
    	
			write_version("#{options[:ctx]}/assets/javascripts/rails-angularui-bootstrap/rails_angularui_bootstrap.coffee",[
				"# require the ui-bootstrap module, in case the user wants to selectively load \n",
				"#= require rails-angularui-bootstrap/ui-bootstrap-#{ js_version }.js \n"
			],2)

			puts "Overrode rails_angularui_bootstrap.coffee from gem by placing it in #{gem_js_directory}".colorize(:yellow)
		end

		
		puts "Templates were generated in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap".colorize(:green)
 	end

	desc 'Download and install templates of given branch of angularui for the *client app*'
	task :generate, :repo, :branch do |t, args|
		args.with_defaults(ctx: 'app')
		gen_templates args
	end
end