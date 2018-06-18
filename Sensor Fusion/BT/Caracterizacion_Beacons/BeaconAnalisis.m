close all
clear all
clc
data = csvread('Data.txt')
[m,n] = size(data)

x = zeros(m*n/3,1);
y = zeros(m*n/3,1);
z = zeros(m*n/3,1);
c = zeros(m*n/3,3);
cmap = [0 0 0;
    0 255 255;
    255 0 255;
    255 255 0;
    255 0 0;
    0 255 0;
    0 0 255;
    41 0 104;
    250 113 0
    ]

meanx = zeros(n/3,1);
meany = zeros(n/3,1);
meanz = zeros(n/3,1);

out = zeros(m*n/3,1);
for i = 1:n/3
    x(300*(i-1)+1:300*i) = data(:,(i-1)*3+1);
    y(300*(i-1)+1:300*i) = data(:,(i-1)*3+2);
    z(300*(i-1)+1:300*i) = data(:,(i-1)*3+3);
    
    for j = 1:300
        c(300*(i-1)+j,:) = cmap(i,:);
    end
    meanx(i) = mean(x(300*(i-1)+1:300*i))
    meany(i) = mean(y(300*(i-1)+1:300*i))
    meanz(i) = mean(z(300*(i-1)+1:300*i))
    out(300*(i-1)+1:300*i) = i
end

scatter3(x,y,z,5,c)
hold on
scatter3(meanx,meany,meanz,1000)
hold on

for loop = 1:9
  VectorOfHandles(loop) = scatter3(nan,nan,nan,loop*10,cmap(loop,:)/255);
end
legend(VectorOfHandles,{'1','2','3','4','5','6','7','8','9'});
hold off

M = [x y z out]

csvwrite('TrainData.txt',M)
csvwrite('TrainOut.txt',out)
