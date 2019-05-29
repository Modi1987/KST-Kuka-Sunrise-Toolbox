package lbrExampleApplications;

/* By Mohammad SAFEEA: Coimbra University-Portugal, 
 * Ensam University-France
 * 
 * KST 1.7
 * 
 * First upload 07-May-2017
 * 
 * Second update 26th-06-2018 
 * 
 * Last update 12-May-2019, introduced updates are marked with the comment,
 *  "modified 12th-May-2019" or the comment "newly-added 12th-May-2019"
 * 
 * This is a multi-threaded server program that is meant to be used with both
 *    KUKA iiwa 7 R 800
 * or KUKA iiwa 14 R 820.
 * The server of this application listens on the port 30001.
 * 
 * */

import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptp;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.logging.Logger;

import sun.security.action.GetLongAction;

import com.kuka.connectivity.motionModel.directServo.DirectServo;
import com.kuka.connectivity.motionModel.directServo.IDirectServoRuntime;
//import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.applicationModel.RoboticsAPIApplication;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;

 

class BackgroundTask implements Runnable {

	
	
	private Controller kuka_Sunrise_Cabinet_1;
	//private MediaFlangeIOGroup daIO;
	public boolean terminateBool;
	private LBR _lbr;
	private int _port;
	private int _timeOut;
	private ServerSocket ss;
	private Socket soc;
	
