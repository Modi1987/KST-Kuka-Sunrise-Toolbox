function [  ] = setBlueOn( t )
%% This function is used to set on the blue light of the KUKA iiwa 7 R 800.
% function [  ] = setBlueOn( t )
% This function is used to set on the blue light of the KUKA iiwa 7 R 800.
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='blueOn';
fprintf(t, theCommand);
message=fgets(t);
end
