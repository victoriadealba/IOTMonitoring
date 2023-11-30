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
      if (data <= 1000)
      {
        setGasContainer('container2');
      }
      else
      {
        setGasContainer('container1');
      }
    });
  }, []);

  return (
    <div className={gasContainer}>
      {ppm <= 1000 ? 'Fire detected' : 'No Fire detected'} 
    </div>
    
  );
}

export default PpmReading;
