%% Example of using KST class for interfacing with KUKA iiwa robots

% Utilizing the general porpuse functions of the KST
% Code can be utilized off-line, connection to the rbot is not required

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 25th-June-2018

close all;clear;clc;
%% Create the robot object
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST('',arg1,arg2,Tef_flange); % create the object

%% Generate a random pose, angular velocities and accelerations
q=rand(7,1);
disp('Random pose generated with joints angles:');
disp(q);
dq=rand(7,1);
disp('Random angular velocities generated with values:');
disp(dq);
d2q=rand(7,1);
disp('Random angular accelerations generated with values:');
disp(d2q);

%% Calculate the direct kinematics
[Tt,Jin]=iiwa.gen_DirectKinematics(q);
disp('EEF transform matrix calculated using direct kinematics:');
disp(Tt);
disp('Jacobean calculated at EEF is:');
disp(Jin);

%% Calculate the centrifugal matrix
C=iiwa.gen_CentrifugalMatrix(q,dq);
disp('Centrifugal matrix of the manipulator is:');
disp(C);

%% Calculate coriolis matrix
B=iiwa.gen_CoriolisMatrix(q,dq);
disp('Coriolis matrix of the manipulator is:');
disp(B);

%% Calculate inverse dynamics
taw= iiwa.gen_InverseDynamics(q,dq,d2q);
disp('Torques calcualted from inverse dynamics:')
disp(taw);

%% Calculate direct dynamics
d2q_s=iiwa.gen_DirectDynamics(q,dq,taw);
disp('Angular accelerations calcualted from direct dynamics:')
disp(d2q_s);

%% Comparison
% Compare the angular acceleration values d2q with the calculated angular
% accelerations d2q_s
calculation_error=sum(sum(abs(d2q_s-d2q)))/sum(sum(abs(d2q)));
disp('Relative numerical error in direct dynamics calculation:')
disp(calculation_error)

%% Calculate the gravity vector
G= iiwa.gen_GravityVector(q)

%% Calcualting the inverse kinematics
qin=zeros(7,1)
lambda=0.01;
n=500;
qs=iiwa.gen_InverseKinematics( qin, Tt,n,lambda )
% calculate the numerical error in calculating the direct/inverse
% kinematics
[Ts,J]=iiwa.gen_DirectKinematics(qs)
calculation_error=sum(sum(abs(Ts-Tt)))/sum(sum(abs(Tt)));
disp('Relative numerical error in direct/inverse kinematics calculation:')
disp(calculation_error)

%% Calculate the mass matrix
M=iiwa.gen_MassMatrix(q)

%% Calculate the null space projection matrix
N= iiwa.gen_NullSpaceMatrix(q)

%% Calculate the partial jacobean
% The partial jacobean is calculated at the EEF, ie it shall be equal to
% the jacobean at EEF
linkNum=7;
Pos=zeros(3,1);
Jp=iiwa.gen_partialJacobean(q,linkNum,Pos)
% comparison between Jp at EEF and J
calculation_error=sum(sum(abs(Jp-Jin)))/sum(sum(abs(Jin)));
disp('Relative numerical error in calculating partial Jacobean at EEF using different functions:')
disp(calculation_error)

