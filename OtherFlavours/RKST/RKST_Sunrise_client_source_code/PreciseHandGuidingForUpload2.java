package lbrExampleApplications_client;

import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;


import com.kuka.connectivity.motionModel.directServo.DirectServo;
import com.kuka.connectivity.motionModel.directServo.IDirectServoRuntime;
import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointEnum;
import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;
import com.kuka.roboticsAPI.geometricModel.World;
import com.kuka.roboticsAPI.sensorModel.ForceSensorData;
import com.kuka.roboticsAPI.sensorModel.TorqueSensorData;

import com.kuka.roboticsAPI.motionModel.HRCMotions.*;
import com.kuka.roboticsAPI.motionModel.controlModeModel.CartesianImpedanceControlMode.CartImpBuilder;


import static com.kuka.roboticsAPI.motionModel.BasicMotions.lin;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.linRel;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptp;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptpHome;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;
import java.util.StringTokenizer;

import sun.awt.windows.ThemeReader;



import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.applicationModel.RoboticsAPIApplication;
import com.kuka.roboticsAPI.applicationModel.tasks.RoboticsAPIBackgroundTask;
import com.kuka.roboticsAPI.applicationModel.tasks.RoboticsAPITask;
import com.kuka.roboticsAPI.applicationModel.tasks.UseRoboticsAPIContext;
import com.kuka.roboticsAPI.conditionModel.BooleanIOCondition;
import com.kuka.roboticsAPI.conditionModel.ICondition;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;
import com.kuka.roboticsAPI.geometricModel.math.Transformation;
import com.kuka.roboticsAPI.ioModel.AbstractIO;
import com.kuka.roboticsAPI.sensorModel.ForceSensorData;
import com.kuka.roboticsAPI.applicationModel.tasks.RoboticsAPIBackgroundTask;

/*
 *
 * Mohammad SAFEEA
 * 
 * Coimbra, Ensam Universities.
 * 
 * 27th-09-2017
 * 
 * Complete hand guiding application for KUKA iiwa 7 R 800 robot.
 * 
 * */

 


public class PreciseHandGuidingForUpload2 {


    
    public static final String LBRiiwa7R800="7R800";
    public static final String LBRiiwa14R820="14R820";
	
    private static final double radStepConst=0.0016*2/4; // Angular motion step constant.  
    private static final double stepConst=0.3e-3*2/5; // Linear motion step constant.
    
    public static boolean endPreciseHandGUiding=false; // A flag to terminate the precision control loop
     
    private static double radStep=radStepConst; // Angular motion step
    private static double step=stepConst;  // Linear motion step
    
    
    // dh parameter
    private static double[] d;
    private static double[] d800={0.34,0.0,0.4,0.0,0.4,0.0,0.28};
    private static double[] d820={0.36,0.0,0.42,0.0,0.4,0.0,0.126};
    // Times to control button press, millisecond
    private static int min1=50;
    private static int max1=700;
    
    private static int min2=1200;
    private static int max2=3000;
    
    private static int min3=3000;
    private static int max3=5000;
    
    // KUKA IIWA variables
    private static LBR _lbr;
    private static Controller kuka_Sunrise_Cabinet_1;
    private static MediaFlangeIOGroup daIO;
    
    // Control, controller, variables  
    private static double Fscale=3.5/1.2; // force scaling factor, unit (N)
    private static double MxyScale=3.2; // moment scaling factor, unit (m.N)
    private static double TscaleSelf=0.4; // torque scaling factor, unit (m.N)
    private static 	double forceThreshold=8.1; // force threshold constant, unit (N)
    private static double gammaThreshold=0.3*1.5;   // torque threshold constant, unit (m.N)
    private static double MxyThreshold=0.4*1.5; // moment threshold constant, unit (m.N)
    
    public static double Fx=0; // X component of Hand-guiding force (N)
    public static double Fy=0; // Y component of Hand-guiding force (N)
    public static double Fz=0; // Z component of Hand-guiding force (N)
    
    public static double taw7=0; // the torque acting on the last joint
    static double Mx; // X component of moment at flange frame
	static double My; // Y component of moment at flange frame
    
 // Change this value to the weight of the tool_changer
    private static double fz_changer=-3.5;
    
 // Change the following values to the position of the center of mass 
 // of the tool + tool_changer, 
 // in the refernce frame of the flange.
    // Unit in meters
 private static final double[] Pcg_changer_flangeFrame={0,0,0}; 
    
 // Change this value to the weight of the tool + tool_changer    
 private static double fz_tool=-8; // unit in Newtons
    
 // Change the following values to the position of the center of mass 
 // of the tool + tool_changer, 
 // in the refernce frame of the flange.
    private static final double[] Pcg_tool_flangeFrame={0,0,0}; 
    
    private static double tx=0;
    private static double ty=0;
    private static double tz=0;
    
  
    private static double _dispGamma=0;
    private static double _dispAlphaBeta=0;
    
    
    private static boolean handGuidingFlag=true;
    
    private static boolean toolLucked=true;   
    
    private static boolean locked=toolLucked;

    
    private static int[] filterBufferFast;
    
    private static int filterSizeFast=4; 
	
    private static double analogAverageFast=0;
    private static int filteredIntFast=0;
    private static int previousIntFast=0;
    
    private static long risingEdgeTimeFast=0;
    private static long fallingEdgeTimeFast=0;
    
    
    private static int[] filterBufferPrecise;
    
    private static int filterSizePrecise=10; 
	
    private static double analogAveragePrecise=0;
    private static int filteredIntPrecise=0;
    private static int previousIntPrecise=0;
    
    private static long risingEdgeTimePrecise=0;
    private static long fallingEdgeTimePrecise=0;  	

    
    
    private static double[][] Uv= new double [7][3];
    private static double[][] Uw= new double [7][3];
    
    private static double [][] U= new double[6][7];
    private static double [][] UU= new double[6][6];
    
    private static double [][] UU_1= new double[6][6];
    private static double [][] UTUU_1= new double[7][6];
    
    
    private static double[][][] GM=new double [4][4][7]; // Direct kinematics, transformation matrices
    
    private static double [] jposDirectServo=new double[7]; // Joint position command
    
