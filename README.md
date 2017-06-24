# Rails App Templates

Modular Ruby on Rails app templates with reusable prompts, and integration with [rails-skeletons](https://github.com/acobster/rails-skeletons) for granular file-level overrides.

## Usage

Tell rails-skeletons where to find the skeleton directories:

```bash
# ~/.skeletons
SKELETONS_PATH=/path/to/your/skeletons
```

Optionally tell Rails to automatically load your custom app template:

```bash
# ~/.railsrc
--template /path/to/my_fancy_app_template.rb
```

Finally, set up your custom app template:

```ruby
# my_fancy_app_template.rb
require_relative 'util/app_template_helper.rb'

replace_readme do
  info = ask('gimme some readme info?')

  readme_markdown = <<-MARKDOWN
  # My Fancy New Rails Project
  
  info: #{info}
  MARKDOWN
  
  # the string returned by this block will
  # become your README.md contents
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
  gem 'rails', '~> 5.1'
  gem 'fancy-custom-gem', 'x.y.z'
  # whatever else in here
end

after_bundle do
  # running this stuff last is recommended
  install_rspec.call unless install_rspec.nil?
  generate_user_scaffold.call unless generate_user_scaffold.nil?
  generate_scaffolds.call unless generate_scaffolds.nil?
  setup_rails_admin_routes.call unless setup_rails_admin_routes.nil?
  setup_root_route.call unless setup_root_route.nil?
  overwrite_with_skeleton.call unless overwrite_with_skeleton.nil?
  # whatever other stuff you want...
  rails_command 'db:migrate'
end
```