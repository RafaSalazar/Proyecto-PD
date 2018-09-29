function DistVSRssi = assignDistance(M,distBetweenPoints,Area,posCx,posCy,maxSamples)
divInter = Area/distBetweenPoints-1;
index = 1;
[m n] = size(M);
dist = zeros(1,n);
for i = 1:divInter
    for j = 1:divInter
        for l = 1:n
            dist(l) = sqrt((posCx(l)-j*distBetweenPoints)^2+(posCy(l)-i*distBetweenPoints)^2);
            DistVSRssi((maxSamples*(index-1)+1):maxSamples*index,(2*l-1):2*l) = [ones(maxSamples,1)*dist(l) M((maxSamples*(index-1)+1):maxSamples*index,l)];
            
        end
        index=index+1;
    end
end

end