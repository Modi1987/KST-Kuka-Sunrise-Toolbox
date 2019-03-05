package lbrExampleApplications;

//Copyright: Mohammad SAFEEA, 9th-April-2018

import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;
import com.kuka.roboticsAPI.sensorModel.ForceSensorData;
import com.kuka.roboticsAPI.sensorModel.TorqueSensorData;

public class StateVariablesOfRobot {
    
	private LBR _lbr; 	
    private BackgroundTask dabak;
    
    //private static final String stopCharacter="\n"+Character.toString((char)(10));
    private static final String stopCharacter=Character.toString((char)(10));

    StateVariablesOfRobot(LBR _lbr,BackgroundTask dabak)
	{
		this._lbr=_lbr;
		this.dabak=dabak;
	}
	
    public void sendJointsMeasuredTorquesToClient() {
    	
    	TorqueSensorData measuredData= _lbr.getMeasuredTorque();
    	double[] vals=
    			measuredData.getTorqueValues();
    	String s="";
    	for(int i=0;i<vals.length;i++)
    	{
    		s=s+Double.toString(vals[i])+"_";
    	}
		s=s+stopCharacter;
		while(!dabak.sendCommand(s))
		{
			dabak.sendCommand(s);
		}
		MatlabToolboxServer.daCommand=""; // clear the command
    	
    }
    
    public void sendJointsExternalTorquesToClient() {
    	
    	TorqueSensorData measuredData= _lbr.getExternalTorque();
    	double[] vals=
    			measuredData.getTorqueValues();
    	String s="";
    	for(int i=0;i<vals.length;i++)
    	{
    		s=s+Double.toString(vals[i])+"_";
    	}
		s=s+stopCharacter;
		while(!dabak.sendCommand(s))
		{
			dabak.sendCommand(s);
		}
		MatlabToolboxServer.daCommand=""; // clear the command
    	
    }
    
    public void sendEEFforcesToClient() {
    	
		ForceSensorData cforce = _lbr.getExternalForceTorque(MatlabToolboxServer._toolAttachedToLBR.getDefaultMotionFrame());
		
		String 	cmdforce=Double.toString(cforce.getForce().getX())
				+"_"+Double.toString(cforce.getForce().getY())
				+"_"+Double.toString(cforce.getForce().getZ())
				+"_"+stopCharacter;
		while(!dabak.sendCommand(cmdforce))
		{
			dabak.sendCommand(cmdforce);
		}
		MatlabToolboxServer.daCommand=""; // clear the command
    }
    
    public void sendEEFMomentsToClient() {
    	
		ForceSensorData cforce = _lbr.getExternalForceTorque(MatlabToolboxServer._toolAttachedToLBR.getDefaultMotionFrame());
		
		String 	cmdforce=Double.toString(cforce.getTorque().getX())
				+"_"+Double.toString(cforce.getTorque().getY())
				+"_"+Double.toString(cforce.getTorque().getZ())
				+"_"+stopCharacter;
		while(!dabak.sendCommand(cmdforce))
		{
			dabak.sendCommand(cmdforce);
		}
		MatlabToolboxServer.daCommand=""; // clear the command
    }

    public void sendJointsPositionsToClient() {
		// This functions sends the joints positions to the client
    	String s="";
		JointPosition initialPosition = new JointPosition(
                _lbr.getCurrentJointPosition());
		for(int i=0;i<7;i++)
		{
	        s=s+Double.toString(initialPosition.get(i))+"_";       	        
		}
		s=s+stopCharacter;
		while(!dabak.sendCommand(s))
		{
			dabak.sendCommand(s);
		}
		MatlabToolboxServer.daCommand=""; // clear the command


		
	}
    
    public void sendEEfPositionToClient() {
		// This functions sends the end effector position to the client
    	String cmdPos="";
		// Read Cartesian position data
		Frame daframe= _lbr.getCurrentCartesianPosition(MatlabToolboxServer._toolAttachedToLBR.getDefaultMotionFrame());
		cmdPos= 
		Double.toString(daframe.getX())
				+"_"+Double.toString(daframe.getY())
				+"_"+Double.toString(daframe.getZ())
				+"_"+Double.toString(daframe.getAlphaRad())
				+"_"+Double.toString(daframe.getBetaRad())
				+"_"+Double.toString(daframe.getGammaRad())
				+"_"+stopCharacter;
		//Send the data back to the client
		while(!dabak.sendCommand(cmdPos))
		{
			dabak.sendCommand(cmdPos);
		}
		MatlabToolboxServer.daCommand=""; // clear the command	
	}
    


}
