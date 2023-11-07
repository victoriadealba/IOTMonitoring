import React, { useEffect, useState } from 'react';
import { onValue, ref } from "firebase/database";
import { db } from "./firebase.js";

function PpmReading() {
  const [ppm, setPpm] = useState(null);

  useEffect(() => {
    const gasRef = ref(db, 'gasValue/int');

    onValue(gasRef, (snapshot) => {
      const data = snapshot.val();
      setPpm(data);
    });
  }, []);

  return (
    <div>
      <h1>Level of Toxins in the Room: {ppm}</h1>
    </div>
  );
}

export default PpmReading;
