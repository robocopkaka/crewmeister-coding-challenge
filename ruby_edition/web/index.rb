require 'sinatra'
require 'erb'
require_relative '../cm_challenge/absences'

set :views, settings.root

get '/' do
  p "hereeee"
  erb :index
end