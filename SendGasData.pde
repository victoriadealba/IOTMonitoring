#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Include necessary Firebase libraries and helper functions
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Replace with your network credentials
#define WIFI_SSID "ufdevice"
#define WIFI_PASSWORD "gogators"

// Firebase credentials
#define FIREBASE_HOST "https://industry-monitoring-fe214-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "APIkey"

//define buzzer GPIO18
#define BUZZER_PIN 18 

// Set up Firebase data object, auth, and config
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

// Pin configuration for the PulseSensor
const int PULSE_INPUT = 36;
const int THRESHOLD = 2000;

// Sampling configuration
const byte SAMPLES_PER_SERIAL_SAMPLE = 10;
byte samplesUntilReport;

#define AO_PIN 35 // ESP32's pin GPIO36 connected to AO pin of the MQ2 sensor

void setup() {
  // initialize serial communication
  Serial.begin(115200);

  //set the buzzer as output
  pinMode(BUZZER_PIN, OUTPUT);

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Initialize Firebase configuration
  config.api_key = FIREBASE_AUTH;
  config.database_url = FIREBASE_HOST;

  // Sign up with Firebase
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Firebase signup successful");
    signupOK = true;
  } else {
    Serial.printf("Firebase signup error: %s\n", config.signer.signupError.message.c_str());
  }

  // Set the token status callback function
  config.token_status_callback = tokenStatusCallback;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  Serial.println("Warming up the MQ2 sensor");
  delay(20000);  // wait for the MQ2 to warm up
}

void loop() {
  int gasValue = analogRead(AO_PIN);

  Serial.print("MQ2 sensor AO value: ");
  Serial.println(gasValue);

  if (Firebase.RTDB.setInt(&fbdo, "gasValue/int", gasValue)) {
    Serial.println("Data sent to Firebase");
    Serial.println("Path: " + fbdo.dataPath());
    Serial.println("Data Type: " + fbdo.dataType());
  } else {
    Serial.println("Failed to send data to Firebase");
    Serial.println("Error Reason: " + fbdo.errorReason());
  }

  //add the read from firebase to buzzer functionality
  if (Firebase.RTDB.getInt(&fbdo, "bpm/int")) {
      int bpm_data = fbdo.intData();
      Serial.println(bpm_data);
      if (bpm_data >= 80) 
      {
        digitalWrite(BUZZER_PIN, HIGH);
      }
      else
      {
        digitalWrite(BUZZER_PIN, LOW);
      }
  }

  if (Firebase.RTDB.getInt(&fbdo, "bpm2/int")) {
      int bpm2_data = fbdo.intData();
      Serial.println(bpm2_data);
      if (bpm2_data >= 80) 
      {
        digitalWrite(BUZZER_PIN, HIGH);
      }
      else
      {
        digitalWrite(BUZZER_PIN, LOW);
      }
  } 

  if (Firebase.RTDB.getInt(&fbdo, "gasValue/int")) {
      int gas_data = fbdo.intData();
      Serial.println(gas_data);
      if (gas_data > 1) 
      {
        digitalWrite(BUZZER_PIN, HIGH);
      }
      else
      {
        digitalWrite(BUZZER_PIN, LOW);
      }
  }
}  // <- Added closing brace for the loop() function
