  #include <ESP8266WiFi.h>
  
  #define     LED0      2 
  
  char*       serverSSID;             
  char*       serverPassword;          

  String MessageClient = "";
  String MessageComplete = "";
  String B = "";
  
  int distant = 0;
  int cont = 0;
  
  long time1 = millis();
  long time2;
  long laps = 0;
  
  bool readRSSI = false;
  bool printInfo = false;;
  
  #define maxClient  4
  
  WiFiServer  PDServer(9001);
  WiFiClient  PDClient[maxClient];

  void setup()
  {
    Serial.begin(38400);
    pinMode(LED0, INPUT);
    Serial.println();
    SetWifi("ESP_RASS", "");
  }
  

  
  void loop()
  {
    AvailableClients();
    AvailableMessage();
    time2 = millis();
    laps = time2-time1;
    time1 = time2;
    
    if(readRSSI){
      if(laps<150){
        delay(100);
      }
      Serial.println(MessageComplete);
      MessageComplete="";
    }else{
      WiFi.disconnect(true);
      Serial.print("-");
      delay(100);
    }

    if(Serial.available()){
        char a = Serial.read();
        B +=a; 
        if(a=='\n'){
          if(B.substring(0,4) == "take"){
            readRSSI = true;
            printInfo = true;
            Serial.println("");
            Serial.print("Punto: ");
            Serial.println(distant);
            MessageComplete="";
            cont=0;
            distant+=1;
            delay(500);
          }else if(B.substring(0,4) == "stop"){
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

