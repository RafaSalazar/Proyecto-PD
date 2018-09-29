close all
clear all
clc

%Directorio del archivo
mainD = 'C:\Users\rafae\Desktop\Prueba Cancha 19-9-18\';

%Nombre del archivo
fileName = 'Caracterizacion_7x7_5mts_grid_40mtsArea.txt';

%Nombre de los datos de clientes
clientName = 'Client';
%Obtener numero de muestras y vector de RSSI de cada cliente
fid = fopen(strcat(mainD,fileName),'r');
[numSamples,M] = splitData(fid);

%-----Configuracion de la prueba
distBetweenPoints = 5;
Area = 40;
posCx = [0 20 40 0 40 0 20 40];
posCy = [0 0 0 20 20 40 40 40];

%Obtener Distancia VS RSSI de cada cleinte en una misma matris
DistVSRssi = assignDistance(M,distBetweenPoints,Area,posCx,posCy,numSamples);

%Guardar Distancia VS RSSI de cada cliente en un archivo individual
saveClient(DistVSRssi,clientName)

%Plot Clientes
[w,numberClient] = size(M);
plotClientData(mainD,clientName,numberClient)

