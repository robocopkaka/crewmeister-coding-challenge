# frozen_string_literal: true

require_relative '../cm_challenge/absences'
require 'fileutils'

RSpec.describe 'Absences' do
  let(:absences) { CmChallenge::Api.absences }
  let(:members) { CmChallenge::Api.members }
  let(:testing_instance) { CmChallenge::Absences.new }

  describe '#add_events_to_calendar' do
    it 'returns a calender with events' do
      events = testing_instance.add_events_to_calendar
      expect(events).to be_kind_of Icalendar::Calendar
      expect(events.prodid).to eq 'icalendar-ruby'
      expect(events.to_ical).to include 'Mike is sick'
      expect(events.to_ical).to include 'Ines is on vacation'
      expect(events.to_ical).to include 'Daniel is on vacation'
    end
  end

  describe 'create_event' do
    let(:absence) { absences.first }
    it 'creates an event' do
      event = testing_instance.send(:create_event, 'Kachi', absence)
      expect(event).to be_kind_of Icalendar::Event
      expect(event.categories).to include 'NOT IN OFFICE'
      expect(event.summary)
        .to eq "Kachi #{testing_instance
                          .send(:prettify_message, absence[:type])}"
    end

    it 'should return an error if there\'s an invalid date' do
      absence[:start_date] = 'echo'
      error = testing_instance.send(:create_event, 'Kachi', absence)
      expect(error).to eq 'Invalid date passed'
    end
  end

  describe 'parse date' do
    it 'returns an Icalendar object if the date is valid' do
      date = testing_instance.send(:parse_date, '2017-01-01')
      expect(date).to be_kind_of Icalendar::Values::DateOrDateTime
    end
  end

  describe '#to_ical' do
    before do
      FileUtils.rm_rf Dir.glob('invites/**/*.ics') if Dir['invites'].present?
    end
    after do
      FileUtils.rm_rf Dir.glob('invites/**/*.ics') if Dir['invites'].present?
    end
    it 'should return a file containing the events' do
      testing_instance.to_ical
      expect(Dir['invites/**/*.ics'].count).to eq 1
    end

    it 'should return a message if there are no events' do
      empty_instance = CmChallenge::Absences.new(user_id: 100_00)
      error = empty_instance.to_ical
      expect(error).to eq 'No events found matching parameters'
    end
  end

  describe '#filter_absences_by_user' do
    it 'returns only absences matching a given user id' do
      user_id = members.first[:user_id]
      user_instance = CmChallenge::Absences.new(user_id: user_id)
      user_absences = user_instance.send(:filter_absences_by_user, absences)
      user_absences.map! { |absence| absence[:user_id] }
      expect(user_absences.uniq).to eq [user_id]
    end
  end

  describe '#filter_absences_by_dates' do
    it 'returns only absences matching a given user id' do
      start_date = '2017-03-10'
      end_date = '2017-03-11'
      user_instance = CmChallenge::Absences.new(
        start_date: start_date,
        end_date: end_date
      )
      date_absences = user_instance.send(:filter_absences_by_dates, absences)
      date_absences.map! do |absence|
        [absence[:start_date], absence[:end_date]]
      end
      date_absences.each do |absence|
        expect(absence[0]).to be >= start_date
        expect(absence[1]).to be <= end_date
      end
    end
  end
end
