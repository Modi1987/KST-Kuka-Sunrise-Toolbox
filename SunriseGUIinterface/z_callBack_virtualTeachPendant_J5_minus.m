function z_callBack_virtualTeachPendant_J5_minus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J5 in negative direction');
virtual_smartPad_w_joints_command(5)=-1;
end