import { members, absences } from './api';
// import ics from 'ics';
const ics = require('ics');

class Absences {
  constructor() {
    this.members = [];
    const self = this;
    members().then((member) => {
      return this.members = member;
    })
    this.getMembers = this.getMembers.bind(this)
  }

  async getMembers() {
    return await members();
  }

  async getAbsences() {
    return await absences();
  }

  toIcal() {

  }

  addEventsToCalendar() {
    absences().then((absences_promise) => {
      let user;
      absences_promise.forEach((absence) => {
        members().then((mems) => {
          user = mems.find(member => member.userId === absence.userId);
          ics.createEvent(this.createEvent(user.name, absence), (err, value) => {
            if(err) {
              console.log(err);
              return
            }

            console.log(value)
          });
        });
      });
    });
  }

  createEvent(userName, absence) {
    return {
      start: [new Date(absence.startDate)],
      end: [new Date(absence.endDate)],
      summary: `${userName} ${this.prettifyMessage(absence.type)}`
    };
  }

  prettifyMessage(type) {
    return type === 'vacation' ? 'is on vacation' : 'is sick'
  }
}

const absence = new Absences();
absence.addEventsToCalendar();