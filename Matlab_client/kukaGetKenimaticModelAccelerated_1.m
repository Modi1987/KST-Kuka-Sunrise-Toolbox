function [T]=kukaGetKenimaticModelAccelerated_1(q,dh)
%% Calculates the direct kinematics of a robotic manipulator 

% Syntax:
% [eef_transform,J]=directKinematics(q,TefTool,dh)

% Arreguments:
% q: angles of the joints of the robot.
% dh: is a structure with the Denavit-Hartenberg parameters of the robot.


% Return value:
% eef_transform: transfomration matrix from end-effector to tool
% J: jacobean at the tool center point (TCP) of the end-effector EEF.

% Copyright:
% Mohammad SAFEEA
% 16th-Aug-2017
% updated: 22nd-June-2018

%% DH PARAMETERS FOR THE ROBOT
alfa=dh.alfa;
d=dh.d;
a=dh.a;

%% Calculating the direct Kinematics
T=zeros(4,4,7);
i=1;
T(:,:,i)=getDHMatrix(alfa{i},q(i),d{i},a{i});
    for i=2:7
        T(:,:,i)=T(:,:,i-1)*getDHMatrix(alfa{i},q(i),d{i},a{i});
        T(:,:,i)=normalizeColumns(T(:,:,i));
    end
        
end

function T=getDHMatrix(alfa,theta,d,a)
T=zeros(4,4);

calpha=cos(alfa);
sinalpha=sin(alfa);
coshteta=cos(theta);
sintheta=sin(theta);

T(1,1)=coshteta;
T(2,1)=sintheta*calpha;
T(3,1)=sintheta*sinalpha;				

T(1,2)=-sintheta;
T(2,2)=coshteta*calpha;
T(3,2)=coshteta*sinalpha;

T(2,3)=-sinalpha;
T(3,3)=calpha;

T(1,4)=a;
T(2,4)=-sinalpha*d;
T(3,4)=calpha*d;
T(4,4)=1;

end

function normalizedT=normalizeColumns(T)
%% This function is used to normalize the columns of a rotation matrix with 
% some numerical errors resulting from matrix multiplication problems
r=zeros(4,3); % corrected rotatio matrix, with zero badding row at the end
for j=1:3
    r(1:3,j)=T(1:3,j)/norm(T(1:3,j));
end
normalizedT=[r,T(:,4)];
end
