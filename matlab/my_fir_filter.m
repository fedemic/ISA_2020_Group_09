fs=10000 %% sampling frequency
f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)

N=8; %% filter order
nb=8; %% number of bits

T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

x1=sin(2*pi*f1*tt); %% first sinewave
x2=sin(2*pi*f2*tt); %% second sinewave

x=(x1+x2)/2; %% input signal

[bi, bq]=myfir_design(N, nb); %% filter design

y=filter(bq, 1, x); %% apply filter

%% plots
figure
plot(tt,x1, '--o', 'linewidth', 2);
hold on
grid on
plot(tt,x2, '--o', 'linewidth', 2);
plot(tt,x, '--o', 'linewidth', 2);
plot(tt, y, '--o', 'linewidth', 2);
ylabel('Amplitude [V]');
xlabel('Time [s]');
legend('x1', 'x2', 'x', 'y');
title('Filter system')

%% quantize input output
xq=floor(x*2^(nb-1));
idx=find(xq==2^(nb-1));
xq(idx)=2^(nb-1)-1;

yq=floor(y*2^(nb-1));
idy=find(yq==2^(nb-1));
yq(idy)=2^(nb-1)-1;

%% save input and output and coeff
fp=fopen('../VHDL/sim/data_files/samples.txt','w');
fprintf(fp,'%d\n', xq);
fclose(fp);

fp=fopen('../VHDL/sim/data_files/resultsm.txt', 'w');
fprintf(fp, '%d\n', yq);
fclose(fp);

fp=fopen('../VHDL/sim/data_files/coeff.txt', 'w');
fprintf(fp, '%d\n', bi);
fclose(fp);