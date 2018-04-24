function [Bt]=GetCentrifugalMatrix_2(T,Pcii,Icii,mcii,dq)
%% About the function: this is a function that is used to calculate
% Centrifugal matrix of the serially linked manipulator,  the return value of
% the function is (nxn) Centrifugal matrix from which when multiplied by
% the joints' velocity vector the torques of the centrifugal forces 
% is going to be calculated 
% The input parameters are as the following:
% T is (4x4xn) transformation matrix of the serially linked robot, each
% (4x4) matrix represents the transform for each link in the base frame. 
% Pcii is 3Xn matrix while each column represents the local coordinates
% of the center of mass of each link.
% Icii is (3x3xn) matrix, each 3x3 matrix of which represnets the
% associated link inertial tensor represented in its local inertial frame
% mcii is (1xn) vector, each element of which specifies a mass of one of
% the links

% Copyright Mohammad SAFEEA 2nd,April,2018

n=max(size(mcii));
%% Initialization of Ai and Bi.
Bi=zeros(3,n,n);
Di=zeros(3,n,n);
Kj=zeros(3,n);
half_Kj=zeros(3,n);
%% Calculate === some auxuliary variables
Pcii_A=zeros(3,n);
mcii_Pcii_A=zeros(3,n);
Pcii_A(:,1)=T(1:3,1:3,1)*Pcii(:,1);
mcii_Pcii_A(:,1)=mcii(1)*Pcii_A(:,1);
Kj(:,1)=T(1:3,3,1);
half_Kj(:,1)=0.5*Kj(:,1);
for i=2:n
        Pcii_A(:,i)=T(1:3,1:3,i)*Pcii(:,i);
        mcii_Pcii_A(:,i)=mcii(i)*Pcii_A(:,i);
        Kj(:,i)=T(1:3,3,i);
        half_Kj(:,i)=0.5*Kj(:,i);
end
%% calculating the links model, Mci and ddPci
for i=1:n
    %% calculating the Mci term
    Pci=Pcii_A(:,i)+T(1:3,4,i);
    L=T(1:3,1:3,i)*(trace(Icii(:,:,i))*eye(3)-2*Icii(:,:,i))*T(1:3,1:3,i)';
    for j=1:i
        %Calculating inertial moment due to normal acceleration due to
        %effect of each frame j.
        Bi(:,j,i)=cross(L*half_Kj(:,j),Kj(:,j));
        %Calculating acceleration of center of mass of link i due to
        %injection of each frame j
        Pcij=Pci-T(1:3,4,j);
        Di(:,j,i)=Kj(:,j)*(Kj(:,j)'*Pcij)-Pcij;
    end
end
Bt=zeros(n,n);
Fac_D=zeros(3,n);
Mac_B=zeros(3,n);
Pjp1_j=zeros(3,1);
%% calculating Mac for all of the links, then calculating two by filling At
%% and Bt

start=n-1;
j=n;
%% recursive rprocedure on moments and forces
        for k=1:n %% iterate through the matrix
            Mac_B(:,k)=Bi(:,k,j)+cross(mcii_Pcii_A(:,j),Di(:,k,j));            
        end
        %% on forces
        Fac_D=mcii(j)*Di(:,:,j);       
        Bt(j,:)=T(1:3,3,j)'*Mac_B;
    
for j=start:-1:1 %% iterate through the joints
    Pjp1_j=T(1:3,4,j+1)-T(1:3,4,j);
    %% recursive rprocedure on moments and forces
        for k=1:j %% iterate through the matrix
            Mac_B(:,k)=Mac_B(:,k)+Bi(:,k,j)+cross(Pjp1_j,Fac_D(:,k))+cross(mcii_Pcii_A(:,j),Di(:,k,j));            
        end
        for k=j+1:n
            Mac_B(:,k)=Mac_B(:,k)+cross(Pjp1_j,Fac_D(:,k));
        end
    %% on forces
    Fac_D(:,1:j)=Fac_D(:,1:j)+mcii(j)*Di(:,1:j,j);        
    Bt(j,:)=T(1:3,3,j)'*Mac_B;
    
end
%% close the function
end


