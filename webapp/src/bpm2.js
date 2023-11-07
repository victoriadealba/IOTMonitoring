import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";

function Bpm2Reading() {
  const [bpm2, setBpm] = useState(null);

  useEffect(() => {
    const bpmRef = ref(db, 'bpm2/int');

    onValue(bpmRef, (snapshot) => {
      const data = snapshot.val();
      setBpm(data);
    });
  }, []);

  return (
    <div>
      <h1>Realtime BPM2: {bpm2}</h1>
    </div>
  );
}

export default Bpm2Reading;
