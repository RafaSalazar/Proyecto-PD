function plotClientData(mainD,clientName,numberClient)
    for i = 1:numberClient
       C = csvread(strcat(mainD,clientName,int2str(i),'.csv'));
       figure('rend','painters','pos',[200 200 1000 400],'name',strcat(clientName,int2str(i)),'NumberTitle','off') 
       plot(C(:,2),C(:,1),'.b')
       xlabel('RSSI (+)')
       ylabel('Distance (m)')
       title('All samples')
    end
end