#include <SoftwareSerial.h>
SoftwareSerial Lidar(3, 2); //Rx, Tx arduino


unsigned char dta[100];
unsigned char len = 0;
int j = 0;
int n = 10;
int dist = 0;
void setup()
{
    Lidar.begin(115200);
    Serial.begin(115200);
}

void loop()
{
    while(Lidar.available()>=9)
    {
        if((0x59 == Lidar.read()) && (0x59 == Lidar.read())) //Byte1 & Byte2
        {
            unsigned int t1 = Lidar.read(); //Byte3
            unsigned int t2 = Lidar.read(); //Byte4
            t2 <<= 8;
            t2 += t1;
            if(abs(t2)<12000){
                dist = dist+t2;
              }
            t1 = Lidar.read(); //Byte5
            t2 = Lidar.read(); //Byte6
            t2 <<= 8;
            t2 += t1;
            for(int i=0; i<3; i++) 
            { 
                Lidar.read(); ////Byte7,8,9
            }
            j++;
      }
    }
    if(j == n){
        Serial.println(dist/n);
        dist = 0;
        j = 0;
      }
}
