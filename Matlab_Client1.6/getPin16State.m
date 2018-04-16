function [ state ] = getPin16State( t_kuka )
%% This function is used to get the state of the input pin 16
%     on the media flange, of the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = getPin16State( t )

%% About:
% This function is used to get the state of the input pin number 16
%  on the media flange, of the KUKA iiwa 7 R 800.

%% Arreguments:
% t: is the TCP/IP connection.
% state:  represents the state of the input-pin. It is an integer equal to
% 1 when the pin state is true, or it is an integer equal to 0 when the
% pin state is false. Otherwise, if the pin is not connected the return
% value is empty.

% Copyright, Mohammad SAFEEA, 9th of May 2017

theCommand='getPin16';
fprintf(t_kuka, theCommand);
message=fgets(t_kuka);
state=str2num(message);
end


