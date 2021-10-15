clc;
clear all;
close all;
d0=1;%1 meter
%x:y:z

d=[100,500,550,600,650,700,750];%meter
for i = 1:length(d)
LightSpeedC=3e8;
Freq=900e6;
TXAntennaGain=1; %db
RXAntennaGain=1; %db
PTx=100; % i.e. 100 watt assumptation
PathLossExponent=2.7; %Urban cellular radio
PTxdBm=10*log10(PTx*1000);
Wavelength=LightSpeedC/Freq;
Pr0=PTxdBm + TXAntennaGain + RXAntennaGain- (10*PathLossExponent*log10(4*pi/Wavelength));
rstate = randn('state');
randn('state', d(i));
GaussRandom= (randn*0.1+0);
Pr1=Pr0-(10*2* log10(d(i)/d0))+GaussRandom;

disp("Pr1: "+Pr1+" at distance:"+d(i)+" meters");
pr1_arr(i)=Pr1;
end