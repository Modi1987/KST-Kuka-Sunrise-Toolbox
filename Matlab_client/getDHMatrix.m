function T=getDHMatrix(alfa,theta,d,a)
%% About
% Calculates transform matrix using modified DH convention

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
