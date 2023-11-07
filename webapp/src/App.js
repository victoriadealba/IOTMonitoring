import './App.css';
import {db} from "./firebase.js";
import BpmReading from "./bpm1.js"
import Bpm2Reading from './bpm2.js';
import PpmReading from './gasReadings.js';
import { onValue, ref } from "firebase/database";
import React, {useEffect,useState} from 'react';


function App() {
  return (
    <div className="App">
      <header className="App-header">
       <BpmReading />
       <Bpm2Reading />
       <PpmReading />
      </header>
    </div>
  );
}

export default App;
