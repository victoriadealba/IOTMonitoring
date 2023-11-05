import './App.css';
import {db} from "./firebase.js";
import { onValue, ref } from "firebase/database";
import React, {useEffect,useState} from 'react';


function App() {
  const[bpm, setBpm] = useState(null);

  useEffect(() => {
    const bmpRef = ref(db, 'bpm2/int');
    onValue(bmpRef,(snapshot) => {
      const data = snapshot.val();
      setBpm(data);
    });
  }, []);


  return (
    <div className="App">
      <header className="App-header">
        <h1>Realtime BPM: {bpm}</h1>

      </header>
    </div>
  );
}

export default App;
