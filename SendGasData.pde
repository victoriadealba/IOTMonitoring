#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Firebase libraries and helper functions
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Replace with your network credentials
#define WIFI_SSID "ufdevice"
#define WIFI_PASSWORD "gogators"

// Insert Firebase project API Key
#define API_KEY "API_Key"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://industry-monitoring-fe214-default-rtdb.firebaseio.com/" 
#define AO_PIN 35 // ESP32's pin GPIO36 connected to AO pin of the MQ2 sensor

// Define buzzer and LED GPIO pins
#define BUZZER_PIN 18
#define LED_PIN 19 // Red LED pin

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int intValue;
float floatValue;
bool signupOK = false;

void setup() {
  // initialize serial communication
  Serial.begin(115200);

  // set the buzzer and LED as outputs
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  
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

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    Serial.print("Fire sensor AO value: ");
    int gasValue = analogRead(AO_PIN);
    Serial.println(gasValue);

    // Attempt to send data to Firebase
    if (Firebase.RTDB.setInt(&fbdo, "/gasValue/int", gasValue)) {
      Serial.println("Data sent to Firebase");
      Serial.println("Path: " + fbdo.dataPath());
      Serial.println("Data Type: " + fbdo.dataType());
    } else {
      Serial.println("Failed to send data to Firebase");
      Serial.println("Error Reason: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.getInt(&fbdo, "/bpm/int")) {
      if (fbdo.dataType() == "int") {
        int bpm_data = fbdo.intData();
        Serial.println(bpm_data);
        if (bpm_data >= 80) 
        {
          digitalWrite(BUZZER_PIN, HIGH);
          digitalWrite(LED_PIN, HIGH); // Turn on the red LED
          delay(1000);
          digitalWrite(BUZZER_PIN, LOW);
          //digitalWrite(LED_PIN, LOW); // Turn off the red LED
        }
        else
        {
          digitalWrite(BUZZER_PIN, LOW);
          digitalWrite(LED_PIN, LOW);
        }
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }
    
    if (Firebase.RTDB.getInt(&fbdo, "/bpm2/int")) {
      if (fbdo.dataType() == "int") {
        int bpm2_data = fbdo.intData();
        Serial.println(bpm2_data);
        if (bpm2_data >= 80 || gasValue < 1000) 
        {
          digitalWrite(BUZZER_PIN, HIGH);
          digitalWrite(LED_PIN, HIGH); // Turn on the red LED
          delay(1000);
          digitalWrite(BUZZER_PIN, LOW);
          //digitalWrite(LED_PIN, LOW); // Turn off the red LED
        }
        else
        {
          digitalWrite(BUZZER_PIN, LOW);
          digitalWrite(LED_PIN, LOW);
        }
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }
  }
}
