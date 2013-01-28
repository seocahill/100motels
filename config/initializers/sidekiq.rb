require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq.configure_server do |config|
  # The config.redis is calculated by the
  # concurrency value so you do not need to
  # specify this. For this demo I do
  # show it to understand the numbers
  config.redis = { :size => 9 }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["sidekiqadmin", ENV["SIDEKIQ_PASSWORD"]]
end

