import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";

function BpmReading() {
  const [bpm, setBpm] = useState(null);

  useEffect(() => {
    const bpmRef = ref(db, 'bpm/int');

    onValue(bpmRef, (snapshot) => {
      const data = snapshot.val();
      setBpm(data);
    });
  }, []);

  return (
    <div>
      <h1>Realtime BPM1: {bpm}</h1>
    </div>
  );
}

export default BpmReading;
