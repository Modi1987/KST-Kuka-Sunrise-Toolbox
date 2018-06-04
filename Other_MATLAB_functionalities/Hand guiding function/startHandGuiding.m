function startHandGuiding( t )
%% About:
% This function is used to start KUKA's off-the-shelf hand guiding

%% Syntax:
% startHandGuiding( t )

%% Areguments:
% t: is the TCP/IP connection object

% Copyright, Mohammad SAFEEA, 9th of June 2017


theCommand='handGuiding';
fprintf(t, theCommand);

fprintf('Hand gudining functionality is started \n');
fprintf('1- Press white button to activate the hand guiding \n');
fprintf('2- Release the white button so the robot stops in its configuration \n');
fprintf('3- Release the white button so the robot stops in its configuration \n');
fprintf('4- To reactivate the handguding functionality, press the green button once, for less than 1 sec  \n');
fprintf('5- Repeat from 1  \n');
fprintf('5- To terminate the hand guding function, press the green button for more than 1.5 sec \n keep pressing until the red light starts to flicker then release your hand, \n the hand guiding mode will be terminated ');
    message='';
    w = warning ('off','all');
    readingFlag=false;
    while readingFlag==false
        message=fgets(t);
        
        if checkAcknowledgment(message)
            readingFlag=true;
        end
    end
     w = warning ('on','all');
    fprintf('Hand gudining was terminated by user at robot side \n');
end