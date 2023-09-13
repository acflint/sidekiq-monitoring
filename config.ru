require "sidekiq"
require "sidekiq/web"
require "securerandom"

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == ENV["SIDEKIQ_USERNAME"] and password == ENV["SIDEKIQ_PASSWORD"]
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["REDIS_URL"]}
end

secret_key = SecureRandom.hex(32)
use Rack::Session::Cookie, secret: secret_key, same_site: true, max_age: 86400

run Sidekiq::Web
