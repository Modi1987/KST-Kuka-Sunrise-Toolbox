function [  ] = setBlueOff( t )
%% This function is used to set off the blue light of the KUKA iiwa 7 R 800.
% function [  ] = setBlueOff( t )
% This function is used to set off the blue light of the KUKA iiwa 7 R 800.
% t: is the TCP/IP connection
% Copy right, Mohammad SAFEEA, 3rd of May 2017



theCommand='blueOff';
fprintf(t, theCommand);
message=fgets(t);
end
