function interface_connection(h, frame_width,frame_height,connection_panel_width,...
    connection_panel_height,connection_panel_margin)
%% About:
% Construct the interface for the connection setup

%% Areguments:
% h: handle of the main frame
% frame_width: width of the main frame (pixels)
% frame_height: height of the main frame (pixels)
% connection_panel_width: width of connection panel
% connection_panel_height: height of connection panel
% connection_panel_margin: margin between connection panel and upper/left
% borders of frame.

% Copyright: Mohammad SAFEEA, 10th-July-2018

panel_Width=connection_panel_width;
panel_height=connection_panel_height;

margin=connection_panel_margin;
x0=margin;
y0=frame_height-margin-panel_height;

pnl_h = uipanel(h,'Title','Connection Setup',...
                'Units','pixels');
            %     'FontSize',12,...
            %    'BackgroundColor','white',...
pnl_h.Position=[x0 y0 panel_Width panel_height];

% buttons dimentions
btn_width=100;
btn_height=30;
btn_margin_x=40;
btn_margin_y=25;
% add connect button
btn = uicontrol(pnl_h,'Style', 'pushbutton', 'String', 'Connect',...
        'Units','pixels',...
        'tag','btn_connect',...
        'Callback', 'fcnCallback_Connect');
btn.Position= [btn_margin_x btn_margin_y btn_width btn_height];
% add disconnect button
btn = uicontrol(pnl_h,'Style', 'pushbutton', 'String', 'Disconnect',...
        'Units','pixels',...
        'tag','btn_disconnect',...
        'Callback', 'fcnCallback_Disconnect');
btn_disconnect_x0=panel_Width-btn_margin_x-btn_width;
btn.Position= [btn_disconnect_x0 btn_margin_y btn_width btn_height];

%% Create the labels for the compoboxes
% common vals
labels_margin=30;
labels_height=30;
labels_width=100;
labels_interMargin=20;
%% lable: ip of robot
labels_text='IP of robot';
txt = uicontrol(pnl_h,'Style','text',...
    'Units','pixels',...
    'String',labels_text);
x0=labels_interMargin;
y0=panel_height-labels_height-labels_margin;
txt.HorizontalAlignment='left';
txt.Position=[x0 y0 labels_width labels_height];
% textboxes of IP of robot
% some common variables
edit_margin=labels_interMargin;
edit_width=40;
edit_hieght=30;
edit_interMargin=10;
% create edit textboxe 4
txt = uicontrol(pnl_h,'Style','edit',...
    'Units','pixels',...
    'tag','txt_ip4',...
    'String','147');
x0=panel_Width-edit_width-edit_margin;
y0=panel_height-edit_hieght-edit_margin;
txt.HorizontalAlignment='center';
txt.Position=[x0 y0 edit_width edit_hieght];
% create edit textboxe 3
txt = uicontrol(pnl_h,'Style','edit',...
    'Units','pixels',...
    'tag','txt_ip3',...
    'String','1');
x0=panel_Width-edit_width-edit_margin-(edit_width+edit_interMargin)*1;
y0=panel_height-edit_hieght-edit_margin;
txt.HorizontalAlignment='center';
txt.Position=[x0 y0 edit_width edit_hieght];
% create edit textboxe 2
txt = uicontrol(pnl_h,'Style','edit',...
    'Units','pixels',...
    'tag','txt_ip2',...
    'String','31');
x0=panel_Width-edit_width-edit_margin-(edit_width+edit_interMargin)*2;
y0=panel_height-edit_hieght-edit_margin;
txt.HorizontalAlignment='center';
txt.Position=[x0 y0 edit_width edit_hieght];
% create edit textboxe 1
txt = uicontrol(pnl_h,'Style','edit',...
    'Units','pixels',...
    'tag','txt_ip1',...
    'String','172');
x0=panel_Width-edit_width-edit_margin-(edit_width+edit_interMargin)*3;
y0=panel_height-edit_hieght-edit_margin;
txt.HorizontalAlignment='center';
txt.Position=[x0 y0 edit_width edit_hieght];
%% lable: robot type
labels_text='Type of robot';
txt = uicontrol(pnl_h,'Style','text',...
    'Units','pixels',...
    'String',labels_text);
x0=labels_interMargin;
y0=panel_height-labels_height-labels_margin-(labels_height+labels_interMargin)*1;
txt.HorizontalAlignment='left';
txt.Position=[x0 y0 labels_width labels_height];
% Compo: robot type
popup = uicontrol(pnl_h,'Style', 'popup',...
           'String', {'lbr7R800','lbr14R820'},...
           'tag','compo_RobotType',...
           'Units','pixels'); 
       compo_robotType_Width=120;
       compo_robotType_Height=labels_height;
x0=panel_Width-labels_interMargin-compo_robotType_Width;
y0=panel_height-labels_height-labels_margin-(labels_height+labels_interMargin)*1;
popup.Position=[x0 y0 compo_robotType_Width compo_robotType_Height];       
%% lable: flange type
labels_text='Flange type';
txt = uicontrol(pnl_h,'Style','text',...
    'Units','pixels',...
    'String',labels_text);
x0=labels_interMargin;
y0=panel_height-labels_height-labels_margin-(labels_height+labels_interMargin)*2;
txt.HorizontalAlignment='left';
txt.Position=[x0 y0 labels_width labels_height];
% Compo: flange type
popup = uicontrol(pnl_h,'Style', 'popup',...
           'String', {'Medien_Flansch_elektrisch','Medien_Flansch_pneumatisch','Medien_Flansch_IO_pneumatisch','Medien_Flansch_Touch_pneumatisch','None'},...
           'tag','compo_FlangeType',...
           'Units','pixels'); 
       compo_robotType_Width=200;
       compo_robotType_Height=labels_height;
x0=panel_Width-labels_interMargin-compo_robotType_Width;
y0=panel_height-labels_height-labels_margin-(labels_height+labels_interMargin)*2;
popup.Position=[x0 y0 compo_robotType_Width compo_robotType_Height];    
%% Create compo boxes
end