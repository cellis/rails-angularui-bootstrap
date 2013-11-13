load './lib/tasks/rails_angularui_bootstrap.rake'

namespace :angularui do
	desc 'Download and install templates of given branch of angularui for the *gem*'
	task :generate_templates, :repo, :branch do |t, args|
		args.with_defaults(ctx: 'vendor')
		gen_templates args
	end
end