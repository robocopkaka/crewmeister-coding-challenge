require 'sinatra'
require 'erb'
require 'pry'
autoload :CmChallenge, './cm_challenge/api.rb'
autoload :CmChallenge, './cm_challenge/absences.rb'

set :views, settings.root
set :port, 3000

get '/' do
  if params.empty?
    erb :index
  else
    CmChallenge::Absences
      .new(
        user_id: params[:userId],
        start_date: params[:startDate],
        end_date: params[:endDate],
        ).to_ical

    unless Dir["invites/**/*.ics"].last.nil?
      send_file Dir["invites/**/*.ics"].last
    end
    "No events were found matching the supplied parameters"
  end
end

post '/' do
  p params
  CmChallenge::Absences
    .new(
      user_id: params[:user_id],
      start_date: params[:start_date],
      end_date: params[:end_date],
    ).to_ical
  unless Dir["invites/**/*.ics"].last.nil?
    send_file Dir["invites/**/*.ics"].last
  end
  "No events were found matching the supplied parameters"
end
