require 'sinatra'
require 'sidekiq/web'

app = Sidekiq::Web
app.set :port, 9494
app.run!