file = 'logtest_A.bin';

[acc, numpts] = readdata(file);
t = 0:0.004:(numpts-1)*0.004;

figure(1)
plot(t, acc)
legend('X','Y','Z')
title('Acelerómetro')