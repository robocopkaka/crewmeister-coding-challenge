import { members, absences } from './api';
import fs, { writeFileSync } from 'fs';
const ics = require('ics');

class Absences {
  constructor() {
    this.calendarEvents = [];
  }

  toIcal() {
    absences().then(async (absences_promise) => {
      let user;
      let allMembers = await members();
      for (let absence of absences_promise) {
        user = allMembers.find(member => member['userId'] === absence['userId']);
        this.calendarEvents.push(this.createEvent(user.name, absence))
      }
      const { error, value } = ics.createEvents(this.calendarEvents)

      if (error) {
        console.log(error)
        return
      }
      await this.createFile(value);
    });
  }

  createEvent(userName, absence) {
    return {
      start: this.parseDate(absence['startDate']),
      end: this.parseDate(absence['endDate']),
      title: `${userName} ${this.prettifyMessage(absence.type)}`
    };
  }

  prettifyMessage(type) {
    return type === 'vacation' ? 'is on vacation' : 'is sick'
  }

  parseDate(date) {
    return date.split("-").map(number => parseInt(number, 10))
  }

  async createFile(value) {
    await fs.promises.mkdir(`${__dirname}/invites`, { recursive: true });

    const eventName = `event-${new Date().toISOString()}`
    writeFileSync(`${__dirname}/invites/${eventName}.ics`, value, (err, res) => {
      console.log("Shit done");
    });
  }
}

export default Absences;
//
// const absence = new Absences();
// absence.toIcal();
