function [ signalFiltered ] = bandpassFilter( signal, fs, f1, f2 )
%https://www.mathworks.com/matlabcentral/answers/515736-apply-a-bandpass-filter-in-freq-domain
%   Detailed explanation goes here

fn = fs/2;
% f1 = 150; % Hz
% f2 = 450; % Hz
wn = [f1 f2]/fn;
[z,p,k] = butter(20,wn,'bandpass');
[sos,g] = zp2sos(z,p,k);
% figure
% freqz(sos,2^14,fs);   % x is the main signal
% set(subplot(2,1,1), 'XLim',[0 200E3])                   % ‘Zoom’ Plot
% set(subplot(2,1,2), 'XLim',[0 200E3])                   % ‘Zoom’ Plot
signalFiltered = filtfilt(sos,g,signal);


end

