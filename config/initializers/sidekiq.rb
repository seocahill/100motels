require 'sidekiq'
require 'sidekiq/web'

# redis_domain = ENV['BLOG_REDIS_1_PORT_6379_TCP_ADDR']
# redis_port   = ENV['BLOG_REDIS_1_PORT_6379_TCP_PORT']

# if redis_domain && redis_port
#   redis_url = "redis://#{redis_domain}:#{redis_port}"

#   Sidekiq.configure_server do |config|
#     config.redis = {
#       namespace: "sidekiq",
#       url: redis_url
#     }
#   end

#   Sidekiq.configure_client do |config|
#     config.redis = {
#       namespace: "sidekiq",
#       url: redis_url
#     }
#   end
# end

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

unless Rails.env.development?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == ["sidekiqadmin", ENV["SIDEKIQ_PASSWORD"]]
  end
end

# Sidekiq.configure_server do |config|
#   config.redis = { url: 'redis://redis.example.com:7372/12' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: 'redis://redis.example.com:7372/12' }
# end



























