
clc;clear all;
for i=1:5000

    t=0:0.1:2*pi;
    x=randi([0,1],1,length(t));
    [y,w,z]=tx_modulate(x,1);  %1:BPSK

    signal_modulation = y';
% length(signal_modulation)
    weather_condition = 6;
    mobile_condition = 1;
    count_snr=3;
    SNRindB=10:0.1:12;
    [h] = ChannelModel_Motionless_Ka(signal_modulation,weather_condition);%???????????????
    % length(h)
    [g] = mobile_channel(signal_modulation,mobile_condition);%??????????????
    % length(g)
    noise = awgn(signal_modulation,SNRindB(count_snr),'measured')-signal_modulation;%????  
    % length(noise)
    dd=h.*g;
    % length(dd)
    tt=dd.*signal_modulation';
    % length(tt)
    % scatterplot(tt);
    zz=tt+noise';
    % scatterplot(zz);

    % hold on;
    for j=1:length(zz)
        z(j)=abs(zz(j));
    end
    figure;
    plot(1:length(zz),z);
    saveas(gca,['../picture/BPSK/' num2str(i) '.jpg']);
    close;
end
