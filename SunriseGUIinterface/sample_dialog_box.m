function [Flag,jAngle]=dialog_jointAnlgesInput()
% Dialog box used by the user to enter the values of the joint angles of the robot.


global daHandleof_dialog_jointAnlgesInput;
global dialog_jointAnlgesInput_button_hit;
global dialog_jointAnlgesInput_flag;
global dialog_jointAnlgesInput_jangle;

dialog_jointAnlgesInput_button_hit=0;
dialog_jointAnlgesInput_flag=false;
dialog_jointAnlgesInput_jangle={};
%% Interface container
dialog_width=400;
dialog_height=600;
dialog_x0=10;
dialog_y0=100;
daCaption='Joint angles (degree)';
jointAnglesDialogHandle=figure('Name',daCaption,'rend','painters','pos',[dialog_x0 dialog_y0 dialog_width dialog_height]);
daHandleof_dialog_jointAnlgesInput=jointAnglesDialogHandle;
%% Button dimension
enter_buttons_separator=40;
button_width=100;
button_height=50;
%% Add ok button
fcn=@callback_dialog_jointAnlgesInput_okBtn;
btn_ok_h= uicontrol(jointAnglesDialogHandle,'Style', 'pushbutton', 'String', 'OK',...
                'Units','pixels',...
                'Callback', fcn);
x0=round((dialog_width-enter_buttons_separator-button_width*2)/2);
xtemp=x0;
y0=enter_buttons_separator;
ytemp=y0;
btn_ok_h.HorizontalAlignment='center';
btn_ok_h.Position=[x0 y0 button_width button_height];  
%% Add cancel button
fcn=@callback_dialog_jointAnlgesInput_cancelBtn;
btn_cancel_h= uicontrol(jointAnglesDialogHandle,'Style', 'pushbutton', 'String', 'Cancel',...
                'Units','pixels',...
                'Callback', fcn);
x0=xtemp+enter_buttons_separator+button_width;
y0=ytemp;
btn_cancel_h.HorizontalAlignment='center';
btn_cancel_h.Position=[x0 y0 button_width button_height];  
%% Add lables and sliders,

while(dialog_jointAnlgesInput_button_hit==0)
    figure(daHandleof_dialog_jointAnlgesInput)
    pause(0.1);
end
jAngle=dialog_jointAnlgesInput_jangle;
Flag=dialog_jointAnlgesInput_flag;

clear daHandleof_dialog_jointAnlgesInput;
clear dialog_jointAnlgesInput_button_hit;
clear dialog_jointAnlgesInput_flag;
clear dialog_jointAnlgesInput_jangle;
end

function callback_dialog_jointAnlgesInput_okBtn(PushButton, EventData)
    global daHandleof_dialog_jointAnlgesInput;
    global dialog_jointAnlgesInput_button_hit;
    global dialog_jointAnlgesInput_flag;
    global dialog_jointAnlgesInput_jangle;
    
    close(daHandleof_dialog_jointAnlgesInput);
    y={1,2,3,4,5,6,7};
    dialog_jointAnlgesInput_flag=true;
    dialog_jointAnlgesInput_jangle=y;
    dialog_jointAnlgesInput_button_hit=1;
end

function callback_dialog_jointAnlgesInput_cancelBtn(PushButton, EventData)
    global daHandleof_dialog_jointAnlgesInput;
    global dialog_jointAnlgesInput_button_hit;
    global dialog_jointAnlgesInput_flag;
    global dialog_jointAnlgesInput_jangle;
    
    close(daHandleof_dialog_jointAnlgesInput);
    dialog_jointAnlgesInput_flag=false;
    dialog_jointAnlgesInput_jangle=[];
    dialog_jointAnlgesInput_button_hit=1;
end