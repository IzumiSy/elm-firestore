const firebase = require("firebase")
const data = require("./users.json")
require("firebase/firestore")

firebase.initializeApp({ projectId: "elm-firestore-test" })
firebase.firestore().useEmulator("localhost", 8080)

exports.loadSeeds = async () => {
  const db = firebase.firestore()
  const loaders = data.seeds.map((value, index) => db.collection("users").doc(`user${index}`).set(value))
  return Promise.all(loaders)
}


exports.clearAll = async () => {
  const users = await firebase.firestore().collection("users").get()
  return Promise.all(users.docs.map(doc => doc.ref.delete()))
}
