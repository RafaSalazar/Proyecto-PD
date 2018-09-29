FName = 'LightQualiffier1'
FNumber = '17.'
LetterFile = 'C'

folder = strcat('\',FNumber,FName,'\')
fileName = strcat(FName,'.txt')
close all
clc
mainD = 'C:\Users\rafae\Downloads\dataTransfer\Hydrocontest2018_LOG';
directory = strcat(mainD,folder);
file = strcat(LetterFile,'.bin');

[ssr, numpts] = readdata(strcat(directory,'sensorCombined_',file));
[ikg, numpts] = readdata(strcat(directory,'ikgb_',file));
[gps, numpts] = readdata(strcat(directory,'GPS_',file));
[att, numpts] = readdata(strcat(directory,'attitude_',file));

t = 0:0.004:(numpts-1)*0.004;
mag = ssr(1:3,:);
acc = ssr(4:6,:);
gyr = ssr(7:9,:);
baro = ssr(10,:);

%----------------------------------------------------------
%               Guardar datos de las pruebas
%-----------------------------------------------------------

startPoint = 1;
endPoint = t(length(t));
% logitud, latitud, velocidad, accel, gyro, mag, barometro, Roll, Pitch, Yaw
P = [gps(1,startPoint/0.004:endPoint/0.004); gps(2,startPoint/0.004:endPoint/0.004); gps(4,startPoint/0.004:endPoint/0.004); acc(:,startPoint/0.004:endPoint/0.004); gyr(:,startPoint/0.004:endPoint/0.004); ikg(:,startPoint/0.004:endPoint/0.004); att(:,startPoint/0.004:endPoint/0.004)];
points = (startPoint/0.004:endPoint/0.004)*0.004;
cd(directory)
dlmwrite(fileName,P,'delimiter','\t','precision','%.9f')

%-----------------------------------------------------------
%          Graficar datos separados en archivos txt
%-----------------------------------------------------------

P = dlmread(fileName,'\t');
points = (1:length(P))*0.004;

PlotName = 'Compilado'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
subplot(1,2,1)
plot(P(1,:),P(2,:))
xlabel('Longitud');
ylabel('Latitud')
title('GPS pos')
subplot(5,2,2)
plot(points,P(3,:))
xlabel('t [s]');
ylabel('v [m/s]')
title('GPS vel')
subplot(5,2,4)
IKG_Vel = [P(3,:); P(13,:)/1000]
plot(points,IKG_Vel )
legend('Velocidad GPS','CH3');
title('GPS Vel & CH3')
subplot(5,2,6)
plot(points, P(4:6,:))
legend('X','Y','Z')
title('Acelerometro')
xlabel('t [s]')
ylabel('a [m/s^2]')
subplot(5,2,8)
plot(points, P(14:16,:))
legend('roll','pich','yaw')
title('RPY')
xlabel('t [s]')
ylabel('rad')
subplot(6,2,12)
plot(points, [P(16,:); P(12,:)/1000])
legend('yaw','CH1')
title('YAW & CH1')
xlabel('t [s]')
ylabel('rad')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'GPS_POS'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(P(1,:),P(2,:))
xlabel('Longitud');
ylabel('Latitud')
title('GPS pos')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'GPS_VEL'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(points,P(3,:))
xlabel('t [s]');
ylabel('v [m/s]')
title('GPS vel')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'Canal_3'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
IKG_T = P(13,:);
plot(points,IKG_T )
legend('CH3');
title('CH3')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'Vel_VS_CH3'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
IKG_Vel = [P(3,:); P(13,:)/1000]
plot(points,IKG_Vel )
legend('Velocidad GPS','CH3');
title('GPS Vel & CH3')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'Acelerometro'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(points, P(4:6,:))
legend('X','Y','Z')
title('Acelerometro')
xlabel('t [s]')
ylabel('a [m/s^2]')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'RPY'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(points, P(14:16,:))
legend('roll','pich','yaw')
title('RPY')
xlabel('t [s]')
ylabel('rad')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'Canal_1'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(points,P(12,:))
legend('CH1')
title('CH1')
xlabel('t [s]')
ylabel('rad')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

PlotName = 'Yaw_VS_CH1'
tamano=get(0,'ScreenSize');
fig = figure('Name',PlotName,'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)])
plot(points, [P(16,:); P(12,:)/1000])
legend('yaw','CH1')
title('YAW & CH1')
xlabel('t [s]')
ylabel('rad')

saveas(fig,strcat(PlotName,'_', LetterFile, '.png'))

cd('C:\Users\rafae\Downloads\dataTransfer')
