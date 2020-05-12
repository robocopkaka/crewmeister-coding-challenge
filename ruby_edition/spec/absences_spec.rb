require_relative '../cm_challenge/absences'
require 'pry'

RSpec.describe 'Absences' do
  describe "#generate_events" do
    let(:absences) { CmChallenge::Api.absences }
    let(:members) { CmChallenge::Api.members }

    it "returns a calender with events" do
      events = CmChallenge::Absences.new.generate_events(absences, members)
      expect(events).to be_kind_of Icalendar::Calendar
      expect(events.prodid).to eq "icalendar-ruby"
      expect(events.to_ical).to include "Mike is sick"
      expect(events.to_ical).to include "Ines is on vacation"
      expect(events.to_ical).to include "Daniel is on vacation"
    end
  end

  describe  do

  end
end
