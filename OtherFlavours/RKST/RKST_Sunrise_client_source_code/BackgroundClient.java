package lbrExampleApplications_client;

/* By Mohammad SAFEEA: Coimbra University-Portugal, 
 * Ensam University-France
 * 
 * KST 1.7
 * 
 * First upload 07-May-2017
 * 
 * Final update 26th-06-2018 
 * 
 * This is a multi-threaded server program that is meant to be used with both
 *    KUKA iiwa 7 R 800
 * or KUKA iiwa 14 R 820.
 * The robot shall be provided with a pneumatic flange, 
 * the client of this application connects on the port 30001.
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
import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.applicationModel.RoboticsAPIApplication;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;

 

class BackgroundClient implements Runnable {

	
	
	private Controller kuka_Sunrise_Cabinet_1;
	private MediaFlangeIOGroup daIO;
	public boolean terminateBool;
	private LBR _lbr;
	private int _port;
	private int _timeOut;
	private String _ip;
	private Socket soc;
	
    //private static final String stopCharacter="\n"+Character.toString((char)(10));
    private static final String stopCharacter=Character.toString((char)(10));
    private static final String ack="done"+stopCharacter;
    
	
	BackgroundClient(int daport, String ip, int timeOut,Controller kuka_Sunrise_Cabinet_1,LBR _lbr )
	{
		_timeOut=timeOut;
		_port=daport;
		_ip=ip;
		this.kuka_Sunrise_Cabinet_1 = kuka_Sunrise_Cabinet_1;
		this._lbr = _lbr;
		daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		terminateBool=false;
		Thread t= new Thread(this);
		t.setDaemon(true);
		t.start();

	}

	
	public void run() {
		// TODO Auto-generated method stub
		
		try {
			try
			{
			soc= new Socket(_ip,_port);
			}
			catch (Exception e) {
				// TODO: handle exception
				soc.close();
				MatlabToolboxClient.terminateFlag=true;
				return;
			}
			Scanner scan= new Scanner(soc.getInputStream());
			// In this loop you shall check the input signal
			while((soc.isConnected()))
			{
				if(scan.hasNextLine())
				{			
					MatlabToolboxClient.daCommand=scan.nextLine();
					
					if(MatlabToolboxClient.daCommand.startsWith("jf_"))
		        	{
		        		boolean tempBool=getTheJointsf(MatlabToolboxClient.daCommand);
		        		MatlabToolboxClient.daCommand="";
		        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		        		if(tempBool==false)
		        		{
		        			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		        		}
		        		// this.sendCommand(ack); no acknowledgement in fast execution mode
		        	}
					// If the signal is equal to end, you shall turn off the server.
					else if(MatlabToolboxClient.daCommand.startsWith("end"))
					{
						/* Close all existing loops:
						/  1- The BackgroundTask loop.
						 * 2- The main class, MatlabToolboxServer loops:
						 * 		a- The while loop in run, using the flag: MatlabToolboxServer.terminateFlag.
						 * 		b- The direct servo loop, using the flag: MatlabToolboxServer.directServoMotionFlag.
						*/
						MatlabToolboxClient.directSmart_ServoMotionFlag=false;
						MatlabToolboxClient.terminateFlag=true;
						break;						
					}
					// Put the direct_servo joint angles command in the joint variable
					else if(MatlabToolboxClient.daCommand.startsWith("jp"))
		        	{
		        		updateJointsPositionArray();
		        	}
					else if(MatlabToolboxClient.daCommand.startsWith("vel"))
		        	{
		        		updateVelocityArrays();
		        	}
					else if(MatlabToolboxClient.daCommand.startsWith("cArtixanPosition"))
		        	{
						if(MatlabToolboxClient.daCommand.startsWith("cArtixanPositionCirc1"))
						{
			        		boolean tempBool=getEEFposCirc1(MatlabToolboxClient.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxClient.daCommand="";
						}
						else if(MatlabToolboxClient.daCommand.startsWith("cArtixanPositionCirc2"))
						{
			        		boolean tempBool=getEEFposCirc2(MatlabToolboxClient.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxClient.daCommand="";
						}
						else
						{
			        		boolean tempBool=getEEFpos(MatlabToolboxClient.daCommand);
			        		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			        		if(tempBool==false)
			        		{
			        			//MatlabToolboxServer.directServoMotionFlag=false;
			        		}
			        		this.sendCommand(ack);
			        		MatlabToolboxClient.daCommand="";
						}
		        	}
					
					// This insturction is used to turn_off the direct_servo controller
		        	else if(MatlabToolboxClient.daCommand.startsWith("stopDirectServoJoints"))
		        	{
		        		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		        		this.sendCommand(ack);
		        		MatlabToolboxClient.daCommand="";
		        	}
					else if(MatlabToolboxClient.daCommand.startsWith("DcSe"))
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
			MatlabToolboxClient.terminateFlag=true;
			soc.close();
			soc.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	private void updateVelocityArrays()
	{
		if(MatlabToolboxClient.daCommand.startsWith("velJDC_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			this.sendCommand(ack);
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("velJDCExT_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsExternalTorquesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("velJDCMT_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsMeasuredTorquesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("velJDCEEfP_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendEEFforcesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("velJDCJP_"))
		{
			boolean tempBool=getJointsVelocitiesForVelocityContrtolMode(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsPositionsToClient();
			MatlabToolboxClient.daCommand="";
		}
	}
	
	private void updateEEFPositionArray()
	{
		//////////////////////////////////////////////////
		//Start of server update functions
		/////////////////////////////////////////////////////						
		
		if(MatlabToolboxClient.daCommand.startsWith("DcSeCar_"))
		{
			boolean tempBool=getThePositions(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			// this.sendCommand(ack);
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("DcSeCarExT_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsExternalTorquesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("DcSeCarMT_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsMeasuredTorquesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("DcSeCarEEfP_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendEEFforcesToClient();
			MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("DcSeCarJP_"))
		{
			boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
			// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
			if(tempBool==false)
			{
			MatlabToolboxClient.directSmart_ServoMotionFlag=false;
			}
			MatlabToolboxClient.svr.sendJointsPositionsToClient();
			MatlabToolboxClient.daCommand="";
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
							MatlabToolboxClient.EEfServoPos[j]=Double.parseDouble(st.nextToken());
						}
						catch(Exception e)
						{
							return false;
						}						
					}					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
							MatlabToolboxClient.jvel[j]=
							Double.parseDouble(st.nextToken());
						}
						catch(Exception e)
						{
							return false;
						}						
					}					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
		
		if(MatlabToolboxClient.daCommand.startsWith("jp_"))
		{
		boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		if(tempBool==false)
		{
		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		}
		this.sendCommand(ack);
		MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("jpExT_"))
		{
		boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		if(tempBool==false)
		{
		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		}
		MatlabToolboxClient.svr.sendJointsExternalTorquesToClient();
		MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("jpMT_"))
		{
		boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		if(tempBool==false)
		{
		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		}
		MatlabToolboxClient.svr.sendJointsMeasuredTorquesToClient();
		MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("jpEEfP_"))
		{
		boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		if(tempBool==false)
		{
		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		}
		MatlabToolboxClient.svr.sendEEFforcesToClient();
		MatlabToolboxClient.daCommand="";
		}
		else if(MatlabToolboxClient.daCommand.startsWith("jpJP_"))
		{
		boolean tempBool=getTheJoints(MatlabToolboxClient.daCommand);
		// MatlabToolboxServer.printMessage(MatlabToolboxServer.daCommand);
		if(tempBool==false)
		{
		MatlabToolboxClient.directSmart_ServoMotionFlag=false;
		}
		MatlabToolboxClient.svr.sendJointsPositionsToClient();
		MatlabToolboxClient.daCommand="";
		}
		
		//////////////////////////////////////////////////
		//End of Servo joints update functions
		//////////////////////////////////////////////////////
	}
	
	// respond to a data Acquisition Request
	private void dataAqcuisitionRequest()
	{
		// Inquiring data from server
    	if(MatlabToolboxClient.daCommand.startsWith("getJointsPositions"))
    	{
    		MatlabToolboxClient.svr.sendJointsPositionsToClient();
    		MatlabToolboxClient.daCommand="";
    	}        	
    	// Write output of Mediaflange
    	else if(MatlabToolboxClient.daCommand.startsWith("blueOn"))
    	{
    		MatlabToolboxClient.mff.blueOn();
    		sendCommand(ack);
    		MatlabToolboxClient.daCommand="";
    	}
    	else if(MatlabToolboxClient.daCommand.startsWith("blueOff"))
    	{
    		MatlabToolboxClient.mff.blueOff();
    		sendCommand(ack);
    		MatlabToolboxClient.daCommand="";
    	}
    	else if(MatlabToolboxClient.daCommand.startsWith("pin"))
    	{
        	if(MatlabToolboxClient.daCommand.startsWith("pin1on"))
			{
        		MatlabToolboxClient.mff.pin1On();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin1off"))
			{
				MatlabToolboxClient.mff.pin1Off();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin11on"))
			{
				MatlabToolboxClient.mff.pin11On();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin11off"))
			{
				MatlabToolboxClient.mff.pin11Off();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin2on"))
			{
				MatlabToolboxClient.mff.pin2On();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin2off"))
			{
				MatlabToolboxClient.mff.pin2Off();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin12on"))
			{
				MatlabToolboxClient.mff.pin12On();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("pin12off"))
			{
				MatlabToolboxClient.mff.pin12Off();
				sendCommand(ack);
				MatlabToolboxClient.daCommand="";
			}
    	}
    	// Read input of Mediaflange
    	if(MatlabToolboxClient.daCommand.startsWith("getPin"))
    	{
			if(MatlabToolboxClient.daCommand.startsWith("getPin10"))
			{
				MatlabToolboxClient.mff.getPin10();
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("getPin16"))
			{
				MatlabToolboxClient.mff.getPin16();
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("getPin13"))
			{
				MatlabToolboxClient.mff.getPin13();
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("getPin3"))
			{
				MatlabToolboxClient.mff.getPin3();
				MatlabToolboxClient.daCommand="";
			}
			else if(MatlabToolboxClient.daCommand.startsWith("getPin4"))
			{
				MatlabToolboxClient.mff.getPin4();
				MatlabToolboxClient.daCommand="";
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
						MatlabToolboxClient.jpos[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
						MatlabToolboxClient.jpos[j]=Double.parseDouble(jointString);
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
						MatlabToolboxClient.EEFpos[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
						MatlabToolboxClient.EEFposCirc2[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
						MatlabToolboxClient.EEFposCirc1[j]=Double.parseDouble(jointString);
					}
					
					j++;
				}
				MatlabToolboxClient.daCommand="";
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
		if(soc==null)return false;
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
	
