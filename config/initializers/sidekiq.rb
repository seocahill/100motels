require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_ADDRESS"], namespace: "my-workers" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_ADDRESS"], namespace: "my-workers" }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["sidekiqadmin", ENV["SIDEKIQ_PASSWORD"]]
end



























