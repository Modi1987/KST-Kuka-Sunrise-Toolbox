function virtualTeachPendant_Interface()
%% KST, The Virtual smartPad
% Copyright: Mohammad SAFEEA, 2018-July-27th

global virtualTeachPendantIsAlive;
virtualTeachPendantIsAlive=true;

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

global virtual_smartPad_ControlLoopeEnabled;
virtual_smartPad_ControlLoopeEnabled=true;

global virtual_smartPad_w_joints_command;
virtual_smartPad_w_joints_command=zeros(7,1);

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

imarrows=imread('directionsArrowsRotations4.png');
im=imread('directionsArrows.png');
panel_Width=size(im,1);
panel_height=size(im,2);
topMargin=130;
%% create interface
fig_width=2*panel_Width;
fig_height=2*panel_height+topMargin;
pos=[100 100 fig_width fig_height];
fig_h=figure('Name','The Virtual Smart-Pad',...
    'pos',pos);
fcn=@fcn_callback_dePressed;
set(fig_h,'WindowButtonUpFcn',fcn);
fcn=@fcn_callback_closeMe;
set(fig_h,'CloseRequestFcn',fcn); %disable closing from top corner
%% Orientation control interface
x0=0;
y0=0;
pnl_h = axes(fig_h,'Units','pixels');
pnl_h.Position=[x0 y0 panel_Width panel_height];
imshow(imarrows)
% Add buttons
createOrientationButtons(x0,y0,fig_h,panel_Width,panel_height)
%% Displacement control interface
x0=0;
y0=panel_height+40;
pnl_h = axes(fig_h,'Units','pixels');
pnl_h.Position=[x0 y0 panel_Width panel_height];
upperMargin=fig_height-y0-panel_height;
imshow(im)
% Add buttons
createDisplacmentButtons(x0,y0,fig_h,panel_Width,panel_height)
%% Joints control interface
panel_Width=fig_width/2;
panel_height=1.5*panel_height;

x0=fig_width/2;
y0=fig_height-upperMargin-panel_height+9;

% Add buttons
createJointControlButtons(x0,y0,fig_h,panel_Width,panel_height)

%% Velocities' Magnitude control-interface
panel_Width=fig_width/2;
panel_height=0.5*panel_height;

x0=fig_width/2;
y0=0.0;

% Add buttons
createVelocititesControlButtons(x0,y0,fig_h,panel_Width,panel_height)
%% Add an exit button
pause(0.2);
w=230;
h=20;
fun=@(source,event)theExitButton(source,event,fig_h);
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Close Virtual Teach Pendant',...
                'Units','pixels',...
               'Callback', fun);
            buty=fig_height-h*2;
            butx=fig_width/2-w/2;
but.Position=[butx,buty,w,h];  
end

function theExitButton(source,event,interface_Handle)
close(interface_Handle);
end

function createOrientationButtons(x0,y0,fig_h,panel_Width,panel_height)
% WX+
w=60;
h=25;
fun=@fcn_callback_smartPad_WXplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wx+',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            buty=y0+90;
            butx=x0+5;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');

% WX-
w=60;
h=25;
fun=@fcn_callback_smartPad_WXminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wx-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            multiplayer=9;
            buty=y0+40;
            butx=x0+80;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');

% WY+
w=60;
h=25;
fun=@fcn_callback_smartPad_WYplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wy+',...
                'Units','pixels',...
                'ButtonDownFcn', fun);
            buty=y0+18;
            butx=panel_Width-(x0+10)-w*1.5;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% WY-
w=60;
h=25;
fun=@fcn_callback_smartPad_WYminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wy-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            buty=y0+110;
            butx=panel_Width-(x0+10)-w;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% WZ+
w=60;
h=25;
fun=@fcn_callback_smartPad_WZplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wz+',...
                'Units','pixels',...
                'ButtonDownFcn', fun);
            buty=y0+panel_height-h*2;
            butx=panel_Width/2+15;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% WZ-
w=60;
h=25;
fun=@fcn_callback_smartPad_WZminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Wz-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            buty=y0+panel_height-h*2;
            butx=panel_Width/2-15-w;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');

