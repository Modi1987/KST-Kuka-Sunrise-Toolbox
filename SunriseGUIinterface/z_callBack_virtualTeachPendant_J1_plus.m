function z_callBack_virtualTeachPendant_J1_plus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J1 in positive direction');
virtual_smartPad_w_joints_command(1)=1;
end