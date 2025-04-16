import seeds from "./seeds.json";
import { initializeApp } from "firebase-admin/app";
import {
  getDocs,
  collection,
  doc,
  getFirestore,
  connectFirestoreEmulator,
  setDoc,
  addDoc,
  writeBatch,
  deleteDoc,
} from "firebase/firestore";

class Seed {
  constructor({ apiKey, projectId, host, port }) {
    initializeApp({ apiKey, projectId });
    this.db = getFirestore();
    connectFirestoreEmulator(this.db, host, port);
  }

  populate() {
    return Promise.all(
      seeds.users.map(async (value, index) => {
        await setDoc(doc(this.db, "users", `user${index}`), value);
        return Promise.all(
          seeds.extras[`user${index}`].map((value) =>
            addDoc(
              collection(this.db, "users", `user${index}`, "extras"),
              value
            )
          )
        );
      })
    );
  }

  async clear() {
    const batch = writeBatch(this.db);
    const users = await getDocs(collection(this.db, "users"));
    const extrasByUser = await Promise.all(
      users.docs.map(async (userDoc) =>
        getDocs(
          collection(doc(collection(this.db, "users"), userDoc.id), "extras")
        )
      )
    );
    extrasByUser.forEach((extras) => {
      extras.docs.forEach((extraDoc) => batch.delete(extraDoc.ref));
    });
    await batch.commit();
    return Promise.all(
      users.docs.map(async (userDoc) =>
        deleteDoc(doc(this.db, "users", userDoc.id))
      )
    );
  }
}

module.exports = Seed;
