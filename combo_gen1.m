function b=combo_gen1()
a=0.1:0.01:0.99;
count=1;


for i=1:length(a)
    for j =i+1:length(a)
        sum=a(i)+a(j);
        if(sum>1) 
            break;
        end
        if((1-sum)<=a(j))
            break;
        else
          
            b(count,3)=a(i);
            b(count,2)=a(j);
            b(count,1)=1-sum;
          
%             disp(b(count,:));
            count=count+1;
        end
    end
    
end
end