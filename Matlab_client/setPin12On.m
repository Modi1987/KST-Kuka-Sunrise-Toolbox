function [  ] = setPin12On( t )
%% This function is used to set on the pin12 of the KUKA iiwa 7 R 800.
% function [  ] = setPin12On( t )
% This function is used to set on the pin12 of the KUKA iiwa 7 R 800.
% t: is the TCP/IP connection
% Copy right, Mohammad SAFEEA, 6th of May 2017

theCommand='pin12on';
fprintf(t, theCommand);
message=fgets(t);
end
