function [  ] = setPin11Off( t )
%% This function is used to set off the pin11 of the KUKA iiwa 7 R 800.
% function [  ] = setPin11Off( t )
% This function is used to set off the pin11 of the KUKA iiwa 7 R 800.
% t: is the TCP/IP connection
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='pin11off';
fprintf(t, theCommand);
message=fgets(t);
end
