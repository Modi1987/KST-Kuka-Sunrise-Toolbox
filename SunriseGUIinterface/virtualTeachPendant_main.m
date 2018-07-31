function virtualTeachPendant_main()
%% Main script of the Virtual teachPendant
% Copyright: Mohammad SAFEEA, 23-July-2018

% Turn off the feedback
global read_state_var;
read_state_var=false;
% Create interface
virtualTeachPendant_Interface()
pause(1);
% Conrol loop
virtualTeachPendant_controlLoop()
% Turn on the feedback
read_state_var=true;
end