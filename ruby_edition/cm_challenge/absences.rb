require_relative './api'
require 'icalendar'
require 'fileutils'

module CmChallenge
  class Absences
    def initialize(user_id: nil , start_date: nil, end_date: nil)
      @user_id = user_id
      @start_date = start_date
      @end_date = end_date
      @absences = CmChallenge::Api.absences
      @members = CmChallenge::Api.members
    end
    def to_ical
      # Your implementation here
      cal = add_events_to_calendar
      generate_file(cal)
    end

    def add_events_to_calendar
      calendar = Icalendar::Calendar.new
      # remove what looks like duplicate events
      @absences.uniq! { |mem| mem.values_at(:user_id, :start_date, :end_date) }
      absences = filter_absences_by_dates(filter_absences_by_user(@absences))
      absences.each do |absence|
        user_name = @members.find { |mem| mem[:user_id] == absence[:user_id] }[:name]
        calendar.add_event(create_event(user_name, absence))
      end
      calendar
    end

    private

    def prettify_message(message)
      message == "vacation" ? "is on vacation" : "is sick"
    end

    def generate_file(calendar)
      # avoid creating empty files
      if calendar.events.count.zero?
        puts "No events found matching parameters"
        return "No events found matching parameters"
      end

      FileUtils.mkdir_p "invites" unless Dir.exist?("invites")
      filename = File.join("invites", "invites-#{Time.now}.ics")
      File.open(filename, "w") { |f| f.write calendar.to_ical }
    end

    def create_event(user_name, absence)
      event = Icalendar::Event.new
      event.summary = "#{user_name} #{prettify_message(absence[:type])}"
      event.categories = "NOT IN OFFICE"
      event.dtstart = Icalendar::Values::Date.new(parse_date(absence[:start_date]))
      event.dtend = Icalendar::Values::Date.new(parse_date(absence[:end_date]))
      event
    rescue ArgumentError
      "Invalid date passed"
    end

    # doing this because Icalendar can't parse dates in example format, i.e "2017-01-01"
    # returns an ICalendar DateTime object
    def parse_date(date)
      Icalendar::Values::DateOrDateTime.new(date)
    end

    def filter_absences_by_user(absences)
      return absences unless @user_id.to_s.present?
      return absences&.select { |absence| absence[:user_id] == @user_id.to_i } if @user_id

      absences
    end

    def filter_absences_by_dates(absences)
      return absences unless @start_date.to_s.present? && @end_date.to_s.present?

      if @start_date.to_s.present? && @end_date.to_s.present?
        return absences.select do |absence|
          absence[:start_date] >= @start_date && absence[:end_date] <= @end_date
        end
      end
      absences
    end
  end

  # hero = CmChallenge::Absences.new(user_id: 644, start_date: "2017-03-10", end_date: "2017-03-20")
  # hero = CmChallenge::Absences.new(user_id: 644, start_date: Time.now, end_date: Time.now + 1.hour)
  # hero.to_ical
end
