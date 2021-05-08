const firebase = require("firebase")
const seeds = require("./seeds.json")
require("firebase/firestore")

firebase.initializeApp({ projectId: "firestore-integration-test" })
firebase.firestore().useEmulator("localhost", 8080)

exports.loadSeeds = () => {
  const db = firebase.firestore()
  return Promise.all(seeds.users.map(async (value, index) => {
    await db.collection("users").doc(`user${index}`).set(value)
    return Promise.all(seeds.extras[`user${index}`].map(value =>
      db.collection("users").doc(`user${index}`).collection("extras").add(value)
    ))
  }))
}

exports.clearAll = async () => {
  const users = await firebase.firestore().collection("users").get()
  return Promise.all(users.docs.map(doc => doc.ref.delete()))
}
