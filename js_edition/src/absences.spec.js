import assert from 'assert';
import Absences from './absences';
import { absences } from './api';

describe('prettifyMessage', () => {
  it('returns a prettified message based on absence type', () => {
    const testingInstance = new Absences();
    let message = testingInstance.prettifyMessage("vacation");
    assert.equal(message, "is on vacation");

    message = testingInstance.prettifyMessage("sick");
    assert.equal(message, "is sick");
  });
});

describe('parse date', () => {
  it('converts a string date to an array of numbers', () => {
    const testingInstance = new Absences();
    let date = testingInstance.parseDate("2017-01-01");

    assert.deepEqual([2017,1,1], date)
  });
});

describe('create event', () => {
  it('returns an event object', async () => {
    const testingInstance = new Absences();
    const allAbsences = await absences();
    let event = testingInstance.createEvent("Kachi", allAbsences[0]);
    assert(event instanceof Object)
    assert.equal('Kachi is sick', event["title"]);
  });
});

// commenting this out as I'm still trying to figure out
// how to test for file creation since the file creation
// won't be done before the test finishes running

// describe('toIcal', () => {
//   before(() => {
//     let count;
//     fs.readdir(`${__dirname}/invites`, (err, files) => {
//       console.log(files.length);
//       count = files.length;
//     });
//   })
//   it('add events to calendar', async () => {
//     const testingInstance = new Absences();
//     const calendar = await testingInstance.toIcal();
//     let newCount;
//     fs.readdir(`${__dirname}/invites`, (err, files) => {
//       newCount = files.length;
//     });
//
//   })
// });
