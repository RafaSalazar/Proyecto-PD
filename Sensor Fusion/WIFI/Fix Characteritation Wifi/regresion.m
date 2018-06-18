close all
clear all
clc
fid1 = fopen('CaracterizacionWifi.txt','r'); %# open csv file for reading
count = 1;
maxPoint = 50;
point = 1;
while ~feof(fid1) && point <= 64
    carry = (point-1)*maxPoint
    line = fgets(fid1);
    line = fgets(fid1);
    for i = 1:50
        line = fgets(fid1);
        RSSI = zeros(1,8);
        k = strfind(line,',')
        for h = 1:length(k)-1
            if line(k(h+1)+2)+48 == 61 || line(k(h+1)+2)+48 == 92 || line(k(h+1)+2)+48 == 58
                continue
            end
            RSSI(2*h-1) = str2double(line(k(h+1)+2));
            RSSI(2*h) = str2double(line(k(h+1)+3:k(h+1)+5));
        end
        M(carry+count,:) = RSSI;
        count = count +1;
    end
    point = point+1;
    count = 1;
end
fclose(fid1);
csvwrite('CaracterizacionTabulada.txt',M);
%%
index = 1
for i = 1:8
    for j = 1:8
        dist1 = sqrt((i+1)^2+(j+1)^2)
        dist2 = sqrt((i+1)^2+(11-(j+1))^2)
        dist3 = sqrt((11-(i+1))^2+(j+1)^2)
        dist4 = sqrt((11-(i+1))^2+(11-(j+1))^2)
        for k = 1:50
            %1,2,4,3
            C1(index,:) = [dist1 M(index,2)];
            C2(index,:) = [dist2 M(index,4)];
            C3(index,:) = [dist3 M(index,8)];
            C4(index,:) = [dist4 M(index,6)];
            index = index+1
        end
    end
end

csvwrite('Cliente1.csv',C1);
csvwrite('Cliente2.csv',C2);
csvwrite('Cliente3.csv',C3);
csvwrite('Cliente4.csv',C4);