    //private static final String stopCharacter="\n"+Character.toString((char)(10));
    private static final String stopCharacter=Character.toString((char)(10));
    private static final String ack="done"+stopCharacter;
    
	
	BackgroundTask(int daport, int timeOut,Controller kuka_Sunrise_Cabinet_1,LBR _lbr )
	{
		_timeOut=timeOut;
		_port=daport;
		this.kuka_Sunrise_Cabinet_1 = kuka_Sunrise_Cabinet_1;
		this._lbr = _lbr;
		//daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		terminateBool=false;
		Thread t= new Thread(this);
		t.setDaemon(true);
		t.start();

	}

	
	public void run() {
		// TODO Auto-generated method stub
		
		try {
			ss= new ServerSocket(_port);
			try
			{
			ss.setSoTimeout(_timeOut);
			soc= ss.accept();
			}
			catch (Exception e) {
				// TODO: handle exception
				ss.close();
				MatlabToolboxServer.terminateFlag=true;
				return;
			}
			Scanner scan= new Scanner(soc.getInputStream());
			// In this loop you shall check the input signal
			while((soc.isConnected()))
			{
				if(scan.hasNextLine())
				{			
					MatlabToolboxServer.daCommand=scan.nextLine();
					 
					if(MatlabToolboxServer.daCommand.startsWith("jf_"))
		        	{
		        		boolean tempBool=getTheJointsf(MatlabToolboxServer.daCommand);
		        		MatlabToolboxServer.daCommand="";
		        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		        		if(tempBool==false)
		        		{
		        			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
		        		}
		        		// this.sendCommand(ack); no acknowledgement in fast execution mode
		        	}
					// If the signal is equal to end, you shall turn off the server.
					else if(MatlabToolboxServer.daCommand.startsWith("end"))
					{
						/* Close all existing loops:
						/  1- The BackgroundTask loop.
						 * 2- The main class, MatlabToolboxServer loops:
						 * 		a- The while loop in run, using the flag: MatlabToolboxServer.terminateFlag.
						 * 		b- The direct servo loop, using the flag: MatlabToolboxServer.directServoMotionFlag.
						*/
						MatlabToolboxServer.directSmart_ServoMotionFlag=false;
						MatlabToolboxServer.terminateFlag=true;
						break;						
					}
					// Put the direct_servo joint angles command in the joint variable
					else if(MatlabToolboxServer.daCommand.startsWith("jp"))
		        	{
		        		updateJointsPositionArray();
		        	}
					else if(MatlabToolboxServer.daCommand.startsWith("vel"))
		        	{
		        		updateVelocityArrays();
		        	}
					else if(MatlabToolboxServer.daCommand.startsWith("cArtixanPosition"))
		        	{
						if(MatlabToolboxServer.daCommand.startsWith("cArtixanPositionCirc1"))
						{
			        		boolean tempBool=getEEFposCirc1(MatlabToolboxServer.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxServer.daCommand="";
						}
						else if(MatlabToolboxServer.daCommand.startsWith("cArtixanPositionCirc2"))
						{
			        		boolean tempBool=getEEFposCirc2(MatlabToolboxServer.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxServer.daCommand="";
						}
						else
						{
			        		boolean tempBool=getEEFpos(MatlabToolboxServer.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxServer.daCommand="";
						}
		        	}
					
					// This insturction is used to turn_off the direct_servo controller
		        	else if(MatlabToolboxServer.daCommand.startsWith("stopDirectServoJoints"))
		        	{
		        		MatlabToolboxServer.directSmart_ServoMotionFlag=false;
		        		this.sendCommand(ack);
		        		MatlabToolboxServer.daCommand="";
		        	}
					else if(MatlabToolboxServer.daCommand.startsWith("DcSe"))
		        	{
		        		updateEEFPositionArray();
		        	}
		        	else
		        	{
		        		// inquiring data from server
		        		dataAqcuisitionRequest();
		        	}
					
				}				
			}
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		
		try {
			MatlabToolboxServer.terminateFlag=true;
			soc.close();
			ss.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	private void updateVelocityArrays()
	{
		if(MatlabToolboxServer.daCommand.startsWith("velJDC_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			this.sendCommand(ack);
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("velJDCExT_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsExternalTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("velJDCMT_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsMeasuredTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("velJDCEEfP_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendEEfPositionToClient(); // "modified 12th-May-2019"
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("velJDCJP_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsPositionsToClient();
			MatlabToolboxServer.daCommand="";
		}
	}
	
	private void updateEEFPositionArray()
	{
		//////////////////////////////////////////////////
		//Start of server update functions
		/////////////////////////////////////////////////////						
		
		if(MatlabToolboxServer.daCommand.startsWith("DcSeCar_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			// this.sendCommand(ack);
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("DcSeCarExT_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsExternalTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("DcSeCarMT_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsMeasuredTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("DcSeCarEEfP_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendEEfPositionToClient(); // "modified 12th-May-2019"
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("DcSeCarJP_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsPositionsToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("DcSeCarEEfFrelEEF_")) 
		{
			// "newly-added 12th-May-2019"
			// Update Cartesian position of EEF and returns force force feedback described in EEF reference frame	
			boolean tempBool=getThePositions(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendEEFforcesToClient();
			MatlabToolboxServer.daCommand="";
		}
		//////////////////////////////////////////////////
		//End of Servo joints update functions
		//////////////////////////////////////////////////////
	}
	
	private boolean getThePositions(String thestring) {
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
				int j=0;
				while(st.hasMoreTokens())
				{
					if(j<6)
					{
						//getLogger().warn(jointString);
						try
						{
							MatlabToolboxServer.EEfServoPos[j]=Double.parseDouble(st.nextToken());
						}
						catch(Exception e)
						{
							return false;
						}						
					}					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
	}

	private boolean getJointsVelocitiesForVelocityContrtolMode(String thestring) {
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
				int j=0;
				while(st.hasMoreTokens())
				{
					if(j<7)
					{
						//getLogger().warn(jointString);
						try
						{
							MatlabToolboxServer.jvel[j]=
							Double.parseDouble(st.nextToken());
						}
						catch(Exception e)
						{
							return false;
						}						
					}					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
	}

	
	private void updateJointsPositionArray()
	{
		//////////////////////////////////////////////////
		//Start of server update functions
		/////////////////////////////////////////////////////								
		if(MatlabToolboxServer.daCommand.startsWith("jp_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			this.sendCommand(ack);
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("jpExT_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsExternalTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("jpMT_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsMeasuredTorquesToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("jpEEfP_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendEEfPositionToClient(); // "modified 12th-May-2019"
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("jpJP_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendJointsPositionsToClient();
			MatlabToolboxServer.daCommand="";
		}
		else if(MatlabToolboxServer.daCommand.startsWith("jpEEfFrelEEF_"))
		{
			// "newly-added 12th-May-2019"
			boolean tempBool=getTheJoints(MatlabToolboxServer.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
				MatlabToolboxServer.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxServer.svr.sendEEFforcesToClient();
			MatlabToolboxServer.daCommand="";
		}

		
		//////////////////////////////////////////////////
		//End of Servo joints update functions
		//////////////////////////////////////////////////////
	}
	
	// respond to a data Acquisition Request
	private void dataAqcuisitionRequest()
	{
		// Inquiring data from server
    	if(MatlabToolboxServer.daCommand.startsWith("getJointsPositions"))
    	{
    		MatlabToolboxServer.svr.sendJointsPositionsToClient();
    		MatlabToolboxServer.daCommand="";
    	}        	
    	// Write output of Mediaflange
    	else if(MatlabToolboxServer.daCommand.startsWith("blueOn"))
    	{
    		MatlabToolboxServer.mff.blueOn();
    		sendCommand(ack);
    		MatlabToolboxServer.daCommand="";
    	}
    	else if(MatlabToolboxServer.daCommand.startsWith("blueOff"))
    	{
    		MatlabToolboxServer.mff.blueOff();
    		sendCommand(ack);
    		MatlabToolboxServer.daCommand="";
    	}
    	else if(MatlabToolboxServer.daCommand.startsWith("pin"))
    	{
        	if(MatlabToolboxServer.daCommand.startsWith("pin1on"))
			{
        		MatlabToolboxServer.mff.pin1On();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin1off"))
			{
				MatlabToolboxServer.mff.pin1Off();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin11on"))
			{
				MatlabToolboxServer.mff.pin11On();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin11off"))
			{
				MatlabToolboxServer.mff.pin11Off();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin2on"))
			{
				MatlabToolboxServer.mff.pin2On();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin2off"))
			{
				MatlabToolboxServer.mff.pin2Off();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin12on"))
			{
				MatlabToolboxServer.mff.pin12On();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("pin12off"))
			{
				MatlabToolboxServer.mff.pin12Off();
				sendCommand(ack);
				MatlabToolboxServer.daCommand="";
			}
    	}
    	// Read input of Mediaflange
    	if(MatlabToolboxServer.daCommand.startsWith("getPin"))
    	{
			if(MatlabToolboxServer.daCommand.startsWith("getPin10"))
			{
				MatlabToolboxServer.mff.getPin10();
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("getPin16"))
			{
				MatlabToolboxServer.mff.getPin16();
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("getPin13"))
			{
				MatlabToolboxServer.mff.getPin13();
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("getPin3"))
			{
				MatlabToolboxServer.mff.getPin3();
				MatlabToolboxServer.daCommand="";
			}
			else if(MatlabToolboxServer.daCommand.startsWith("getPin4"))
			{
				MatlabToolboxServer.mff.getPin4();
				MatlabToolboxServer.daCommand="";
			}
    	}
	}
	
    
	/* The following function is used to extract the 
	 joint angles from the command
	 */
	private boolean getTheJoints(String thestring)
	{
		
		
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
			if(temp.startsWith("jp"))
			{
				int j=0;
				while(st.hasMoreTokens())
				{
					String jointString=st.nextToken();
					if(j<7)
					{
						//getLogger().warn(jointString);
						MatlabToolboxServer.jpos[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
		}

		return false;
	}

	/* The following function is used to extract the 
	 joint angles from the command
	 */
	private boolean getTheJointsf(String thestring)
	{
		
		
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
			if(temp.startsWith("jf"))
			{
				int j=0;
				while(st.hasMoreTokens())
				{
					String jointString=st.nextToken();
					if(j<7)
					{
						//getLogger().warn(jointString);
						MatlabToolboxServer.jpos[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				return true;
				
			}
			else
			{
				return false;
			}
		}

		return false;
	}
	
	private boolean getEEFpos(String thestring)
	{
		
		
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
			if(temp.startsWith("cArtixanPosition"))
			{
				int j=0;
				while(st.hasMoreTokens())
				{
					String jointString=st.nextToken();
					if(j<6)
					{
						//getLogger().warn(jointString);
						MatlabToolboxServer.EEFpos[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
		}

		return false;
	}

	
	private boolean getEEFposCirc2(String thestring)
	{
		
		
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
			if(temp.startsWith("cArtixanPosition"))
			{
				int j=0;
				while(st.hasMoreTokens())
				{
					String jointString=st.nextToken();
					if(j<6)
					{
						//getLogger().warn(jointString);
						MatlabToolboxServer.EEFposCirc2[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
		}

		return false;
	}
	
	
	private boolean getEEFposCirc1(String thestring)
	{
		
		
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			String temp=st.nextToken();
			if(temp.startsWith("cArtixanPosition"))
			{
				int j=0;
				while(st.hasMoreTokens())
				{
					String jointString=st.nextToken();
					if(j<6)
					{
						//getLogger().warn(jointString);
						MatlabToolboxServer.EEFposCirc1[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				return true;
				
			}
			else
			{
				return false;
			}
		}

		return false;
	}
	/* The following function is used to sent a string message
	 * to the server
	 */
	public boolean sendCommand(String s)
	{
		if(ss==null)return false;
		if(soc==null)return false;
		if(soc.isClosed())return false;
		
		try {
			soc.getOutputStream().write(s.getBytes("US-ASCII"));
			return true;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return false;
		
	}
	

	
}
	
