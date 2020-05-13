require_relative '../cm_challenge/absences'
require 'pry'
require 'fileutils'

RSpec.describe 'Absences' do
  let(:absences) { CmChallenge::Api.absences }
  let(:members) { CmChallenge::Api.members }
  let(:testing_instance) { CmChallenge::Absences.new }

  describe "#add_events_to_calendar" do#
    it "returns a calender with events" do
      events = testing_instance.add_events_to_calendar(absences, members)
      expect(events).to be_kind_of Icalendar::Calendar
      expect(events.prodid).to eq "icalendar-ruby"
      expect(events.to_ical).to include "Mike is sick"
      expect(events.to_ical).to include "Ines is on vacation"
      expect(events.to_ical).to include "Daniel is on vacation"
    end
  end

  describe "create_event" do
    let(:absence) { absences.first }
    it "creates an event" do
      event = testing_instance.send(:create_event, "Kachi", absence)
      expect(event).to be_kind_of Icalendar::Event
      expect(event.categories).to include "NOT IN OFFICE"
      expect(event.summary)
        .to eq "Kachi #{testing_instance.send(:prettify_message, absence[:type])}"
    end

    it "should return an error if there's an invalid date" do
      absence[:start_date] = "echo"
      error = testing_instance.send(:create_event, "Kachi", absence)
      expect(error).to eq "Invalid date passed"
    end
  end

  describe "parse date" do
    it "returns an Icalendar object if the date is valid" do
      date = testing_instance.send(:parse_date, "2017-01-01")
      expect(date).to be_kind_of Icalendar::Values::DateOrDateTime
    end
  end

  describe "#to_ical" do
    before do
      FileUtils.rm_rf Dir.glob("invites/**/*.ics") if Dir["invites"].present?
    end
    after do
        FileUtils.rm_rf Dir.glob("invites/**/*.ics") if Dir["invites"].present?
    end
    it "should return a file containing the events" do
      testing_instance.to_ical
      expect(Dir["invites/**/*.ics"].count).to eq 1
    end
  end
end
