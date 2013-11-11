namespace :angularui do
	@has_run = false # running twice in client app and have no idea why
	##
	#
	# @param [Hash] options
	# @option options [String] :repo The name of the angularui/bootstrap repo or fork
	# @option options [String] :branch The branch of the repo you wish to use
	# @option options [String] :ctx Whether this is to be generated for the gem default templates or for the app using the gem
	#
	def gen_templates(options = {})
		if @has_run
			return
		end

		@has_run = true
		puts "running generate_templates with #{options.inspect}"

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
		Dir.chdir('tmp/bootstrap')

		# puts 'Enter your password to run: sudo npm install -g grunt-cli karma'
		# `sudo npm install -g grunt-cli karma`
		`npm install`

		# build the angular ui repo
		`grunt`

		# pull the templates out into our vendor/assets/javascripts/templates/rails-angularui-bootstrap dir
		`cp -r template/* ../../#{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/`

		# move to the parent directory
		Dir.chdir('../..')
		
		# convert templates to haml
		puts 'Converting to haml...'
		`for file in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.html; do html2haml -e $file ${file%html}haml 2>&1 && rm $file; done`

		# remove all js files
		puts 'Removing temp files...'
		`rm #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap/**/*.js`
		`rm -rf tmp/bootstrap`

		puts "Templates were generated in #{options[:ctx]}/assets/javascripts/templates/rails-angularui-bootstrap"
	end

	desc 'Download and install templates of given branch of angularui for the *client app*'
	task :generate, :repo, :branch do |t, args|
		args.with_defaults(ctx: 'app')
		gen_templates args
	end
end