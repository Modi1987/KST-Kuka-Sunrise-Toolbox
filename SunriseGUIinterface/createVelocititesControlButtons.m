function createVelocititesControlButtons(panel_x0,panel_y0,fig_h,panel_Width,panel_height)
%% An interface for velocities magitueds control, this interface is a part of the Virtual smartPad interface
% Copyright: Mohammad SAFEEA, 2018-July-27th

global virtualTeachPendantLinearVelocityMagnitude;
global virtualTeachPendantAngularVelocityMagnitude;
global virtualTeachPendantJointVelocityMagnitude;

virtualTeachPendantLinearVelocityMagnitude=5;
virtualTeachPendantAngularVelocityMagnitude=2;
virtualTeachPendantJointVelocityMagnitude=2;

initialVals={virtualTeachPendantLinearVelocityMagnitude;
    virtualTeachPendantAngularVelocityMagnitude;
    virtualTeachPendantJointVelocityMagnitude};

% Draw a panel, the container of interface
pnl_h=uipanel(fig_h,'Title','Motion velocity','FontSize',12,...
            'Units','pixels');
pnl_h.Position=[panel_x0 panel_y0 panel_Width panel_height];

interMargin=2;
basic_width=(panel_Width-5*interMargin)/10;

upperMargin=60;
interCentersVerticalDistance=(panel_height-upperMargin)/2.7;

text_height=30;
labelsHeight=25;
control_height=interCentersVerticalDistance*.75;

centegradeSymbol=char(176);
st1Temp=['EEF ang... [',centegradeSymbol,'/sec]'];
st2Temp=['Joint vel [',centegradeSymbol,'/sec]'];
labels={'EEF lin... [mm/sec]';st1Temp;st2Temp};
    

    for i=1:3
        yCenter=panel_height-upperMargin-interCentersVerticalDistance*(i-1);
        % joint label
        lbl=uicontrol(pnl_h,'Style','text',...
            'Units','pixels',...
            'String',labels{i});
        cWidth=5*basic_width;
        cHeight=labelsHeight;
        x0=interMargin;
        y0=yCenter-control_height/2;
        lbl.Position=[x0 y0 cWidth cHeight];
        set(lbl,'HorizontalAlignment','left')
        % minus button
        minusButHandle=uicontrol(pnl_h,'Style', 'pushbutton', 'String', '-',...
                'Units','pixels');
        x0=x0+cWidth+interMargin ;
        cWidth=basic_width;
        cHeight=control_height;
        y0=yCenter-cHeight/2;
        minusButHandle.Position=[x0 y0 cWidth cHeight];
        % text of velocity magnitude
        str=sprintf('%0.1f',initialVals{i});
        textHandle=uicontrol(pnl_h,'Style', 'edit', 'String', str,...
                'Units','pixels');
        x0=x0+cWidth+interMargin ;
        cWidth=2*basic_width;
        cHeight=text_height;
        y0=yCenter-cHeight/2;
        textHandle.Position=[x0 y0 cWidth cHeight];
        % plus button
        plusButHandle=uicontrol(pnl_h,'Style', 'pushbutton', 'String', '+',...
                'Units','pixels');
        x0=x0+cWidth+interMargin ;
        cWidth=basic_width;
        cHeight=control_height;
        y0=yCenter-cHeight/2;
        plusButHandle.Position=[x0 y0 cWidth cHeight];
        % set callbacks of buttons
        if i==1
            fun1=@(object,event)velLinearCallBack(object,event,textHandle,+1);
            fun2=@(object,event)velLinearCallBack(object,event,textHandle,-1);
        elseif i==2
            fun1=@(object,event)velAngularCallBack(object,event,textHandle,+0.2);
            fun2=@(object,event)velAngularCallBack(object,event,textHandle,-0.2);
        elseif i==3
            fun1=@(object,event)jointVelCallBack(object,event,textHandle,+0.2);
            fun2=@(object,event)jointVelCallBack(object,event,textHandle,-0.2);
        end
        set(minusButHandle,'Callback', fun2);
        set(plusButHandle,'Callback', fun1);
        
    end
end

function velLinearCallBack(object,event,textHandle,increment)
global virtualTeachPendantLinearVelocityMagnitude;
virtualTeachPendantLinearVelocityMagnitude=virtualTeachPendantLinearVelocityMagnitude+increment;
maxLimit=10;
minLimit=1;
if virtualTeachPendantLinearVelocityMagnitude>maxLimit
    virtualTeachPendantLinearVelocityMagnitude=maxLimit;
end
if virtualTeachPendantLinearVelocityMagnitude<minLimit
    virtualTeachPendantLinearVelocityMagnitude=minLimit;
end
% Update the textbox
str=sprintf('%0.1f',virtualTeachPendantLinearVelocityMagnitude);
set(textHandle,'String',str);
end

function velAngularCallBack(object,event,textHandle,increment)
global virtualTeachPendantAngularVelocityMagnitude;
virtualTeachPendantAngularVelocityMagnitude=virtualTeachPendantAngularVelocityMagnitude+increment;
maxLimit=10;
minLimit=1;
if virtualTeachPendantAngularVelocityMagnitude>maxLimit
    virtualTeachPendantAngularVelocityMagnitude=maxLimit;
end
if virtualTeachPendantAngularVelocityMagnitude<minLimit
    virtualTeachPendantAngularVelocityMagnitude=minLimit;
end
% Update the textbox
str=sprintf('%0.1f',virtualTeachPendantAngularVelocityMagnitude);
set(textHandle,'String',str);
end

function jointVelCallBack(object,event,textHandle,increment)
global virtualTeachPendantJointVelocityMagnitude;
virtualTeachPendantJointVelocityMagnitude=virtualTeachPendantJointVelocityMagnitude+increment;
maxLimit=10;
minLimit=1;
if virtualTeachPendantJointVelocityMagnitude>maxLimit
    virtualTeachPendantJointVelocityMagnitude=maxLimit;
end
if virtualTeachPendantJointVelocityMagnitude<minLimit
    virtualTeachPendantJointVelocityMagnitude=minLimit;
end
% Update the textbox
str=sprintf('%0.1f',virtualTeachPendantJointVelocityMagnitude);
set(textHandle,'String',str);
end