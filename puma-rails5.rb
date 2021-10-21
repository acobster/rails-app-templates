require_relative 'util/app_template_helper.rb'


replace_readme do
  project_name = ask('hey what\'s this project actually called?')
  project_blurb = ask('terse blurb:')

  readme_markdown = <<-MARKDOWN
  # #{project_name}

  #{project_blurb}

  ## Tests

  TODO

  ## Dev environment

  TODO

  MARKDOWN
  readme_markdown
end


install_rspec = prompt_for_rspec
generate_user_scaffold = prompt_for_user_scaffold
generate_scaffolds = prompt_for_additional_scaffolds
setup_rails_admin_routes = prompt_for_rails_admin
setup_root_route = prompt_for_root_route
overwrite_with_skeleton = prompt_for_skeleton


replace_gemfile do
  add_source 'https://rubygems.org'

  gem 'rails', '~> 5.2'
  gem 'sqlite3'
  gem 'puma'
  gem 'bcrypt'
  gem 'slim-rails'
  gem 'rails_admin'
  gem 'cancancan'
  gem 'devise'

  gem_group :development, :test do
    gem 'listen'
    gem 'minitest'
  end
end


after_bundle do
  install_rspec.call unless install_rspec.nil?
  generate_user_scaffold.call unless generate_user_scaffold.nil?
  generate_scaffolds.call unless generate_scaffolds.nil?
  setup_rails_admin_routes.call unless setup_rails_admin_routes.nil?
  setup_root_route.call unless setup_root_route.nil?
  overwrite_with_skeleton.call unless overwrite_with_skeleton.nil?
  rails_command 'db:migrate'
  rails_command 'db:test:prepare'
  rails_command 'db:seed'
  run 'yarn install' if yes?('install npm dependencies (using yarn)? (y/n)')
  git :init
  git add: '--all'
  git commit: '-m initial'
end

# TODO prompt for initializers?
