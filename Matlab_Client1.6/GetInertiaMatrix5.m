function [M]=GetInertiaMatrix5(T,Pcii,Icii,mcii)
%% Calculating the inertia matrix for the robot using GDAHJ code
% GDHJ is an efficicent algorithm for caluclating joint space inertia
% matrix by Mohammad SAFEEA
% Paper describing the method has been submitted 

%% Copyright: Mohammad SAFEEA, 2nd-April-2018

%% version one, accelerated by customed skew matrix multiply
n=max(size(mcii));
li=zeros(3,n);pcii=zeros(3,n);pci=zeros(3,n);sigmamk=zeros(n);sigmamkpck=zeros(3,n);
kj=zeros(3,n);pj=zeros(3,n);
Ai=zeros(3,3);Bi=zeros(3,1);Ci=zeros(3,3,n);
Di=zeros(3,n);Ei=zeros(3,3,n);
kjpj=zeros(3,n);
%% Invarient moment matix coeficient
Iacc=zeros(3,3);
temp=zeros(3,3);
for i=n:-1:1
    % Ei is symmetric so Iacc due to the symmetry of RIR'
    temp=Icii(:,:,i)*T(1:3,1:3,i)';
    for j=1:3
        for k=j:3
            Iacc(j,k)=Iacc(j,k)+T(j,1:3,i)*temp(:,k);
            Iacc(k,j)=Iacc(j,k);
        end
    end
    Ei(:,:,i)=Iacc;
end
%% variables initiation
for i=n:-1:1
    kj(:,i)=T(1:3,3,i);
    pj(:,i)=T(1:3,4,i);
    pcii(:,i)=T(1:3,1:3,i)*Pcii(:,i);
    pci(:,i)=T(1:3,4,i)+pcii(:,i);
    kjpj(:,i)=cross1(kj(:,i),pj(:,i));
end
%% Other variables nitiation
for i=n-1:-1:1
    li(:,i)=T(1:3,4,i+1)-T(1:3,4,i);
    sigmamk(i)=sigmamk(i+1)+mcii(i+1);
    sigmamkpck(:,i)=sigmamkpck(:,i+1)+mcii(i+1)*pci(:,i+1);
end

mciipcii=zeros(3,1);
for i=n:-1:1
            mciipcii=-mcii(i)*pcii(:,i);
    if i==n
        Ai=skewmul(skew(mciipcii),skew(pci(:,i)))-...
           skewmul( skew(li(:,i)),skew(sigmamkpck(:,i)));
        Bi=mciipcii-sigmamk(i)*li(:,i);    
        Ci(:,:,i)=Ai;
        Di(:,i)=Bi;
    else
        Ai=skewmul(skew(mciipcii),skew(pci(:,i)))-...
           skewmul( skew(li(:,i)),skew(sigmamkpck(:,i)));
        Bi=mciipcii-sigmamk(i)*li(:,i);    
        Ci(:,:,i)=Ci(:,:,i+1)+Ai;
        Di(:,i)=Di(:,i+1)+Bi;
    end
end

%% calculating the coefficient vector of the invarient moment
fi=zeros(3,n);
gi=zeros(3,n);
for i=n:-1:1
    fi(:,i)=(Ci(:,:,i)+Ei(:,:,i))'*kj(:,i);
    gi(:,i)=cross1(kj(:,i),Di(:,i));
end
%% calculating the inertia tensor
M=zeros(n,n);
for i=1:n
    for j=1:i
        M(i,j)=kj(:,j)'*fi(:,i)+kjpj(:,j)'*gi(:,i);
        M(j,i)=M(i,j);
    end
end
end

function S=skew(x)
S=[ 
    0, -x(3), x(2);
    x(3), 0, -x(1);
    -x(2),x(1),0;
    ];
end

function c=cross1(a,b)
c = [a(2,:).*b(3,:)-a(3,:).*b(2,:);
     a(3,:).*b(1,:)-a(1,:).*b(3,:);
     a(1,:).*b(2,:)-a(2,:).*b(1,:)];
end


function mat=skewmul(A,B)
mat=zeros(3,3);
a1=A(1,2)*B(2,1);
a2=A(1,3)*B(3,1);
a3=A(3,2)*B(2,3);
mat(1,1)=a1+a2;mat(1,2)=A(1,3)*B(3,2);mat(1,3)=A(1,2)*B(2,3);
mat(2,1)=A(2,3)*B(3,1);mat(2,2)=a1+a3;mat(2,3)=A(2,1)*B(1,3);
mat(3,1)=A(3,2)*B(2,1);mat(3,2)=A(3,1)*B(1,2);mat(3,3)=a2+a3;
end