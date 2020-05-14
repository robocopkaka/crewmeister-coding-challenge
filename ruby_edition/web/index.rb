require 'sinatra'
require 'erb'
require 'pry'
autoload :CmChallenge, './cm_challenge/api.rb'
autoload :CmChallenge, './cm_challenge/absences.rb'

set :views, settings.root
set :port, 3000

get '/' do
  erb :index
end

get '/download' do
  CmChallenge::Absences.new.to_ical
  send_file Dir["invites/**/*.ics"].last
end