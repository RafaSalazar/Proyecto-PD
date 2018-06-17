function varargout = caracterizacionWifi(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @caracterizacionWifi_OpeningFcn, ...
                   'gui_OutputFcn',  @caracterizacionWifi_OutputFcn, ...
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


function caracterizacionWifi_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

delete(instrfindall);
global takeData;
takeData = false;
global serialPort;
global point;
global saveData;
global count;
global maxPoint;
maxPoint = 50;
saveData = false;
count = 1;
serialPort = serial('COM10','BaudRate',38400,'terminator', 'LF');
fopen(serialPort);
point=0;
set(handles.CountPoint,'String',point);


function varargout = caracterizacionWifi_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function Start_Callback(hObject, eventdata, handles)
global takeData;
global serialPort;
global point;
global saveData;
global count;
global M;
global maxPoint;
j = 1;
takeData = true;
carry = (point-1)*maxPoint;
set(handles.CountPoint,'String',point);

while(takeData)
    dataWifi = fscanf(serialPort)
    set(handles.Data,'String',dataWifi);
    if (saveData) && (count<(maxPoint+1))
        RSSI = zeros(1,8)
        k = strfind(dataWifi,',')
        for h = 1:length(k)-1
            RSSI(2*h-1) = str2double(dataWifi(k(h+1)+2));
            RSSI(2*h) = str2double(dataWifi(k(h+1)+3:k(h+1)+5));
        end
        M(carry+count,:) = RSSI;
        count = count +1;
    end
    set(handles.CountPoint,'String',j);
    j=j+1
end


function takePoint_Callback(hObject, eventdata, handles)
global saveData
global count;
global point;
global maxPoint;
global M;
saveData = true;
count = 1;
point = point+1;
M((point-1)*maxPoint+1,:) = point;


function Stop_Callback(hObject, eventdata, handles)
global takeData; 
global saveData;
global M;
takeData = false;
if saveData
    csvwrite('Caracterizacion.txt',M);
end
saveData = false;