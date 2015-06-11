require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require './bootstrap'
require './sinkiq'

set :session_secret, '50ac0a2e-0eb7-11e5-a6c0-1697f925ec7b'

configure do
  enable :sessions
end

get '/' do
  slim :home
end

get '/home.html' do
  slim :home
end

get '/run/:ipAddress' do
  content_type :txt
  IO.popen("kitchen #{params[:ipAddress]}")
end

get '/sinkiq' do
  workers = Sidekiq::Workers.new
  stats = Sidekiq::Stats.new
  @inProgress = workers.size
  @failed = stats.failed
  @processed = stats.processed
  @messages = $redis.lrange('chef-run', 0, -1)
  slim :sinkiq
end

get '/sidekiq' do
  redirect to('http://localhost:9494')
end

post '/msg' do
  SinatraWorker.perform_async params[:msg]
  redirect to('/sinkiq')
end