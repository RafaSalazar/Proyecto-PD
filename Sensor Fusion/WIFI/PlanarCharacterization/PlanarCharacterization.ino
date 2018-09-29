  #include <ESP8266WiFi.h>
  
  #define     LED0      2 
  
  char*       serverSSID;             
  char*       serverPassword;          

  String MessageClient = "";
  String MessageComplete = "";
  String B = "";
  
  int cont = 1;
  int distant = 1;
  
  long t1 = millis();
  long t2;
  long dt;
  
  bool readRSSI = false;
  bool printInfo = false;;
  bool blinkState = false;
  bool showData= false;
  
  #define maxClient  4
  
  WiFiServer  PDServer(9001);
  WiFiClient  PDClient[maxClient]; 


  void setup()
  {
    Serial.begin(115200);
    pinMode(LED0, INPUT);
    Serial.println();
    SetWifi("ESP_RASS", "");
  }


  void loop()
  {
    
    t2 = millis();
    dt = t2-t1;
    t1=t2;
    AvailableClients();
    AvailableMessage();
    
      
    if(PDClient[0].available() && readRSSI){
      
      printInfo = true;
      Serial.print(dt);
      Serial.println(MessageComplete);
      MessageComplete="";
      blinkState = !blinkState;
      digitalWrite(LED0, blinkState);
    }else{
      MessageComplete="";
      WiFi.disconnect(true);
      Serial.print("-");
      delay(100);
    }

    if(Serial.available()){
        char a = Serial.read();
        B +=a; 
        if(a=='\n'){
          Serial.println("");
          Serial.println(B);
          if(B.substring(0,3) == "lol"){
            readRSSI = true;
            printInfo = true;
            Serial.print("Distancia: ");
            Serial.println(distant);
            MessageComplete="";
            delay(500);
          }else if(B.substring(0,3) == "pop"){
            cont = 0;
            distant = distant + 1;
            readRSSI = false;
            printInfo= false; 
              }
          B="";
          }
      }
  }

  void SetWifi(char* Name, char* Password)
  {
    WiFi.disconnect();
    WiFi.mode(WIFI_AP_STA);
    Serial.println("WIFI Mode : AccessPoint Station");
    
    serverSSID      = Name;
    serverPassword  = Password;
    
    WiFi.softAP(serverSSID, serverPassword);
    Serial.println("WIFI < " + String(serverSSID) + " > started");
    delay(1000);

    IPAddress IP = WiFi.softAPIP();
    Serial.print("AccessPoint IP : ");
    Serial.println(IP);
    Serial.print("AccessPoint MC : ");
    Serial.println(String(WiFi.softAPmacAddress()));

    PDServer.begin();
    PDServer.setNoDelay(true);
    Serial.println("Server Started");
  }

  void AvailableClients()
  {   
    if (PDServer.hasClient())
    {
      if(digitalRead(LED0) == HIGH) digitalWrite(LED0, LOW);
      
      for(uint8_t i = 0; i < maxClient; i++)
      {
        if (!PDClient[i] || !PDClient[i].connected())
        {
          if(PDClient[i])
          {
            PDClient[i].stop();
          }
          if(PDClient[i] = PDServer.available())
          {
            Serial.println("New Client: " + String(i));
          }
          continue;
        }
      }
      WiFiClient PDClient = PDServer.available();
      PDClient.stop();
    }
  }

  void AvailableMessage()
  {
    for(uint8_t i = 0; i < maxClient; i++)
    {
      if (PDClient[i] && PDClient[i].connected() && PDClient[i].available())
      {
          if(PDClient[i].available())
          {
            MessageClient = PDClient[i].readStringUntil('\r');
            PDClient[i].flush();
            if(printInfo){
              MessageClient.replace("\n\n","\n");
              MessageClient.replace("\n",",");
              MessageComplete += MessageClient;
            }

          }
      }
    }
  }

