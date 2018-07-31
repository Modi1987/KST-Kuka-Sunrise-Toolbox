function [ y ] = getTheKSTDirectory( x )
%% This function is used to get the directory of the KST matlab client library
% Copyright Mohammad SAFEEA, 17th-Aug-2017
n=max(size(x));
KSTfolderName='Matlab_client';
for i=1:n
    if(x(end)=='\')        
        break;
    else
        x=x(1:end-1);
    end
end
y=[x,KSTfolderName];
end
