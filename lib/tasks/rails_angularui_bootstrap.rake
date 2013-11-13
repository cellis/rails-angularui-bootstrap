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

		# if the app developer specified a repo, check to see if it's the default repo
		need_clone = false
		options = options.to_hash
		if options.has_key?(:repo)
			if options[:repo] != defaults[:repo]
				# clone this repo into tmp
				need_clone = true
			else
				if options.has_key?(:branch) && options[:branch] != defaults[:branch]
					# different branch, clone repo
					need_clone = true
				end
			end
		end

		# remove old templates
		`rm -rf #{ options[:ctx] }/assets/javascripts/templates/rails-angularui-bootstrap`

		# merge with default options
		options = defaults.merge!(options)
		
		gem_js_directory = "#{ options[:ctx] }/assets/javascripts/rails-angularui-bootstrap"
		

		# ensure javascripts dir
		if !File.directory?("#{ gem_js_directory }")
			`mkdir -p #{ gem_js_directory }`
		end

		# make sure the app has a templates / rails-angularui-bootstrap dir
		if !File.directory?("#{ options[:ctx] }/assets/javascripts/templates/rails-angularui-bootstrap")
			`mkdir -p #{ options[:ctx] }/assets/javascripts/templates/rails-angularui-bootstrap`
		end

		if need_clone || options[:ctx] == 'vendor'
			puts "Either you're the gem maintainer or you chose a different branch and repo, i'll have to try to clone and build it ...".colorize(:yellow)

			if File.directory?('tmp/bootstrap')
				# remove the old git if it was there from previous run
				`rm -rf tmp/bootstrap`

				# remove any old bootstrap files
				`rm -rf #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/*`
			end
			
			# clone the repo of angular ui
			`git clone -b #{options[:branch]} #{options[:repo]} tmp/bootstrap`
			
			# get the node settings / version
			npm_settings = JSON.parse( File.read("tmp/bootstrap/package.json"))
			js_version = npm_settings["version"]
			
			Dir.chdir('tmp/bootstrap')

			# install dependencies, make use of the tmp directory
			`npm install`

			# build the angular ui repo, even if tests fail.
			puts "Running Grunt...".colorize(:light_blue)
			`grunt --force`

			# write a version comment to this file so it's easy to know whence this file came
			write_version("dist/ui-bootstrap-#{ js_version }.js", 
				["// generated from #{options[:repo]}:#{options[:branch]} version: #{ js_version } on #{Time.new().strftime("%m-%d-%Y %H:%M:%S")} \n"
				], 0)
			
			# now copy the built version of the js in dist, without the templates
			`cp dist/ui-bootstrap-#{ js_version }.js ../../#{ gem_js_directory }`

			# remove all the old templates
			`rm -rf #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/*`

			# pull the templates out into our <ctx>/assets/javascripts/templates/rails-angularui-bootstrap dir
			`cp -r template/* ../../#{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/`

			# move to the parent directory
			Dir.chdir('../..')
			
			# convert templates to haml, suppress warnings
			puts 'Converting to hamlc...'.colorize(:light_blue)
			`for file in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.html; do html2haml -e $file ${file%html}hamlc 2>&1 && rm $file; done`

			# clean up
			# remove all js files
			puts 'Removing temp files...'
			`rm #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.js`
			# remove the bootstrap dir
			`rm -rf tmp/bootstrap`
			
		end

		if options[:ctx] == "app"
    	if need_clone
				source = File.join(Gem.loaded_specs["rails_angularui_bootstrap"].full_gem_path, "vendor/assets/javascripts/rails-angularui-bootstrap", "rails_angularui_bootstrap.coffee")
	    	target = File.join(Rails.root, "app/assets/javascripts/rails-angularui-bootstrap", "rails_angularui_bootstrap.coffee")
	    	`cp #{source} #{target}`

    		# write version into rails_angularui_bootstrap
				write_version("#{options[:ctx]}/assets/javascripts/rails-angularui-bootstrap/rails_angularui_bootstrap.coffee",[
					"# require the ui-bootstrap module, in case the user wants to selectively load \n",
					"#= require rails-angularui-bootstrap/ui-bootstrap-#{ js_version }.js \n"
				],2)
			else
				puts "Generating files".colorize(:cyan)
				# same repo and branch, no need to clone, just copy from gem
				js_source = File.join(Gem.loaded_specs["rails_angularui_bootstrap"].full_gem_path, "vendor/assets/javascripts/rails-angularui-bootstrap")
	    	js_target = File.join(Rails.root, "app/assets/javascripts/")
	    	
	    	`cp -r #{js_source} #{js_target}`

	    	# index file not needed
	    	`rm #{js_target}rails-angularui-bootstrap/index.js`

	    	template_source = File.join(Gem.loaded_specs["rails_angularui_bootstrap"].full_gem_path, "vendor/assets/javascripts/templates/rails-angularui-bootstrap") 
	    	template_target = File.join(Rails.root, "app/assets/javascripts/templates")

	    	`cp -r #{template_source} #{template_target}`
			end

			puts "Overrode rails_angularui_bootstrap.coffee from gem by placing it in #{gem_js_directory}".colorize(:yellow)
		end

		
		puts "Templates were generated in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap".colorize(:green)
		puts "Options: #{options.inspect}".colorize(:light_blue)
 	end

	desc 'Download and install templates of given branch of angularui for the *client app*'
	task :generate, :repo, :branch do |t, args|
		args.with_defaults(ctx: 'app')
		gen_templates args
	end
end