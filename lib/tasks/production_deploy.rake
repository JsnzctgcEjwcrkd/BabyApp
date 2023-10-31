# frozen_string_literal: true

namespace :production_deploy do
  desc 'production環境に最新ソースを反映'
  task :exec do
    `git pull`
    `bundle install`
    `bundle exec rails db:migrate RAILS_ENV=production`
    `bundle exec rails assets:precompile RAILS_ENV=production`
    `sudo nginx -s reload`
    `sudo systemctl restart puma.service`
  end
end
