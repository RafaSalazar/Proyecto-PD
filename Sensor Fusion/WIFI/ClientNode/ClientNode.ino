  #include <ESP8266WiFi.h>   

  const String  clientName       = "C8";
  
  char*         serverSSID;            
  char*         serverPassword;       
  int             PDServerPort  = 9001; 
  IPAddress       PDServer(192,168,4,1); 
  WiFiClient      PDClient; 
  
  bool readRSSI = false;
  
  int distant = 10;
  int samples = 200;

  
  void setup() 
  {
    Serial.begin(115200); 
    pinMode(2, INPUT);
    digitalWrite(2,HIGH);
    Serial.println("\nI/O Pins Modes Set .... Done");
    setConnectivity();       
    connectServer();
  }

 
  void loop()
  {

    if(WiFi.status() == WL_CONNECTED){
      Serial.print(clientName);
      Serial.println(WiFi.RSSI());
      PDClient.print(clientName);
      PDClient.println( WiFi.RSSI());
      PDClient.flush();
      delay(150);
     }else{
          
      while(WiFi.status() != WL_CONNECTED)
        {
          for(int i=0; i < 10; i++)
          {
            digitalWrite(2,HIGH);
            delay(250);
            digitalWrite(2,LOW);
            delay(250);
            Serial.print(".");
          }
          Serial.println("");
        }
      connectServer();
        }
  }

  void setConnectivity()
  {
    
    if(WiFi.status() == WL_CONNECTED)
    {
      WiFi.disconnect();
      WiFi.mode(WIFI_OFF);
      delay(50);
    }
    
    WiFi.mode(WIFI_STA);
    WiFi.begin("ESP_RASS", "");
    Serial.println("!--- Connecting To " + WiFi.SSID() + " ---!");

    while(WiFi.status() != WL_CONNECTED)
    {
      for(int i=0; i < 10; i++)
      {
        delay(500);
        Serial.print(".");
      }
      Serial.println("");
    }

    Serial.println("OK");
    
  }

  void connectServer()
  {
    PDClient.stop();
    if(PDClient.connect(PDServer, PDServerPort))
    {
      Serial.println    ("<" + clientName + "-CONNECTED>");
      PDClient.println ("<" + clientName + "-CONNECTED>");
    }
    
  }

