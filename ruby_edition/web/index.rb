# frozen_string_literal: true

require 'sinatra'
require 'erb'
require_relative '../cm_challenge/api'
require_relative '../cm_challenge/absences'

set :views, settings.root
set :port, 3000

helpers do
  def download_file
    CmChallenge::Absences
      .new(
        user_id: params[:userId],
        start_date: params[:startDate],
        end_date: params[:endDate]
      ).to_ical

    unless Dir['invites/**/*.ics'].last.nil?
      send_file Dir['invites/**/*.ics'].last
    end
    'No events were found matching the supplied parameters'
  end
end

get '/' do
  if params.empty?
    erb :index
  else
    download_file
  end
end

post '/' do
  download_file
end
