clear all;
clc;
% rng(12345);
fs=900e6;
fD_eva=80;
%pathdelay_eva=[0 30 150 310 370 710 1090 1730 2510]*1e-9;
%avgpathgain_eva=[0.0 -1.5 -1.4 -3.6 -0.6 -9.1 -7.0 -12.0 -16.9];
% Pr1: -60.4701 at distance:100 meters
% Pr1: -74.8189 at distance:500 meters
% Pr1: -75.5571 at distance:550 meters
% Pr1: -76.1371 at distance:600 meters
% Pr1: -77.1048 at distance:650 meters
% Pr1: -77.6123 at distance:700 meters
% Pr1: -78.2344 at distance:750 meters
%loss=[-30.4700877872899,-44.8189408627481,-45.5570879836464,-46.1371328886116,-47.1048365575309,-47.6122802822269,-48.2343944786525];
%[-60.4700877872899,-74.8189408627481,-75.5570879836464,-76.1371328886116,-77.1048365575309,-77.6122802822269,-78.2343944786525]
loss(1)=-74.8189408627481;
loss(2)= -60.4700877872899; 
main='100&500w_shuffle';
part='100';
for i=1:2
avgpathgain_eva_ls=avgpathgain_eva-loss(i);
rayChan{i} = comm.RayleighChannel('SampleRate',fs,...
    'PathDelays',0,...
    'AveragePathGains',loss(i),...
    'PathGainsOutputPort',true);
M = 16;
x = (0:M-1)';
y = qammod(x,M);
[yy,pg]=rayChan{i}(y);
% pg(1,:)
coeff(i)=sum(abs(pg(1,:)).^2);

end

alpha=combo_gen_two_user();

BW = 10^6;            %Bandwidth = 1 MHz
No = -174 + 10*log10(BW);    %Noise power (dBm)            %
no = (10^-3)*db2pow(No);    %Noise power (linear scale)
% disp(no);
count=0;
for i=1:40
    p1=100*alpha(i,1);
    p2=100*alpha(i,2);

    s(i,1)=BW*log2(1+(p1*coeff(1))/(p2*coeff(1)+no));
    s(i,2)=BW*log2(1+(p2*coeff(2))/no);
    
    r(i)=s(i,1)+s(i,2);
    f(i)=r(i)^2/(2*(s(i,1)^2+s(i,2)^2));
    
end


[m3,i1]=max(f);
 A=alpha(i1,:);
 disp(A)
%  
tx1=zeros(150000,1024);
labels=zeros(150000,5);
mod_comb=[3 4;4 1;3 2;4 2;1 2];
a1=zeros(150000,1);
a2=zeros(5,1);
count1=0;
done=0;
h=1;

for i=1:150000
 a1(i)=fix((i-1)/30000)+1;
end
for i=1:150000
    if(rem(i,30000)==0)
        disp("label_gen "+i)
    end
 labels(i,a1(i))=1;
end
% 
rayChan_data= comm.RayleighChannel('SampleRate',fs,...
            'PathDelays',0,...
            'AveragePathGains',loss(2),...
            'PathGainsOutputPort',true);
for i=1:150000
    if(rem(i,25)==0)
        disp(i)
    end
    
    done=0;
    b=0;
    
    tx_raw=0;
    if(rem(i,1000)==0)
        rng shuffle
        rayChan_data= comm.RayleighChannel('SampleRate',fs,...
            'PathDelays',0,...
            'AveragePathGains',loss(2),...
            'PathGainsOutputPort',true);
    end
    for u=1:2
        [tx_mod,m]=modulation(mod_comb(a1(i),u));
      
        tx_raw=tx_raw+(sqrt(100*A(u))*tx_mod);
    end
    
    tx=rayChan_data(tx_raw);

    tx1(i,:)=awgn(tx,40,'measured')';
   
   
end

real1=zeros(150000,1024);
imag1=zeros(150000,1024);
for i =1:150000
    real1(i,:) = real(tx1(i,:));
    imag1(i,:) = imag(tx1(i,:));
    if(rem(i,25)==0)
        disp("splitting "+i)
    end

end

writeNPY(real1, 'noma_order_real_vh.npy');
writeNPY(imag1, 'noma_order_imag_vh.npy');
writeNPY(labels,['2user-' main '-' part 'm_labels_150K_5.npy']);
clear all;
main='100&500w_shuffle';
part='100';
real=readNPY('noma_order_real_vh.npy');
imag=readNPY('noma_order_imag_vh.npy');
dataset=zeros(150000,1024,2);

for i=1:150000
   if(rem(i,1000)==0)
    disp(i);
   end
    for j=1:1024
          dataset(i,j,1)=real(i,j);
          dataset(i,j,2)=imag(i,j);
   end
end
writeNPY(dataset,['2user-' main '-' part 'm_150k_1024_2.npy']);

% clear all;
% main='100&500w_shuffle';
% part='100';
% disp("creating second dataset");
% data1=readNPY(['2user-' main '-' part 'm_150k_1024_2.npy']);
% dataset=zeros(150000,2,1024);
% for i=1:150000
%    if(rem(i,1000)==0)
%     disp(i);
%    end
%     for j=1:1024
%           dataset(i,1,j)=data1(i,j,1);
%           dataset(i,2,j)=data1(i,j,2);
%    end
% end
% writeNPY(dataset,['2user-' main '-' part 'm_150k_2_1024.npy']);
% clear all;
main='100&500w_shuffle';
part='100';
disp("labels creation");
label=readNPY(['2user-' main '-' part 'm_labels_150K_5.npy']);
l=zeros(150000,1);
for i=1:150000
    for j=1:5
        if(label(i,j)==1)
            l(i)=j-1;
        end
    end
end
writeNPY(l,['2user-' main '-' part 'm_labels_150k_1.npy']);