    private static int _dispFIlterSize=30; 
    private static double[] _filterThetaXY;
    private static double[] _filterThetaZ;
    private static double _dispX;
    private static double _dispY;
    private static double _dispZ;
    private static double _dispCoef=0.5; 
    
    /// Goal position
    private static double xg;
    private static double yg;
    private static double zg;
    
    
    private static final double linearMotionThreshold=stepConst/4;
    private static final double angularMotionThreshold=radStepConst/75; //20
    


    
    private static void initiateFilters()
    {
         _filterThetaXY=newFilter();
         _filterThetaZ=newFilter();

    }
    
    private static double[] newFilter()
    {
    	double[] array= new double [_dispFIlterSize];
		// Initialize the filter with zeros
		for(int i=0;i<_dispFIlterSize;i++)
		{
			array[i]=0;
		}
		
		return array;
    }
    
    public static void updateFilter(double[] filterArray, double newVal)
    {
    	for(int i=1;i<_dispFIlterSize;i++)
		{
    		filterArray[i-1]=filterArray[i];
		}
    	filterArray[_dispFIlterSize-1]=newVal;
    	
    }
    
    public static double averageFilter(double[] filterArray)
    {
    	double sum=0;
    	
    	for(int i=0;i<_dispFIlterSize;i++)
		{
    		sum=sum+filterArray[i];
		}
    	
    	return sum/_dispFIlterSize;

    }
    
    
	public static void directServoStartJoints() throws Exception
    {
		// Change ESM state of robot
		_lbr.setESMState("2");
		// Turn on the precise motion light(blue)
		daIO.setLEDBlue(true);
		daIO.setLEDGreen(false);
		daIO.setLEDRed(false);
		// Initiate force moment measurements
    	Fx=0;
    	Fy=0;
    	Fz=0;
    	taw7=0;
    	Mx=0;
    	My=0;
        
    	
    	// Initiate the DIRECT SERVO function
        JointPosition initialPosition = new JointPosition(
                _lbr.getCurrentJointPosition());   

        
        DirectServo aDirectServoMotion = new DirectServo(initialPosition);

        aDirectServoMotion.setMinimumTrajectoryExecutionTime(40e-3);
        _lbr.moveAsync(aDirectServoMotion);
        IDirectServoRuntime theDirectServoRuntime = aDirectServoMotion
                .getRuntime();
        
        
        
        /// Initiate the (jposDirectServo) array
        JointPosition destination;
		destination= new JointPosition(
	            _lbr.getCurrentJointPosition());
		for(int i=0;i<7;i++)
		{
			jposDirectServo[i]=destination.get(i);
		}
		// Initiate the direct kinematics
        directKinematics(jposDirectServo);
        xg=GM[0][3][6];
        yg=GM[1][3][6];
        zg=GM[2][3][6];

    try{

			while(endPreciseHandGUiding==false)
			{				  
				
            	if(locked)
            	{
            		fz_changer=fz_tool;
            	}
            	else
            	{
            		fz_changer=0;
            	}

            	// Get the state of the button
    			String s=getButtonStateInPreciseHandGuiding();
    			if(s.equals("change mode")) // short duration press change mode
    			{
    				break;   	// breaking this loop shall send you back to the fast handguiding mode			
    			}
    			else if(s.equals("tool changer")) // intermidiate duration press change the tool
    			{
    				toolChanger();
    				
    			}
    			else if(s.equals("end")) // long duration press, end handguiding function
    			{
    				endHandGuiding();
    				break;
    			}
    			else if(s.equals(""))
    			{
    				// Nothing will happen
    			}  

    			
                

    			
                ForceSensorData cforce = _lbr.getExternalForceTorque(_lbr.getFlange(),World.Current.getRootFrame()	);
                double fx = cforce.getForce().getX();
                double fy = cforce.getForce().getY();
                double fz = cforce.getForce().getZ();
                
    			ForceSensorData momentAtFlange = _lbr.getExternalForceTorque(_lbr.getFlange()); 
    			
    			double mx = momentAtFlange.getTorque().getX();
                double my = momentAtFlange.getTorque().getY();
                double mz = momentAtFlange.getTorque().getZ();                 
                
                double coef=0.9;               

                
                double[] compenstatedMomentAtFlange;
                
                if(locked==true)
                {
                	// Compensate moment due to tool+tool changer
                	compenstatedMomentAtFlange=
                	compensateForMoment(mx,my,mz,
                			Pcg_tool_flangeFrame,fz_tool);
                }
                else
                {
                	// Compensate moment due to tool changer
                	compenstatedMomentAtFlange=
                	compensateForMoment(mx,my,mz,
                			Pcg_changer_flangeFrame,fz_changer);
                }
                
                double[] ms=compenstatedMomentAtFlange;
                              
                //  The angular motion detection, rotation
                if(Math.abs((_dispAlphaBeta))>angularMotionThreshold)
                {
                    Fx=Fx*coef;
                    Fy=Fy*coef;
                    Fz=Fz*coef;
                    Mx=(Mx*coef+ms[0]*(1-coef));
                    My=(My*coef+ms[1]*(1-coef));
                    taw7=taw7*coef;
                	updateAlphaBetaRotation();
                }
                //  Rotation motion detection (around self) at the last joint
                else if(Math.abs((_dispGamma))>angularMotionThreshold)
                {
                    Fx=Fx*coef;
                    Fy=Fy*coef;
                    Fz=Fz*coef;
                    Mx=Mx*coef;
                    My=My*coef;
                    taw7=(taw7*coef+ms[2]*(1-coef));
                	updateGamma();
                }
                // The linear motion detection
                else if(Math.abs((_dispX))>linearMotionThreshold)
                {
                    Fx=(Fx*coef+fx*(1-coef));
                    Fy=Fy*coef;
                    Fz=Fz*coef;
                    Mx=Mx*coef;
                    My=My*coef;
                    taw7=taw7*coef;
                	updateXPosition();
                }
                else if(Math.abs((_dispY))>linearMotionThreshold)
                {
                    Fx=Fx*coef;
                    Fy=(Fy*coef+fy*(1-coef));
                    Fz=Fz*coef;
                    Mx=Mx*coef;
                    My=My*coef;
                    taw7=taw7*coef;
                	updateYPosition();
                }
                else if(Math.abs((_dispZ))>linearMotionThreshold)
                {
                    Fx=Fx*coef;
                    Fy=Fy*coef;
                    Fz=(Fz*coef+(fz-fz_changer)*(1-coef));
                    Mx=Mx*coef;
                    My=My*coef;
                    taw7=taw7*coef;
                	updateZPosition();
                }
                // Else detect motion trigger
                else
                {
                    Fx=(Fx*coef+fx*(1-coef));
                    Fy=(Fy*coef+fy*(1-coef));
                    Fz=(Fz*coef+(fz-fz_changer)*(1-coef));
                    Mx=(Mx*coef+ms[0]*(1-coef));
                    My=(My*coef+ms[1]*(1-coef));
                    taw7=(taw7*coef+ms[2]*(1-coef));
                	detectTriggerOfMotion();
                }                    

                
                for (int k = 0; k < 7; ++k)
                {
                	destination.set(k, jposDirectServo[k]);                       
                }
                	             
	            theDirectServoRuntime.setDestination(destination);
	                
            }
    }
    catch(Exception e)
    {
    	throw e;
    }
    
    theDirectServoRuntime.stopMotion();

       
    }
	
