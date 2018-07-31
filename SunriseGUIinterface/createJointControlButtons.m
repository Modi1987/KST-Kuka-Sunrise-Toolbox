function createJointControlButtons(panel_x0,panel_y0,fig_h,panel_Width,panel_height)
%% An interface for Joints-position controls, this interface is a part of the Virtual smartPad
% Copyright: Mohammad SAFEEA, 2018-July-27th

% initiate the control variable
global virtual_smartPad_w_joints_command;
virtual_smartPad_w_joints_command=zeros(7,1);

global virtualTeachPendantJointAnglesTextHandles;
virtualTeachPendantJointAnglesTextHandles=[];

% Draw a panel, the container of interface
pnl_h=uipanel('Title','Joints position control','FontSize',12,...
            'Units','pixels');
pnl_h.Position=[panel_x0 panel_y0 panel_Width panel_height];

text_height=20;
button_height=35;
labels_edit_width=20;
jointVal_edit_width=50;
button_width=button_height;
interMargin=21;
midSection=panel_Width/2;

for i=1:7
    temp=['z_callBack_virtualTeachPendant_J',num2str(i)];
    jPlusCallBack{i}=[temp,'_plus'];
    jMinusCallBack{i}=[temp,'_minus'];
end

upperMargin=50;
interCentersVerticalDistance=(panel_height-upperMargin)/7;
for i=1:7
	cHeight=text_height;
    yCenter=panel_height-upperMargin-interCentersVerticalDistance*(i-1);
    % joint label
    daStr=['J',num2str(i)];
    lbl=uicontrol(pnl_h,'Style','text',...
        'Units','pixels',...
        'String',daStr);
    cWidth=labels_edit_width;
    x0=interMargin;
    y0=yCenter-text_height/2;
    lbl.Position=[x0 y0 cWidth cHeight];
    % minus control button
    btn=uicontrol(pnl_h,'Style','pushbutton',...
        'Units','pixels',...
        'String','-',...
     'ButtonDownFcn', jMinusCallBack{i});
    cWidth=button_width;
    x0=x0+interMargin+labels_edit_width;
    y0=yCenter-button_height/2;
    btn.Position=[x0 y0 cWidth button_height];
    set(btn,'Enable', 'inactive');
    % joint angle
    daStr='0.0 ';
    jointText=uicontrol(pnl_h,'Style','text',...
        'Units','pixels',...
        'String',daStr);
    virtualTeachPendantJointAnglesTextHandles{i}=jointText;
    cWidth=jointVal_edit_width;
    x0=x0+interMargin+button_width;
    y0=yCenter-text_height/2;
    jointText.Position=[x0 y0 cWidth cHeight];
    % plus control button
    btn=uicontrol(pnl_h,'Style','pushbutton',...
        'Units','pixels',...
        'String','+',...
     'ButtonDownFcn', jPlusCallBack{i});
    cWidth=button_width;
    x0=x0+interMargin+jointVal_edit_width;
    y0=yCenter-button_height/2;
    btn.Position=[x0 y0 cWidth button_height];
    set(btn,'Enable', 'inactive');
    
end

end