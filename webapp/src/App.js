import './App.css';
import {db} from "./firebase.js";
import { onValue, ref } from "firebase/database";
import React, {useEffect,useState} from 'react';


function App() {
  const[bpm, setBpm] = useState(null);
  const[bpm2, setBpm2] = useState(null);

  useEffect(() => {
    const bmpRef = ref(db, 'bpm/int');
    const bpmReff = ref(db,'bpm2/int');

    onValue(bmpRef,(snapshot) => {
      const data = snapshot.val();
      setBpm(data);
    });
    onValue(bpmReff,(snapshot) => {
      const data = snapshot.val();
      setBpm2(data);
    });
  }, []);


  return (
    <div className="App">
      <header className="App-header">
        <h1>Realtime BPM1: {bpm}</h1>
        <h1>Realtime BPM2: {bpm2} </h1>

      </header>
    </div>
  );
}

export default App;
