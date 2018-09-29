function [numSamples,M] = splitData(fid)
    conter = false;
    cont = 0;
    index = 1;
    while ~feof(fid)
       line = fgets(fid);
       if line(1) == '-'
           continue
       end
       if line(1) == 'P'
           if (length(line) == 10) && (line(8) == '1')
               conter = true;
               continue;
           end
           if (length(line) == 10) && (line(8) == '2')
               numSamples = cont;
               conter = false;
               continue
           end
           continue
       end
       k = strfind(line,',');
       if conter == true
           cont = cont+1;
       end
       for i = 1:length(k)
           if (i < length(k)) && (k(i+1) == k(i)+1)
              continue
           end
           j = str2double(line(k(i)+2));
           rssi = str2double(line((k(i)+4):(k(i)+5)));
           M(index,j) = rssi;
       end
       index = index+1;
    end

end