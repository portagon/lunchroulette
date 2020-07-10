web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e $RAILS_ENV -q mailers
release: bundle exec rails db:migrate
