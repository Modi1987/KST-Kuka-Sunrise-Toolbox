function closeMainScript(hObject, eventdata, handles)
%% Event handler for the close frame event of the GUI interface
% Copyright: Mohammad SAFEEA, 24th-July-2018
global iiwa;
message='Are you sure you want to exit the GUI interface, this will close any existing connections';
y=dialog_confirmationDialog(message);

if y==1
    if fcn_isConnected()
        % if still connected to robot, turn off connection
        iiwa.net_turnOffServer();
    end
    delete(hObject);
else
    return;
end

end
