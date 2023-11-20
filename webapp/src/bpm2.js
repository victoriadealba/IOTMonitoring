import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";
import './App.css';

function Bpm2Reading() {
  const [bpm2, setBpm] = useState(null);
  const [bpmContainer, setBpmContainer] = useState('container1');

  useEffect(() => {
    const bpmRef = ref(db, 'bpm2/int');

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
      Realtime BPM2: {bpm2}
    </div>
  );
}

export default Bpm2Reading;
