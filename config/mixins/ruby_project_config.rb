# frozen_string_literal: true

set :rbenv_type, :system # or :user
# The ruby version is only considered if there is no override (like a
# .ruby-version file)
set :rbenv_ruby, '2.5.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} "\
                   "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)

set :bundle_binstubs, -> { "~#{fetch(:deploy_user)}/bin" }
