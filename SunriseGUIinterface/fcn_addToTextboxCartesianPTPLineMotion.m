function fcn_addToTextboxCartesianPTPLineMotion(eef_pos)
%% About:
% This function is used to add a line motion 
% command into the commandline interface of the gui.

%% Areguments:
% eef_pos: cell array representing distination position of EEF of the robot.

% Copyright: Mohammad SAFEEA, 12-July-2018

h=findobj(0,'tag','txt_CommandLine');
st=get(h,'String');

index=0;
if isempty(st)
    index=1;
else
    index=max(size(st))+1;
end

command='moveLine';
for i=1:6
    command=[command,'_',num2str(eef_pos{i})];
end
st{index}=command;

set(h,'String',st);
end