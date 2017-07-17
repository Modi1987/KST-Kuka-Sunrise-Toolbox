function [ output_args ] = performEventFunctionAtDoubleHit( t)
%PERFORMEVENTFUNCTIONATDOUBLEHIT 
% this function is used to detect the double touch in the z direction of the
% robot end effector.
global binaryValArray
global averageVal
threshhold=4;
[ f ] = getEEF_Force( t );
zforceVal=f{3}-3.3989;
zforceVal=-zforceVal;
if(zforceVal>0)
else
    zforceVal=0;
end

a=0.7;
averageVal=(averageVal*a+zforceVal*(1-a));

binaryVal=averageVal>threshhold;


binaryValArray(1)=[];
binaryValArray=[binaryValArray;binaryVal];

n=max(max(size(binaryValArray)));
sum=0;
    for i=1:(n-1)
        if((binaryValArray(i+1)-binaryValArray(i))==1)
            sum=sum+1;
        else
        end
    end
sum
    if(sum==2)
        EventFunctionAtDoubleHit();
        binaryValArray=binaryValArray*0;
    end
end

