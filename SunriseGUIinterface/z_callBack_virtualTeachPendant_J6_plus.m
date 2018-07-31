function z_callBack_virtualTeachPendant_J6_plus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J6 in positive direction');
virtual_smartPad_w_joints_command(6)=1;
end