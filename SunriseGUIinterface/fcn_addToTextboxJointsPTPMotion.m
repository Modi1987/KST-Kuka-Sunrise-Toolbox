function fcn_addToTextboxJointsPTPMotion(jPos)
%% About:
% This function is used to add a joints space PTP motion 
% command into the commandline interface of the gui.

%% Areguments:
% jPos: cell array representing distination pose of the robot.

% Copyright: Mohammad SAFEEA, 12-July-2018

h=findobj(0,'tag','txt_CommandLine');
st=get(h,'String');

index=0;
if isempty(st)
    index=1;
else
    index=max(size(st))+1;
end

command='moveJoints';
for i=1:7
    command=[command,'_',num2str(jPos{i})];
end
st{index}=command;

set(h,'String',st);
end