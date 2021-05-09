const firebase = require("firebase")
const seeds = require("./seeds.json")
require("firebase/firestore")

class Seed {
  constructor({ apiKey, projectId, host, port }) {
    firebase.initializeApp({ apiKey, projectId })
    firebase.firestore().useEmulator(host, port)
    this.db = firebase.firestore()
  }

  populate() {
    return Promise.all(seeds.users.map(async (value, index) => {
      await this.db.collection("users").doc(`user${index}`).set(value)
      return Promise.all(seeds.extras[`user${index}`].map(value => {
        return this.db.collection("users").doc(`user${index}`).collection("extras").add(value)
      }))
    }))
  }

  async clear() {
    const users = await this.db.collection("users").get()
    return Promise.all(users.docs.map(doc => doc.ref.delete()))
  }
}

module.exports = Seed;
