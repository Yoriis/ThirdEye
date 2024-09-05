#include <Arduino.h>
#include <WiFiClientSecure.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include "TTS.h"
#include <PubSubClient.h>



//WIFI
char ssid[]="Galaxy A21s70FB";
char pass[]="7102003rana";
int status = WL_IDLE_STATUS; 


const char *topic_publish1 = "object";//Topic ESP32 Pusblish
const char *topic_publish2 = "hr";//Topic ESp32 Subs
const char *mqtt_broker = "4175c4b4371246c3bc4ba3a4382c9867.s1.eu.hivemq.cloud";//"broker.emqx.io";//Public Broker
const char *mqtt_username = "Habiba";
const char *mqtt_password = "H06092005h*";
const int mqtt_port = 8883;

#define API_KEY  "AIzaSyAkPC_5vtIIBOI-AM6x4U_46n1dj-l8xvU"
#define DATABASE_URL "https://finalproject-15cde-default-rtdb.europe-west1.firebasedatabase.app/"

void callback(char *topic, byte *payload, unsigned int length);
void printPayload(char *topic, byte *message, unsigned int length);
// Define the Firebase Data object
FirebaseData fbdo;
FirebaseConfig config;
FirebaseAuth auth;


WiFiClientSecure Asmaa;         
PubSubClient client(Asmaa);

// pins of speaker and heart rate sensor
TTS tts(25);
#define pin 32
  const int trig_pin=5;
  const int echo_pin=18;

static const char *root_ca PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";


// function for connecting wifi
void wifiConnect() {
Serial.println("Attempting to connect to open network...");
  status = WiFi.begin(ssid,pass);

  Serial.print("SSID: ");
  Serial.println(ssid);

   while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    
        Serial.println("Connected to the Wi-Fi network");
}


void setup() {

  Serial.begin(115200);
 //pinMode(LED,OUTPUT);
  wifiConnect() ;
  Asmaa.setCACert(root_ca);

  client.setServer(mqtt_broker, mqtt_port);
   while (!client.connected()) {
        String client_id = "esp32-client-";
        client_id =client_id+ String(WiFi.macAddress());

        Serial.printf("The client %s connects to the public MQTT broker\n", client_id.c_str());
        if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
            Serial.println("Public MQTT broker connected");
        } else {
            Serial.print("failed with state ");
            Serial.print(client.state());//1 , 2 , 5
            delay(2000);
        }
    }
    Serial.println("After Connect MQTT");
    client.publish(topic_publish1, "Hi, I'm ESP32 ^^");
    //client.publish(topic_publish, "Hi, I'm ESP32 ^^");
   config.api_key= API_KEY;
   auth.user.email= "asmaaabdelkader123@gmail.com";
   auth.user.password="asmaa1234567";

   config.database_url= DATABASE_URL;
   Firebase.begin(&config,&auth);
   Serial.println("connect");
   
   pinMode(trig_pin,OUTPUT);//Transmitter
  pinMode(echo_pin,INPUT) ; 

}
  int heart;
  char data[32];

  const double SOUND_SPEED =0.034;
  long duration;
  float distanceCm;


void loop() { 
  heart=analogRead(pin);
  int heartRate=map(heart,0,4095,50,120);
  sprintf(data,"%d",heartRate);
  Serial.println("data");

  client.publish(topic_publish2,data);

    digitalWrite(trig_pin,LOW);
    delayMicroseconds(2);
    digitalWrite(trig_pin,HIGH);
    delayMicroseconds(10);
    digitalWrite(trig_pin,LOW);
    duration=pulseIn(echo_pin,HIGH);
    distanceCm=(SOUND_SPEED*duration)/2;
    Serial.print("Distance (cm): ");
    Serial.println(distanceCm);
      String ledState;
      String ledState2;
      String path;

  if (Firebase.RTDB.getString(&fbdo,"/INFO",&ledState)&&(distanceCm<=40)){
        Serial.println("entered");
        for(int i=2;i<22;i++){
          ledState2+=ledState[i];
        }}

        ledState="";
        path="/INFO/"+ledState2+"/label";
        Serial.println(ledState2);
        Serial.println(path);
        
        if (Firebase.RTDB.getString(&fbdo,path,&ledState)){
          Serial.println(ledState);
          client.publish( topic_publish1,ledState.c_str());
          Serial.println("published");
        }
        //speaker 
        tts.setPitch(3);
        tts.sayText(ledState.c_str());
         Serial.println(ledState);
         
      if(Firebase.RTDB.deleteNode(&fbdo,path)){
        Serial.println(ledState2);}

   
   delay(500);
}

  





