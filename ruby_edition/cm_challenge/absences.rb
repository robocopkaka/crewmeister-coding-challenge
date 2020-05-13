require_relative './api'
require 'icalendar'
require 'fileutils'

module CmChallenge
  class Absences
    def to_ical
      # Your implementation here
      absences = CmChallenge::Api.absences
      members = CmChallenge::Api.members
      cal = add_events_to_calendar(absences, members)
      generate_file(cal)
    end

    def add_events_to_calendar(absences, members)
      calendar = Icalendar::Calendar.new
      # remove what looks like duplicate events
      absences.uniq! { |mem| mem.values_at(:user_id, :start_date, :end_date) }
      absences.each do |absence|
        user_name = members.find { |mem| mem[:user_id] == absence[:user_id] }[:name]
        calendar.add_event(create_event(user_name, absence))
      end
      calendar
    end

    private

    def prettify_message(message)
      message == "vacation" ? "is on vacation" : "is sick"
    end

    def generate_file(calendar)
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
  end

  hero = CmChallenge::Absences.new
  hero.to_ical
end
