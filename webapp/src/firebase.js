
import { initializeApp } from "firebase/app";
import { getDatabase, ref, onValue } from "firebase/database";
//import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyA1EDvdDO3WNLQWXRyYzSEjUkzMn10EFVY",
  authDomain: "industry-monitoring-fe214.firebaseapp.com",
  databaseURL: "https://industry-monitoring-fe214-default-rtdb.firebaseio.com",
  projectId: "industry-monitoring-fe214",
  storageBucket: "industry-monitoring-fe214.appspot.com",
  messagingSenderId: "181999905959",
  appId: "1:181999905959:web:24358ee01f4fa479daff82",
  measurementId: "G-YDJDCE7KXN"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getDatabase(app);
export {db, ref, onValue};
//const analytics = getAnalytics(app);