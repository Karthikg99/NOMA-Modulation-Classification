function [y,m]=modulation(c)
a=[3;4;8];
b=randi([1 7],1,1);

sym=1024/4;
filterCoeffs = rcosdesign(0.35, 4, 4);
switch(c)
    case 1 
        x1=randi([0 1],[sym,4]);
        
        
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
%         
%         disp('y'); 
%         disp(x2');      
        y=qammod(x2,16,'UnitAveragePower',true);
      
        m='qam16';
    case 2
         x1=randi([0 1],[sym,6]);
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
        y=qammod(x2,64,'UnitAveragePower',true);
        m='qam64';
    case 3
        x1=randi([0 1],[sym,2]);
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
        y=pskmod(x2,4);
        m='qpsk';
    case 4
        x1=randi([0 1],[sym,3]);
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
        y=pskmod(x2,8);
        
        m='psk8';
    
%     case 5
%          gfskMod = comm.CPMModulator('ModulationOrder', 4, 'FrequencyPulse', 'Gaussian', ... 
%                'BandwidthTimeProduct', 0.5, 'ModulationIndex', 1);
%            x1=-3+(randi([0 3],[sym/8,1])*2);
% 
% % Modulate
%         y = gfskMod(x1)';
%         m='gfsk';
    case 5
        
x1=randi([0 1],[sym,2]);
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
        y=pammod(x2,4);
       m='pam8';
       
    case 6
        x1=randi([0 1],[sym,1]);
        x2=[];
        for b=1:sym
            c=int2str(x1(b,:));
            c=c(~isspace(c));
            c=bin2dec(c);
            x2=[x2 c];
        end
        y = pskmod(x2,2);
        m='bpsk';
%     case 8 
%          hMod = comm.CPFSKModulator(8, 'BitInput', true);
%            x1=randi([0 1],sym/8*3,1);
% 
% % Modulate
%         y = hMod(x1)';
%         m='cpfsk';
       
end
y = filter(filterCoeffs, 1, upsample(y,4))';
end