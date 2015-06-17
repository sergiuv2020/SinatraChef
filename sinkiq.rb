require 'redis'
require 'sidekiq'
require 'sidekiq/api'
require './bootstrap'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 60*60*24*30 # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

$redis = Redis.new

class SinatraWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :retry => false

  def perform()

    knifeRunner = KnifeCommands.new
    knifeRunner.knifeSingleNode('root','alfresco','172.29.101.52')
    knifeRunner.deleteClient

  end
end
