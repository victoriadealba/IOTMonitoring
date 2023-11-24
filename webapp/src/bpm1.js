import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";
import './App.css';

function BpmReading() {
  const [bpm, setBpm] = useState(null);
  const [bpmContainer, setBpmContainer] = useState('container1');

  useEffect(() => {
    const bpmRef = ref(db, 'bpm/int');

    onValue(bpmRef, (snapshot) => {
      const data = snapshot.val();
      setBpm(data);
      if (data < 50 || data > 160)
      {
        setBpmContainer('container2');
      }
    });
  }, []);

  return (
    <div className={bpmContainer}>
      Realtime BPM1: {bpm}
    </div>
  );
}

export default BpmReading;
