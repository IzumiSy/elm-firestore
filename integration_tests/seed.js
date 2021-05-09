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
    const batch = this.db.batch()
    const users = await this.db.collection("users").get()
    const extrasByUser = await Promise.all(users.docs.map(async doc =>
      this.db.collection("users").doc(doc.id).collection("extras").get()
    ))
    extrasByUser.forEach(extras => {
      extras.docs.forEach(doc => batch.delete(doc.ref))
    })
    await batch.commit()
    return Promise.all(users.docs.map(async doc => doc.ref.delete()))
  }
}

module.exports = Seed;