	private static double[] compensateForMoment(double mx,double my,double mz,
			double[] Pcg_changer_flangeFrame,double fzworld)
	{
		// Get moment due to attached object
		double[] m= getMomentDueToAttachedObject(
				Pcg_changer_flangeFrame, fzworld);
		// Subtract moment due to attached object
		m[0]=mx-m[0];
		m[1]=my-m[1];
		m[2]=mz-m[2];
		// Z force in flange frame:
		return m;
		 
	}
	
	private static double[] getMomentDueToAttachedObject(
			double[] Pcg_changer_flangeFrame,double fzworld)
	{
		double[] f= new double[3];
		double[] m= new double[3];
		// Transform force to flange frame
		int i=0;
		f[i]=GM[2][i][6]*fzworld;
		i++;
		f[i]=GM[2][i][6]*fzworld;
		i++;
		f[i]=GM[2][i][6]*fzworld;
		// Calculate the moment
		double x,y,z; // center of mass
		x=Pcg_changer_flangeFrame[0];
		y=Pcg_changer_flangeFrame[1];
		z=Pcg_changer_flangeFrame[2];
		// Moment in flange frame equal
		m[0]=-z*f[1]+y*f[2];
		m[1]=+z*f[0]-x*f[2];
		m[2]=-y*f[0]+x*f[1];
		return m;
		 
	}

	public static double[] 
			getWightAndCoordiantesOfCOMofTool
			(String s)
	{
		double[] val=null;
		String thestring=s;
		StringTokenizer st= new StringTokenizer(thestring,"_");
		if(st.hasMoreTokens())
		{
			// First token is the instruction preciseHandGUiding
			String temp=st.nextToken();
			// Following tokens are data of COM of tool+toolchanger
				val=new double[4];
				int j=0;
				while(st.hasMoreTokens())
				{
					String stringData=st.nextToken();
					if(j<4)
					{
						//getLogger().warn(jointString);
						val[j]=
								Double.parseDouble(stringData);
					}
					
					j++;
				}
				MatlabToolboxClient.daCommand="";
				
		}
		return val;
	}
    public static void HandGuiding(LBR lbr,Controller k
    		, String iiwaType, double weightOfTool,double[] toolsCOMCoordiantes) throws Exception
    {
    	// Data o the coordinates of the center of 
    	// of mass of the tool+toolchanger
    	// in the reference frame of the flange
    	for(int i=0;i<3;i++)
    	{
	    	Pcg_changer_flangeFrame[i]
	    	=toolsCOMCoordiantes[i];
    	}
    	// The weight of the tool
    	fz_tool=weightOfTool;
    	
    	d=new double[7];
    	if(iiwaType.equals("7R800"))
    	{
    		d=d800; 
    	}
    	else if(iiwaType.equals("14R820"))
    	{
    		d=d820;
    	}
    	// Initiate the control
    	_lbr=lbr;
    	endPreciseHandGUiding=false;
		kuka_Sunrise_Cabinet_1 = k;
		// Initiate the filters
		initiateFilters();
		// Initialize the button variables
		// Filter for the button press
		filterBufferFast=new int[filterSizeFast];
		// Initialize the filter with zeros
		for(int i=0;i<filterSizeFast;i++)
		{
			filterBufferFast[i]=0;
		}
		
	    analogAverageFast=0;
	    filteredIntFast=0;
	    previousIntFast=0;
	    
		risingEdgeTimeFast=0;
		fallingEdgeTimeFast=0;
		// End of the initialization
		
		// Initialize the button variables
				// Filter for the button press
				filterBufferPrecise=new int[filterSizePrecise];
				// Initialize the filter with zeros
				for(int i=0;i<filterSizePrecise;i++)
				{
					filterBufferPrecise[i]=0;
				}
				
			    analogAveragePrecise=0;
			    filteredIntPrecise=0;
			    previousIntPrecise=0;
			    
				risingEdgeTimePrecise=0;
				fallingEdgeTimePrecise=0;
				// End of the initialization
				
		
		// Create IO of the mediaflange
		daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		handGuidingFlag=true;
		// Start with precise hand guiding
		if(handGuidingFlag)
		{
			directServoStartJoints();
		}
		
		
    	while(handGuidingFlag)	
    	{
    		
    		lbr.setESMState("1");
    		daIO.setLEDBlue(false);
    		daIO.setLEDGreen(false);
    		daIO.setLEDRed(true);
    		lbr.move(com.kuka.roboticsAPI.motionModel.HRCMotions.handGuiding());
    		
    		lbr.setESMState("2");
    		
    		/// Nested loop used to analyse the green button after the fast motion
    		boolean nestedLoopFlag=true;
    		while(nestedLoopFlag)
    		{
    			// read Button state
    			String s=getButtonStateInFastHandGuiding();
    			if(s.equals("change mode")) // long press change mode
    			{
    				//preciseHandGuiding();
    				directServoStartJoints();
    				nestedLoopFlag=false;
    				
    			}
    			else if(s.equals("same mode")) // 
    			{
    				handGuidingFlag=true;
    				nestedLoopFlag=false;
    			}
    			else if(s.equals("end"))
    			{
    				endHandGuiding();
    				nestedLoopFlag=false;
    			}
    			else if(s.equals(""))
    			{
    				// Nothing will happen
    			}  
    		}
    		//// End of the nested loop
    	}
    	// Turn off led so hand guiding is finished
		daIO.setLEDBlue(false);
		daIO.setLEDGreen(false);
		daIO.setLEDRed(false);

		lbr.setESMState("2");
		
    }
    
    
    

    


    
    
