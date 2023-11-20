import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";
import './App.css';

function PpmReading() {
  const [ppm, setPpm] = useState(null);
  const [gasContainer, setGasContainer] = useState('container1');

  useEffect(() => {
    const gasRef = ref(db, 'gasValue/int');

    onValue(gasRef, (snapshot) => {
      const data = snapshot.val();
      setPpm(data);
      if (data <= 0)
      {
        setGasContainer('container2');
      }
    });
  }, []);

  return (
    <div className={gasContainer}>
      Level of Toxins in the Room: {ppm}
    </div>
  );
}

export default PpmReading;
