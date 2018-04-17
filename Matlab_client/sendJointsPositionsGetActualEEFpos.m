function  [ EEF_POS ] = sendJointsPositionsGetActualEEFpos( t_Kuka ,jPos) 
%% Supported by KST 1.2 and above

%% Syntax
%  [ EEF_POS ] = sendJointsPositionsGetActualEEFpos( t ,jPos) 

%% About
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-smart-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t_Kuka: is the TCP/IP connection object

%% Return value
% EEF_POS: 6x1 cell array of EEF position

% Copy right, Mohammad SAFEEA, 13th-March-2018

theCommand='jpEEfP_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[ EEF_POS,n ]=getDoubleFromString(message);
end

function [jPos,j]=getDoubleFromString(message)
n=max(max(size(message)));
j=0;
numString=[];
for i=1:n
    if message(i)=='_'
        j=j+1;
        jPos{j}=str2num(numString);
        numString=[];
    else
        numString=[numString,message(i)];
    end
end
end