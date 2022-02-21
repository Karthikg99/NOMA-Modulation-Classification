clc;
clear all;
close all;
d0=1;%1 meter
x:y:z
d1=750, d2=550, d3=450
d=500;%meter
LightSpeedC=3e8;
Freq=900e6;
TXAntennaGain=1; %db
RXAntennaGain=1; %db
PTx=100; % i.e. 100 watt assumptation
PathLossExponent=2.7; %Urban cellular radio
PTxdB=10*log10(PTx);
Wavelength=LightSpeedC/Freq;
Pr0=PTxdB + TXAntennaGain + RXAntennaGain- (10*PathLossExponent*log10(4*pi/Wavelength))
rstate = randn('state');
randn('state', d);
GaussRandom= (randn*0.1+0);
Pr1=Pr0-(10*2* log10(d/d0))+GaussRandom
