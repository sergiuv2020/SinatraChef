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
  slim :sinkiq
end

get '/sidekiq' do
  redirect to('http://localhost:9494')
end

get '/run' do
  job_id = SinatraWorker.perform_async
  jobproperties = "stack1, postgres, 4 snodes"
  $redis.hsetnx("jobs", job_id, jobproperties )
  return_message = {}
  return_message[:job_id] = job_id
  return_message[:jobproperties] = jobproperties
  return_message.to_json
  # redirect to('http://localhost:9494')
end

get '/job_status/:job_id' do
  data = Sidekiq::Status::get_all params[:job_id]
  return_message = data
  return_message.to_json
end

get '/getalljobs' do
  return_message = {}

  job_ids = $redis.hkeys("jobs")
  job_ids.each do |key|
  	data = Sidekiq::Status::get_all key
  	data.merge!(properties: $redis.hget("jobs",key))
    return_message[key] = data
  end

  return_message.to_json
end
