function varargout = Prueba_Wifi_IMU(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prueba_Wifi_IMU_OpeningFcn, ...
                   'gui_OutputFcn',  @Prueba_Wifi_IMU_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function Prueba_Wifi_IMU_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

hold all
delete(instrfindall);
global takeData;
takeData = false;
global a;
global serialPort;
global mpu;
global data;
global j;
global a1;
global a2;
global a3;
global a4;
global a5;
global a6;
global saveData;
global cont;
global t1;
saveData = false;
cont = 1;
t1 = clock()
a=arduino;
mpu=i2cdev(a,'0x68'); %mpu adress 0x68
writeRegister(mpu, hex2dec('B6'), hex2dec('00'), 'int16'); %reset
serialPort = serial('COM6','BaudRate',38400,'terminator', 'LF');
fopen(serialPort);
data=zeros(10000,14,'int8');
j=1;
a1 = animatedline('Color',[1 0 0]); 
a2 = animatedline('Color',[0 1 0]);
a3 = animatedline('Color',[0 0 1]);
a4 = animatedline('Color',[1 1 0]); 
a5 = animatedline('Color',[0 1 1]);
a6 = animatedline('Color',[1 0 1]);
legend('Accel_x','Accel_y','Accel_z','Giro_x','Giro_y','Giro_z')


function varargout = Prueba_Wifi_IMU_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function Start_Callback(hObject, eventdata, handles)
global takeData;
global mpu;
global data;
global serialPort;
global j;
global a1;
global a2;
global a3;
global a4;
global a5;
global a6;
global saveData;
global cont;
global M;
global t1;
takeData = true;
while(takeData) 
    x=1;
    for i=59:72 % 14 Data Registers for Accel,Temp,Gyro
        data(j,x)= readRegister(mpu, i, 'int8');
        x=x+1;
    end
    dataWifi = fscanf(serialPort)
    y=swapbytes(typecast(data(j,:), 'int16'))
    set(handles.text3,'String',dataWifi);
    if saveData
        t2=clock()
        dt = etime(t2,t1)*1000
        t1 = t2;
        RSSI = zeros(1,8);
        k = strfind(dataWifi,',');
        for h = 1:length(k)-1
            RSSI(2*h-1) = str2double(dataWifi(k(h+1)+2));
            RSSI(2*h) = str2double(dataWifi(k(h+1)+3:k(h+1)+5));
        end
        values(1:6) = [y(1:3) y(5:7)];
        M(cont,:) = [cont dt values RSSI];
        cont = cont +1;
    end
    addpoints(a1,j,double(y(1)));
    addpoints(a2,j,double(y(2)));
    addpoints(a3,j,double(y(3)));
    addpoints(a4,j,double(y(5)));
    addpoints(a5,j,double(y(6)));
    addpoints(a6,j,double(y(7)));
    j=j+1;
    drawnow limitrate
end


function stop_Callback(hObject, eventdata, handles)
global takeData; 
global saveData;
global M;
takeData = false;
if saveData
    csvwrite('TrackingTest.txt',M);
end
saveData = false;


function editText_Callback(hObject, eventdata, handles)


function editText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    get(handles.editText)
end


function saveData_Callback(hObject, eventdata, handles)
global saveData
saveData = true;
