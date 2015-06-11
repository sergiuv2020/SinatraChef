require 'redis'
require 'sidekiq'
require 'sidekiq/api'

$redis = Redis.new

class SinatraWorker
  include Sidekiq::Worker

  def perform(msg="lulz you forgot a msg!")
    # `kitchen converge #{msg}`
    runcommand = IO.popen("kitchen #{msg}")
    $redis.lpush("chef-run", runcommand)
  end
end
