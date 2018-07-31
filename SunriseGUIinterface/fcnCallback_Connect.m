function fcnCallback_Connect()
%% About:
% The call back for the Connect button

    global iiwa;
    global isConnected;
    if fcn_isConnected()
        message='Already connected to the robot !!!';
        fcn_errorMessage(message);
        return;
    end
    ip='172.31.1.147'; % The IP of the controller
    %% Get IP of the robot
    [ip,errorflag]=fcn_getIP();
    if errorflag==true
        % error message is presented inside the function {fcn_getIP()}
        return;
    else
        disp('Connecting to the robot on IP:')
        disp(ip);
    end
    %% Get robot's type
    h=findobj(0,'tag','compo_RobotType');
    arg1=0;
    switch get(h,'Value')   
      case 1
        arg1=KST.LBR7R800; % choose the robot iiwa7R800
      case 2
        arg1=KST.LBR14R820; % choose the robot iiwa14R820
        otherwise
    end 

    %% Get flange's type
    h=findobj(0,'tag','compo_FlangeType');
    arg2=0;
    switch get(h,'Value')   
      case 1
        arg2=KST.Medien_Flansch_elektrisch; 
      case 2
        arg2=KST.Medien_Flansch_pneumatisch; 
	  case 3
        arg2=KST.Medien_Flansch_IO_pneumatisch; 
      case 4
        arg2=KST.Medien_Flansch_Touch_pneumatisch; 
      case 5
        arg2=KST.None;       
        otherwise
    end 

    Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
    iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object
    %% Try to connect
    flag=iiwa.net_establishConnection();
    if flag==0
        return;
    else
        isConnected=true;
        disp('Connection with the robot is successfully established')
    end
    %% initiate feedback variables
    global feedback_eef_pos;
    global feedback_jpos;
    feedback_eef_pos=[];
    feedback_jpos=[];
    %% If connection is established successfully start timer for acquiring state of robot
    global read_state_var;
    global executionNum;
    global timerObject;
    read_state_var=true;
    executionNum=0;
    timerObject=timer('StartDelay',0,'Period',0.2,...
        'TasksToExecute',inf,'ExecutionMode','FixedRate',...
        'TimerFcn','fcnCallback_stateTimer');
    start(timerObject);
end