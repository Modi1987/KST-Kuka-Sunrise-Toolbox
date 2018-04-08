function [Bt]=GetCoriolisMatrix1(T,Pcii,Icii,mcii,dq)
%% About the function: this is a function that is used to calculate
% Coriolis matrix of the serially linked manipulator, the return value of
% the function is (nxn) Coriolis matrix.


%% Arreguemnts:
% T is (4x4xn) transformation matrix of the serially linked robot, each
% (4x4) matrix represents the transform for each link in the base frame. 
% Pcii is 3Xn matrix while each column represents the local coordinates
% of the center of mass of each link.
% Icii is (3x3xn) matrix, each 3x3 matrix of which represnets the
% associated link inertial tensor represented in its local inertial frame
% mcii is (1xn) vector, each element of which specifies a mass of one of
% the links


% Copyright Mohammad SAFEEA

n=max(size(mcii));
%% Initialization of Ai and Bi.
Bi=zeros(3,n,n);
Di=zeros(3,n,n);
L=zeros(3,3);
Lj_1=zeros(3,1);
wj=zeros(3,n);
half_wj=zeros(3,n);
%% Calculate === some auxuliary variables
Pcii_A=zeros(3,n);
w=zeros(3,n);
vci=zeros(3,n);
vi=zeros(3,n);
mcii_Pcii_A=zeros(3,n);
Pcii_A(:,1)=T(1:3,1:3,1)*Pcii(:,1);
w(:,1)=T(1:3,3,1)*dq(1);
wj(:,1)=w(:,1);
half_wj(:,1)=0.5*wj(:,1);
mcii_Pcii_A(:,1)=mcii(1)*Pcii_A(:,1);
double_kj=zeros(3,n);
double_kj(:,1)=2*T(1:3,3,1);
for i=2:n
        Pcii_A(:,i)=T(1:3,1:3,i)*Pcii(:,i);
        wj(:,i)=T(1:3,3,i)*dq(i);
        half_wj(:,i)=0.5*wj(:,i);
        w(:,i)=w(:,i-1)+wj(:,i);
        double_kj(:,i)=2*T(1:3,3,i);
        mcii_Pcii_A(:,i)=mcii(i)*Pcii_A(:,i);
end
%% calculating the links model, Mci and ddPci
for i=1:n
    %% calculating the Mci term
    Pci=Pcii_A(:,i)+T(1:3,4,i);
    L=T(1:3,1:3,i)*(trace(Icii(:,:,i))*eye(3)-2*Icii(:,:,i))*T(1:3,1:3,i)';
    Lj_1=L*T(1:3,3,i);
    for j=i:-1:2
    Bi(:,j,i)=Bi(:,j,i)+cross(Lj_1,half_wj(:,j));
    Lj_1=L*T(1:3,3,j-1);
    Bi(:,j-1,i)=Bi(:,j-1,i)+cross(Lj_1,w(:,i)-w(:,j-1));   
    end
    j=1;
    %Bi(:,j,i)=Bi(:,j,i)+0.5*cross(Lj_1,wj(:,j));    
    Bi(:,j,i)=Bi(:,j,i)+cross(Lj_1,half_wj(:,j)); 
    %% calculating the ddPci term
    vr=zeros(3,1);
    for j=i:-1:2
        Pcij=Pci-T(1:3,4,j);
        %Di(:,j,i)=Di(:,j,i)+(dq(j))*cross(T(1:3,3,j),cross(T(1:3,3,j),Pcij
        %));
        Di(:,j,i)=Di(:,j,i)+(dq(j))*(T(1:3,3,j)*(T(1:3,3,j)'*Pcij)-Pcij);
        vr=vr+cross(wj(:,j),Pcij);
        Di(:,j-1,i)=Di(:,j-1,i)+cross(double_kj(:,j-1),vr);
    end
    j=1;
    Pcij=Pci-T(1:3,4,j);
    Di(:,j,i)=Di(:,j,i)+(dq(j))*(T(1:3,3,j)*(T(1:3,3,j)'*Pcij)-Pcij);
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