end

function createDisplacmentButtons(x0,y0,fig_h,panel_Width,panel_height)
% X+
w=60;
h=25;
fun=@fcn_callback_smartPad_Xplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'X+',...
                'Units','pixels',...
                'ButtonDownFcn', fun);
            buty=y0+20;
            butx=x0+10;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% X-
w=60;
h=25;
fun=@fcn_callback_smartPad_Xminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'X-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            multiplayer=9;
            buty=y0+14*multiplayer;
            butx=x0++20*multiplayer;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% Y+
w=60;
h=25;
fun=@fcn_callback_smartPad_Yplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Y+',...
                'Units','pixels',...
                'ButtonDownFcn', fun);
            buty=y0+20;
            butx=panel_Width-(x0+10)-w;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% Y-
w=60;
h=25;
fun=@fcn_callback_smartPad_Yminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Y-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            multiplayer=9;
            buty=y0+14*multiplayer;
            butx=panel_Width-(x0++20*multiplayer)-w;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% Z+
w=60;
h=25;
fun=@fcn_callback_smartPad_Zplus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Z+',...
                'Units','pixels',...
                'ButtonDownFcn', fun);
            buty=y0+panel_height-h*1.2;
            butx=(panel_Width-w)/2;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');
% Z-
w=60;
h=25;
fun=@fcn_callback_smartPad_Zminus;
but=uicontrol(fig_h,'Style', 'pushbutton', 'String', 'Z-',...
                'Units','pixels',...
               'ButtonDownFcn', fun);
            buty=y0+14*3.5;
            butx=(panel_Width-w)/2;
but.Position=[butx,buty,w,h];  
set(but,'Enable', 'inactive');

end

function fcn_callback_closeMe(hObject, eventdata, handles)
global virtualTeachPendantIsAlive;
virtualTeachPendantIsAlive=false;

global virtual_smartPad_ControlLoopeEnabled;
message='Are you sure you want to close the virtual smarPad';
y=dialog_confirmationDialog(message);
if y==1
    virtual_smartPad_ControlLoopeEnabled=false;
    virtualTeachPendantIsAlive=false;
else
    virtualTeachPendantIsAlive=true;
    return;
end
pause(0.2);
delete(hObject);
end

function fcn_callback_smartPad_Xplus(source,event)
global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=1;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('X+ is pressed')
end

function fcn_callback_smartPad_Xminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=1;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('X- is pressed')
end

function fcn_callback_smartPad_Yplus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=1;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('Y+ is pressed')
end

function fcn_callback_smartPad_Yminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=1;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('Y- is pressed')
end

function fcn_callback_smartPad_Zplus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=1;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('Z+ is pressed')
end

function fcn_callback_smartPad_Zminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=1;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('Z- is pressed')
end

function fcn_callback_smartPad_WXplus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=1;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('WX+ is pressed')
end

function fcn_callback_smartPad_WXminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=1;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('WX- is pressed')
end

function fcn_callback_smartPad_WYplus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=1;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('WY+ is pressed')
end

function fcn_callback_smartPad_WYminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=1;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('WY- is pressed')
end

function fcn_callback_smartPad_WZplus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=1;
virtual_smartPad_WZminus=0;

disp('WZ+ is pressed')
end

function fcn_callback_smartPad_WZminus(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=1;

disp('WZ- is pressed')
end

function fcn_callback_dePressed(source,event)

global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

global virtual_smartPad_w_joints_command;
virtual_smartPad_w_joints_command=zeros(7,1);

virtual_smartPad_Xplus=0;
virtual_smartPad_Xminus=0;
virtual_smartPad_Yplus=0;
virtual_smartPad_Yminus=0;
virtual_smartPad_Zplus=0;
virtual_smartPad_Zminus=0;

virtual_smartPad_WXplus=0;
virtual_smartPad_WXminus=0;
virtual_smartPad_WYplus=0;
virtual_smartPad_WYminus=0;
virtual_smartPad_WZplus=0;
virtual_smartPad_WZminus=0;

disp('Button de-pressed')
end