	private static int readButtonState() {
		// Read the value of the green button
		boolean buttonState=daIO.getUserButton();
		if(buttonState)
		{
			return 1;
		}
		else
		{
			return 0;
		}
		
	}


    
    public static void flickerTheLightsFastHandGuiding(long tempInterval)
    {
    	// flicker the lights
    	tempInterval=tempInterval/100;
    	long reminder=tempInterval%2;
    	if(reminder==0)
    	{
    		daIO.setLEDBlue(false);
    		daIO.setLEDGreen(false);
    		daIO.setLEDRed(false);
    	}
    	else
    	{
    		daIO.setLEDBlue(false);
    		daIO.setLEDGreen(false);
    		daIO.setLEDRed(true);
    	}
    }
    
    public static void flickerTheLightsSlowHandGuiding(long tempInterval)
    {
    	// flicker the lights
    	tempInterval=tempInterval/100;
    	long reminder=tempInterval%2;
    	if(reminder==0)
    	{
    		daIO.setLEDRed(false);
    		daIO.setLEDGreen(false);
    		daIO.setLEDBlue(false);
    	}
    	else
    	{
    		daIO.setLEDRed(false);
    		daIO.setLEDGreen(false);
    		daIO.setLEDBlue(true);
    	}
    }



	public static void endHandGuiding()
    {

    	handGuidingFlag=false;
		// To turn off the fast hand guiding you shall put the ESMState to two
		_lbr.setESMState("2");
    }

    public static void toolChanger()
    {
    	// toggle the flag
    	if(toolLucked)
    	{
    		toolLucked=false;
    	}
    	else
    	{
    		toolLucked=true;
    	}
    	
    	//lock the tool
    	if(toolLucked==true)
    	{
    		String message = "O10";
        	sendCommand(message);
        	locked=true;
        	fz_changer=fz_tool;
    	}
    	//unlock the tool
    	if(toolLucked==false)
    	{
    		String message = "O11";
    		sendCommand(message);
    		locked=false;
    		fz_changer=0;
    	}	
    }
    
