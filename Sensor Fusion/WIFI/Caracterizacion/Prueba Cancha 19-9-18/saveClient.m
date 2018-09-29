function saveClient(DistVSRssi,clientName)
    [m n] = size(DistVSRssi);
    n = n/2;
    for i = 1:n
        C = DistVSRssi(:,(2*i-1):2*i);
        [mc nc] = size(C);
        j = 1;
        while (j <= mc) && i~=7
           if  C(j,2) == 0
               C1 = C(1:(j-1),:);
               C2 = C(j+1:length(C),:);
               newC = [C1;C2];
               j = j-1;
               mc = length(newC);
               C=newC;
           end
           j=j+1;
        end
        csvwrite(strcat(clientName,int2str(i),'.csv'),C)
    end
end