	private static void sendCommand(String message)
	{
		// If connection established
		Socket soc;
		String RPIip = "172.31.1.1";
		int port=1080;
		String terminator = Character.toString((char)13) + Character.toString((char)10);
		try {
			soc = new Socket(RPIip ,port );
			//getLogger().warn("Connection established to Raspberry");
			message=message+terminator;
			soc.getOutputStream().write(message.getBytes("US-ASCII"));
	        Scanner scan = new Scanner(soc.getInputStream());
	        if(scan.hasNextLine())
	        {
	        	String s = scan.nextLine();
	        	//getLogger().warn(s);
	        }
	        soc.close();
			return;
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		int timeToSleep=3000; // 3 seconds to sleep after changing the tool, to prevent the robot from moving after tool changing
		
		try {
			Thread.sleep(timeToSleep);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

    
	private static boolean raisingEdgeFlagFast=false;
    private static String getButtonStateInFastHandGuiding() {
		// fast hand guiding, button state
    	for(int i=1;i<filterSizeFast;i++)
		{
			filterBufferFast[i-1]=filterBufferFast[i];
		}
    	filterBufferFast[filterSizeFast-1]=readButtonState();
    	
    	double sum=0;
    	
    	for(int i=0;i<filterSizeFast;i++)
		{
    		sum=sum+filterBufferFast[i];
		}
    	
    	analogAverageFast=sum/filterSizeFast;
    	
    	if(analogAverageFast>0.5)
    	{
    		previousIntFast=filteredIntFast;
    		filteredIntFast=1;
    	}
    	else
    	{
    		previousIntFast=filteredIntFast;
    		filteredIntFast=0;
    	}
    	
   	
    	if(filteredIntFast-previousIntFast==1)
    	{
    		if(raisingEdgeFlagFast==false)
    		{
	    		radStep=0;
	    		step=0;
	    		risingEdgeTimeFast= System.currentTimeMillis();
	    		fallingEdgeTimeFast=0;
	    		
	    		raisingEdgeFlagFast=true;
    		}
    		
    		return "";
    	}
    		
    	else if(filteredIntFast-previousIntFast==0 && raisingEdgeFlagFast==true)
    	{
            	// Make lights signals, 

            		long tempInterval=System.currentTimeMillis()-risingEdgeTimeFast;
            		if((tempInterval>min3) && (tempInterval<max3))
            		{
            			flickerTheLightsFastHandGuiding(tempInterval);
            		}
            		else if((tempInterval>min2) && (tempInterval<max2))
            		{
            			setYellow();
            			try {
            				Thread.sleep(1);
            			} catch (InterruptedException e) {
            				// TODO Auto-generated catch block
            				e.printStackTrace();
            			}
            			
            		}
            	
            	return "";
            	       	
    	}
    	// detect on falling edge
    	else if(filteredIntFast-previousIntFast==-1)
    	{
    		raisingEdgeFlagFast=false;
    		clearYellow();
    		
    		daIO.setLEDRed(true);
    		fallingEdgeTimeFast=System.currentTimeMillis();
    		radStep=radStepConst;
    		step=stepConst;
    		
        	
        	long tempo=fallingEdgeTimeFast-risingEdgeTimeFast;
        	if((tempo > min1) && (tempo < max1))
        	{
        	    analogAverageFast=0;
        	    filteredIntFast=0;
        	    previousIntFast=0;
        	    
        	    risingEdgeTimeFast=0;
        	    fallingEdgeTimeFast=0;
        		return "same mode";

        	}
        	else if((tempo > min2) && (tempo < max2))
        	{

        		
        	    analogAverageFast=0;
        	    filteredIntFast=0;
        	    previousIntFast=0;
        	    
        	    risingEdgeTimeFast=0;
        	    fallingEdgeTimeFast=0;
        		return "change mode";
        	}
        	else if((tempo > min3) && (tempo < max3))
        	{
        	    analogAverageFast=0;
        	    filteredIntFast=0;
        	    previousIntFast=0;
        	    
        	    risingEdgeTimeFast=0;
        	    fallingEdgeTimeFast=0;
        		return "end";
        	}
        	else
        	{

        		return "";
        	}
        	
    	}
    	
    	else
    	{
    		return "";
    	}

		

    	
	}

    
    private static boolean raisingEdgeFlagPrecise=false;
    private static String getButtonStateInPreciseHandGuiding() {
		// precise hand guiding, button state
    	for(int i=1;i<filterSizePrecise;i++)
		{
			filterBufferPrecise[i-1]=filterBufferPrecise[i];
		}
    	filterBufferPrecise[filterSizePrecise-1]=readButtonState();
    	
    	double sum=0;
    	
    	for(int i=0;i<filterSizePrecise;i++)
		{
    		sum=sum+filterBufferPrecise[i];
		}
    	
    	analogAveragePrecise=sum/filterSizePrecise;
    	
    	if(analogAveragePrecise>0.5)
    	{
    		previousIntPrecise=filteredIntPrecise;
    		filteredIntPrecise=1;
    	}
    	else
    	{
    		previousIntPrecise=filteredIntPrecise;
    		filteredIntPrecise=0;
    	}
    	
    	
    	
    	if(filteredIntPrecise-previousIntPrecise==1)
    	{
    		if(raisingEdgeFlagPrecise==false)
    		{
	    		radStep=0;
	    		step=0;
	    		risingEdgeTimePrecise= System.currentTimeMillis();
	    		fallingEdgeTimePrecise=0;
	    		
	    		raisingEdgeFlagPrecise=true;
    		}
    		
    		return "";
    	}
    		
    	else if(filteredIntPrecise-previousIntPrecise==0 && raisingEdgeFlagPrecise==true)
    	{
            	// Make lights signals, 

            		long tempInterval=System.currentTimeMillis()-risingEdgeTimePrecise;
            		if((tempInterval>min3) && (tempInterval<max3))
            		{
            			flickerTheLightsSlowHandGuiding(tempInterval);
            		}
            		else if((tempInterval>min2) && (tempInterval<max2))
            		{
            			setYellow();
            			try {
            				Thread.sleep(1);
            			} catch (InterruptedException e) {
            				// TODO Auto-generated catch block
            				e.printStackTrace();
            			}
            			
            		}
            	
            	return "";
            	       	
    	}
    	// Detect on the falling edge
    	else if(filteredIntPrecise-previousIntPrecise==-1)
    	{
    		raisingEdgeFlagPrecise=false;
    		clearYellow();
    		daIO.setLEDBlue(true);
    		
    		radStep=radStepConst;
    		step=stepConst;
    		fallingEdgeTimePrecise=System.currentTimeMillis();
    		
        	
        	long tempo=fallingEdgeTimePrecise-risingEdgeTimePrecise;
        	
        	if(tempo < min1)
        	{
        		daIO.setLEDBlue(true);
        		return "";
        	}
        	else if((tempo > min1) && (tempo < max1))
        	{
        		daIO.setLEDBlue(true);
        		
        	    analogAveragePrecise=0;
        	    filteredIntPrecise=0;
        	    previousIntPrecise=0;
        	    
        	    risingEdgeTimePrecise=0;
        	    fallingEdgeTimePrecise=0;
        		return "tool changer";

        	}
        	else if((tempo > min2) && (tempo < max2))
        	{
        		
        		setYellow();
        		try {
    				Thread.sleep(1);
    			} catch (InterruptedException e) {
    				// TODO Auto-generated catch block
    				e.printStackTrace();
    			}
        		clearYellow();
        		
        	    analogAveragePrecise=0;
        	    filteredIntPrecise=0;
        	    previousIntFast=0;
        	    
        	    risingEdgeTimePrecise=0;
        	    fallingEdgeTimePrecise=0;
        		return "change mode";
        	}
        	else if((tempo > min3) && (tempo < max3))
        	{
        		
        	    analogAveragePrecise=0;
        	    filteredIntPrecise=0;
        	    previousIntPrecise=0;
        	    
        	    risingEdgeTimePrecise=0;
        	    fallingEdgeTimePrecise=0;
        		return "end";
        	}
        	else
        	{
        		return "";
        	}
    	}
    	
    	else
    	{
    		return "";
    	}
    	


    	
	}

    // Turn on the yellow light
    private static void setYellow()
    {
		daIO.setLEDBlue(true);
		daIO.setLEDRed(true);
    }
    // Turn off the yellow light
    private static void clearYellow()
    {
		daIO.setLEDBlue(false);
		daIO.setLEDRed(false);
    }
    

	
private static void updateXPosition()
{
	double thresholdxy=forceThreshold-2;
	double coef=_dispCoef;
    // Move under the force
    if(Math.abs(Fx)>thresholdxy)
    {
    
    	double direction=Fx/Math.abs(Fx);
		double dispX=direction*step*(Math.abs(Fx)-Math.abs(thresholdxy))/Fscale;
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef+dispX*(1-coef);
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    // Move under the inertia, dispX=0
    else
    {
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    xg=xg+_dispX;
    iterativeSolver();
}
private static void iterativeSolver()
{
	double[] dx= new double[3]; // error vector
	int iterationNum=10; // ten iterations
	for(int k=0;k<iterationNum;k++)
	{
		directKinematics(jposDirectServo);
		// error vector, goal position minus current position
		dx[0]=xg-GM[0][3][6];
		dx[1]=yg-GM[1][3][6];
		dx[2]=zg-GM[2][3][6];
		for(int column=0;column<3;column++)
		{
			for(int dacount=0;dacount<7;dacount++)
			{
				jposDirectServo[dacount]=jposDirectServo[dacount]+UTUU_1[dacount][column]*dx[column];
			}
		}
	}
}

private static void orientationSolver(double normalizedMx,double normalizedMy)

{
	double[] dtheta= new double[3]; // error vector

		directKinematics(jposDirectServo);
		// error vector, goal position minus current position
		int i=0;
		dtheta[i]=GM[i][0][6]*normalizedMx+GM[i][1][6]*normalizedMy;
		i++;
		dtheta[i]=GM[i][0][6]*normalizedMx+GM[i][1][6]*normalizedMy;
		i++;
		dtheta[i]=GM[i][0][6]*normalizedMx+GM[i][1][6]*normalizedMy;
		
		for(int column=3;column<6;column++)
		{
			for(int dacount=0;dacount<7;dacount++)
			{
				jposDirectServo[dacount]=jposDirectServo[dacount]
						+UTUU_1[dacount][column]*dtheta[column-3];
			}
		}

}

private static void selfOrientationSolver()
{
	// Direct kinermatics shall be updated
		directKinematics(jposDirectServo);
}


private static void updateYPosition()
{
	double thresholdxy=forceThreshold-2;	
	double coef=_dispCoef;
    // Move under the force
    if(Math.abs(Fy)>thresholdxy)
    {
    
    	double direction=Fy/Math.abs(Fy);
		double dispY=direction*step*(Math.abs(Fy)-Math.abs(thresholdxy))/Fscale;
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef+dispY*(1-coef);
        _dispZ=_dispZ*coef;
    }
    // Move under the inertia, dispX=0
    else
    {
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    
    yg=yg+_dispY;
    iterativeSolver();
}

private static void updateZPosition()
{
	double coef=_dispCoef;;
    // Move under the force
    if(Math.abs(Fz)>forceThreshold)
    {
    
    	double direction=Fz/Math.abs(Fz);
		double dispZ=direction*step*(Math.abs(Fz)-Math.abs(forceThreshold))/Fscale;
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef+dispZ*(1-coef);
    }
    // Move under the inertia, dispX=0
    else
    {
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    
    zg=zg+_dispZ;
    iterativeSolver();
}

private static void updateGamma()
{
	
	double coef=_dispCoef;
    // Move under the force
    if(Math.abs(taw7)>gammaThreshold)
    {
    	double direction=taw7/Math.abs(taw7);
		double _dispGamma=radStep*direction
				*(Math.abs(taw7)-Math.abs(gammaThreshold))/TscaleSelf;
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,_dispGamma);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    // Move under the inertia, dispX=0
    else
    {
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    
    selfOrientationSolver();
    jposDirectServo[6]=jposDirectServo[6]+averageFilter(_filterThetaZ);
}

private static void updateAlphaBetaRotation()
{
	double coef=_dispCoef;
	double MxySeq=Mx*Mx+My*My;
	double Mxy= Math.pow(MxySeq,0.5);

    if(MxySeq>MxyThreshold*MxyThreshold)
    {   	   	
		double _disp=radStep*(Mxy-MxyThreshold)
				/MxyScale;
		
		updateFilter(_filterThetaXY,_disp);
        updateFilter(_filterThetaZ,0);
        
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    // Move under the inertia, dispX=0
    else
    {
		updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
    }
    
    double angle=averageFilter(_filterThetaXY);
    double normalizedMx=angle*Mx/Mxy;
    double normalizedMy=angle*My/Mxy;
    
    orientationSolver(normalizedMx,normalizedMy);
    
}

private static boolean detectTriggerOfMotion()
{

	// Priority is given to the angular rotation around 
	// the last joint
    if(Math.abs(taw7)>gammaThreshold)
    {
    	updateGamma();
    	return true;
        //getLogger().warn(Double.toString(Z));
    }
    
    double MxySeq= Mx*Mx+My*My;
    if(Math.abs(MxySeq)>MxyThreshold*MxyThreshold)
    {
    	updateAlphaBetaRotation();
    	return true;
        //getLogger().warn(Double.toString(Z));
    }
 
	double threshold=5.1;
	double thresholdxy=threshold-2;
	
    int indexForce=maxIndex(Fx,Fy,Fz);
    
    if((Math.abs(Fx)>thresholdxy) && (indexForce==0) )
    {
    	updateXPosition();
    	return true;
    }

    if((Math.abs(Fy)>thresholdxy)&& (indexForce==1) )
    {  
    	updateYPosition();
    	return true;
        
    }
    
    

    double thresholdz=threshold;       
    if(Math.abs(Fz)>Math.abs(thresholdz)&& (indexForce==2))
    {
    	updateZPosition();
    	return true;
        //getLogger().warn(Double.toString(Z));
    }
  
    
 // Otherwise decay the motion
    double coef=_dispCoef;
    updateFilter(_filterThetaXY,0);
    updateFilter(_filterThetaZ,0);
    _dispX=_dispX*coef;
    _dispY=_dispY*coef;
    _dispZ=_dispZ*coef;
    
    return false;

}



    private static double Tx=0;
    private static double Ty=0;
    private static double Tz=0;

    private static boolean updateAngularJoint(ForceSensorData cforce, LBR _lbr)
    {
        double torqueThreshold=1.5;
        double torqueThresholdRotZ=0.6;
        
        
        tx=cforce.getTorque().getX();
        ty=cforce.getTorque().getY();
        tz=cforce.getTorque().getZ();
        
        double c=0.5;
        Tx=Tx*c+tx*(1-c);
        Ty=Ty*c+ty*(1-c);
        Tz=Tz*c+tz*(1-c);
        
        double txy=Math.sqrt(Tx*Tx+Ty*Ty);

        
        	
       
        double coef=_dispCoef;
        if( txy>torqueThreshold ) // txy is already absolute
        {
        	double[] t;
            t=calculateForce(Tx, Ty, 0, _lbr);  
            
            //updateAngles( t);
        	double val=radStep/txy;
        	double scalingFactor=(Math.abs(txy)-Math.abs(torqueThreshold));
        	val=val*scalingFactor;
        	updateFilter(_filterThetaXY,val);
            updateFilter(_filterThetaZ,0);
            _dispX=_dispX*coef;
            _dispY=_dispY*coef;
            _dispZ=_dispZ*coef;
            val=averageFilter(_filterThetaXY);		
        	
        	double[] angularDispVec=new double[3];
        	angularDispVec[0]=t[0]*val;
        	angularDispVec[1]=t[1]*val;
        	angularDispVec[2]=t[2]*val;
        	
        	

            for(int theCount=0;theCount<7;theCount++)
            {
            	for(int i=3;i<6;i++)
            	{
            		jposDirectServo[theCount]=jposDirectServo[theCount]+U[i][theCount]*angularDispVec[i-3];
            		
            	}
            }
        	return true;
        }
        else if((Math.abs(tz)>torqueThresholdRotZ)/* && (Math.abs(tz)>txy)*/)
        {
        	double[] jpos=_lbr.getCurrentJointPosition().get();
        	double disp=radStep*tz/Math.abs(tz);
        	double prop_disp=disp*(Math.abs(tz)-Math.abs(torqueThresholdRotZ))/TscaleSelf;
        	updateFilter(_filterThetaXY,0);
            updateFilter(_filterThetaZ,prop_disp);
            _dispX=_dispX*coef;
            _dispY=_dispY*coef;
            _dispZ=_dispZ*coef;
            prop_disp=averageFilter(_filterThetaZ);
        	jposDirectServo[6]=jpos[6]+prop_disp;
        	
        	return true;
        }
        
        // Otherwise decay the motion
        updateFilter(_filterThetaXY,0);
        updateFilter(_filterThetaZ,0);
        _dispX=_dispX*coef;
        _dispY=_dispY*coef;
        _dispZ=_dispZ*coef;
        return false;
        
 /*       double norm=Math.sqrt(tx*tx+ty*ty+tz*tz);
        if(norm>torqueThreshold)
        {
        	double[] t;
            t=calculateForce(tx, ty, tz);  
            updateAngles( t);
        	flag= true;
        }
        
        */
        
        
    }
    

    
    private static int maxIndex(double x,double y,double z)
    {
    	double[] var= new double[3];
    	var[0]=Math.abs(x);
    	var[1]=Math.abs(y);
    	var[2]=Math.abs(z);
    	
    	int index=0;
    	double max=var[index];
    	for(int i=1;i<3;i++)
    	{
 			if(Math.abs(max)<Math.abs(var[i]))
    			{
 					index=i;
 					max=var[index];
    			}
    	}
    return index;
    }
    
    
    private static double[] calculateForce(double a1, double a2, double a3, LBR _lbr) {
		// TODO Auto-generated method stub
    	double[] f= new double[3];
    	double[] a= new double[3]; // the force
    	
    	int index=0;
    	a[index]=a1;
    	index=index+1;
    	a[index]=a2;
    	index=index+1;
    	a[index]=a3;
    	index=index+1;
    	
    	// The following function is to calculate the rotation matrix of EF
    	double[][] R=F_Matrix();
    	
    	for(int i=0;i<3;i++)
    	{
    		double sum=0;
    		for(int j=0;j<3;j++)
    		{
    			sum=sum+R[i][j]*a[j];
    		}
    		f[i]=sum;
    		
    	}
    	
		return f;
	}




    

    private static double[] alfa={0,-Math.PI/2,Math.PI/2,Math.PI/2,-Math.PI/2,-Math.PI/2,Math.PI/2};
        
    private static double[] a={0,0,0,0,0,0,0};
   


    private static  void directKinematics(double[] jPos)
    {  	
    	 	
    	int startIndex=0;
    	
    	double[][] temp=dhMatrix(jPos[startIndex],alfa[startIndex],d[startIndex],a[startIndex]);
		
    	assignT(temp,0);
    	
    	for(int count=startIndex+1;count<7;count++)
    	{
    		temp=matrixMultiply(temp,dhMatrix(jPos[count],alfa[count],d[count],a[count]));
    		assignT(temp,count);
    		  		  		
    	}

    	jacobean(jPos);
    }
    
    private static  void jacobean(double[] jPos)
    {
    	double[] pef=new double[3];

    	pef[0]=GM[0][3][6];
    	pef[1]=GM[1][3][6];
    	pef[2]=GM[2][3][6];
    	
    	double[] kj=new double [3];
		double[] pj=new double[3];
		double[] pefj;
		
		double[] kjpefj;
    	
    	int startIndex=0;
    
		pj[0]=GM[0][3][0];
		pj[1]=GM[1][3][0];
		pj[2]=GM[2][3][0];
		

		kj[0]=GM[0][2][0];
		kj[1]=GM[1][2][0];
		kj[2]=GM[2][2][0];
		
		pefj=sub(pef,pj);
		kjpefj=cross(kj,pefj);
		
		Uv[0][0]=kjpefj[0];
		Uv[0][1]=kjpefj[1];
		Uv[0][2]=kjpefj[2];

		Uw[0][0]=GM[0][2][0];
		Uw[0][1]=GM[1][2][0];
		Uw[0][2]=GM[2][2][0];
		
		// first column
		for(int i=0;i<3;i++)
		{
			U[i][0]=Uv[0][i];
		}
		for(int i=0;i<3;i++)
		{
			U[i+3][0]=Uw[0][i];
		}
		
		for(int count=startIndex+1;count<7;count++)
    	{
			pj[0]=GM[0][3][count];
			pj[1]=GM[1][3][count];
			pj[2]=GM[2][3][count];
			
	
			kj[0]=GM[0][2][count];
			kj[1]=GM[1][2][count];
			kj[2]=GM[2][2][count];
			
			pefj=sub(pef,pj);
			kjpefj=cross(kj,pefj);
			
			Uv[count][0]=kjpefj[0];
			Uv[count][1]=kjpefj[1];
			Uv[count][2]=kjpefj[2];
			
			Uw[count][0]=GM[0][2][count];
			Uw[count][1]=GM[1][2][count];
			Uw[count][2]=GM[2][2][count];
			
			// count column
			for(int i=0;i<3;i++)
			{
				U[i][count]=Uv[count][i];
			}
			for(int i=0;i<3;i++)
			{
				U[i+3][count]=Uw[count][i];
			}
    	}
    	for(int i=0;i<6;i++)
    	{
    		for(int j=0;j<6;j++)
        	{
    			UU[i][j]=0;
    			for(int k=0;k<7;k++)
            	{
            		UU[i][j]=UU[i][j]+U[i][k]*U[j][k];
            	}
        		
        	}
    	}
    	
    	// add the dlsConst
    	for(int i=0;i<6;i++)
    	{
            		UU[i][i]=UU[i][i];//+dlsConstant;
    	} 	
    	
	
    	UU_1=invert(UU);
    	
    	for(int i=0;i<7;i++)
    	{
    		for(int j=0;j<6;j++)
        	{
    			UTUU_1[i][j]=0;
    			for(int k=0;k<6;k++)
            	{
    				UTUU_1[i][j]=UTUU_1[i][j]+U[k][i]*UU_1[k][j];
            	}
        		
        	}
    	}
    	
    }
    
    public static void assignT(double[][] temp,int k)
    {
    	
    	for(int i=0;i<4;i++)
    	{
    		for(int j=0;j<4;j++)
    		{
    			GM[i][j][k]=temp[i][j];
    		}
    	}
    }
    
 
    private static  double[][] eefR()
    {
    	double[][] mat=new double[3][3];
    	
    	for(int i=0;i<3;i++)
    	{
    		for(int j=0;j<3;j++)
    		{
    			mat[i][j]=GM[i][j][6];
    		}
    	}

    	return mat;
    	
    }

    private static  double[][] F_Matrix()
    {
    	double[][] mat= new double[3][3];

   	
    	for(int i=0;i<3;i++)
    	{
    		for(int j=0;j<3;j++)
    		{
    			mat[i][j]=GM[i][j][6];
    		}
    	}
    	return mat;
    	
    }
    
	
	private static double[][] dhMatrix(double theta,double alfa,double d,double a)
	{
		double[][] R=new double[4][4] ;

		int tempj=0;
		int tempi;
		
		tempi=0;
		R[tempi][tempj]=Math.cos(theta);
		tempi++;
		R[tempi][tempj]=Math.sin(theta)*Math.cos(alfa);
		tempi++;
		R[tempi][tempj]=Math.sin(theta)*Math.sin(alfa);
		tempi++;
		R[tempi][tempj]=0;
		tempi++;
		tempj++;
		
		tempi=0;
		R[tempi][tempj]=-Math.sin(theta);
		tempi++;
		R[tempi][tempj]=Math.cos(theta)*Math.cos(alfa);
		tempi++;
		R[tempi][tempj]=Math.cos(theta)*Math.sin(alfa);;
		tempi++;
		R[tempi][tempj]=0;
		tempi++;
		tempj++;
		
		tempi=0;
		R[tempi][tempj]=0;
		tempi++;
		R[tempi][tempj]=-Math.sin(alfa);
		tempi++;
		R[tempi][tempj]=Math.cos(alfa);
		tempi++;
		R[tempi][tempj]=0;
		tempi++;
		tempj++;
		
		tempi=0;
		R[tempi][tempj]=a;
		tempi++;
		R[tempi][tempj]=-Math.sin(alfa)*d;
		tempi++;
		R[tempi][tempj]=Math.cos(alfa)*d;
		tempi++;
		R[tempi][tempj]=1;
		tempi++;
		tempj++;
		
		return R;
	}

	
	
	private static double[][] matrixMultiply(double[][] M,double[][] eeF)
	{
		double[][] res= new double[4][4];
		
		for(int i=0;i<4;i++)
		{
			for(int j=0;j<4;j++)
			{
				res[i][j]=0;
				for(int k=0;k<4;k++)
				{
					res[i][j]=res[i][j]+M[i][k]*eeF[k][j];
				}
				
			}
			
		}
		
		return res;
	}
	
	
	
	
    public static double[][] invert(double a[][]) 

    {

        int n = a.length;

        double x[][] = new double[n][n];

        double b[][] = new double[n][n];

        int index[] = new int[n];

        for (int i=0; i<n; ++i) 

            b[i][i] = 1;

 



        gaussian(a, index);

 



        for (int i=0; i<n-1; ++i)

            for (int j=i+1; j<n; ++j)

                for (int k=0; k<n; ++k)

                    b[index[j]][k]

                    	    -= a[index[j]][i]*b[index[i]][k];

 



        for (int i=0; i<n; ++i) 

        {

            x[n-1][i] = b[index[n-1]][i]/a[index[n-1]][n-1];

            for (int j=n-2; j>=0; --j) 

            {

                x[j][i] = b[index[j]][i];

                for (int k=j+1; k<n; ++k) 

                {

                    x[j][i] -= a[index[j]][k]*x[k][i];

                }

                x[j][i] /= a[index[j]][j];

            }

        }

        return x;

    }

 


 

    public static void gaussian(double a[][], int index[]) 

    {

        int n = index.length;

        double c[] = new double[n];

 



        for (int i=0; i<n; ++i) 

            index[i] = i;

 

 

        for (int i=0; i<n; ++i) 

        {

            double c1 = 0;

            for (int j=0; j<n; ++j) 

            {

                double c0 = Math.abs(a[i][j]);

                if (c0 > c1) c1 = c0;

            }

            c[i] = c1;

        }

 

 

        int k = 0;

        for (int j=0; j<n-1; ++j) 

        {

            double pi1 = 0;

            for (int i=j; i<n; ++i) 

            {

                double pi0 = Math.abs(a[index[i]][j]);

                pi0 /= c[index[i]];

                if (pi0 > pi1) 

                {

                    pi1 = pi0;

                    k = i;

                }

            }

 



            int itmp = index[j];

            index[j] = index[k];

            index[k] = itmp;

            for (int i=j+1; i<n; ++i) 	

            {

                double pj = a[index[i]][j]/a[index[j]][j];

 



                a[index[i]][j] = pj;

 



                for (int l=j+1; l<n; ++l)

                    a[index[i]][l] -= pj*a[index[j]][l];

            }

        }

    }
    
    private static double[] cross(double[] kj,double[] pefj)
    {
    	double[] res= new double[3];
    	res[0]=-kj[2]*pefj[1]+kj[1]*pefj[2];
    	res[1]=kj[2]*pefj[0]-kj[0]*pefj[2];
    	res[2]=-kj[1]*pefj[0]+kj[0]*pefj[1];
    	return res;   			
    }
    
    private static double[] sub(double[] pef,double[] pj)
    {
    	double[] res= new double[3];
    	int i=0;
    	res[0]=pef[i]-pj[i];
    	i=i+1;
    	res[1]=pef[i]-pj[i];
    	i=i+1;
    	res[2]=pef[i]-pj[i];
    	return res;   			
    }
    
}
