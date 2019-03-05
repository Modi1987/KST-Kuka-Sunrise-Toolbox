package lbrExampleApplications;

//Copyright: Mohammad SAFEEA, 9th-April-2018

import java.util.StringTokenizer;


import com.kuka.common.ThreadUtil;
import com.kuka.connectivity.motionModel.smartServo.ISmartServoRuntime;
import com.kuka.connectivity.motionModel.smartServo.ServoMotion;
import com.kuka.connectivity.motionModel.smartServo.SmartServo;
import com.kuka.roboticsAPI.applicationModel.RoboticsAPIApplication;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointPosition;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.CartDOF;
import com.kuka.roboticsAPI.geometricModel.LoadData;
import com.kuka.roboticsAPI.geometricModel.ObjectFrame;
import com.kuka.roboticsAPI.geometricModel.Tool;
import com.kuka.roboticsAPI.geometricModel.math.XyzAbcTransformation;
import com.kuka.roboticsAPI.motionModel.controlModeModel.CartesianImpedanceControlMode;
import com.kuka.roboticsAPI.motionModel.controlModeModel.IMotionControlMode;
import com.kuka.roboticsAPI.motionModel.controlModeModel.PositionControlMode;
import com.kuka.roboticsAPI.sensorModel.TorqueSensorData;
import com.sun.corba.se.impl.interceptors.PINoOpHandlerImpl;

/**
 * This example:
 * Null space motion with torque feedback for obstacle navigation during contact.
 * 
 */

public class SmartServoWithImpedence 
{
    private static LBR _lbr;
    private static Tool _toolAttachedToLBR;
    private static LoadData _loadData;

    // Tool Data
    private static  String TOOL_FRAME = "toolFrame";
    private static  double[] TRANSLATION_OF_TOOL = { 0, 0, 100 };
    private static  double MASS = 1;
    private static  double[] CENTER_OF_MASS_IN_MILLIMETER = { 0, 0, 100 };
    private static int MILLI_SLEEP_TO_EMULATE_COMPUTATIONAL_EFFORT = 30;

    
    
    private static double jDispMax[];
    private static double updateCycleJointPos[];
    
    
 
	public static double[] 
			getControlParameters
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
				val=new double[7];
				int j=0;
				while(st.hasMoreTokens())
				{
					String stringData=st.nextToken();
					if(j<7)
					{
						//getLogger().warn(jointString);
						val[j]=
								Double.parseDouble(stringData);
					}
					
					j++;
				}
				MatlabToolboxServer.daCommand="";
				
		}
		return val;
	}
	
	

   
    public static void startRealTimeWithImpedence(LBR lbr,Controller k
	,  double massOfTool,double[] toolsCOMCoordiantes, double 
	cStifness, double rStifness,double nStifness ) throws Exception
    {
    	// Initiate variables
		// INitialize the variables
        jDispMax=new double[7];
        updateCycleJointPos=new double[7];
        for(int i=0;i<7;i++)
        {
        	jDispMax[i]=0;
        	updateCycleJointPos[i]=0;
        }
        
        _lbr = lbr;
        MASS=massOfTool;
        CENTER_OF_MASS_IN_MILLIMETER[0]=
        		toolsCOMCoordiantes[0];
        
        CENTER_OF_MASS_IN_MILLIMETER[1]=
        		toolsCOMCoordiantes[1];
        
        CENTER_OF_MASS_IN_MILLIMETER[2]=
        		toolsCOMCoordiantes[2];
        
        cSTIFNESS=cStifness;
        rSTIFNESS=rStifness;
        nSTIFNESS=nStifness;
        
        // Create a Tool by Hand this is the tool we want to move with some mass
        // properties and a TCP-Z-offset of 100.
        _loadData = new LoadData();
        _loadData.setMass(MASS);
        _loadData.setCenterOfMass(
                CENTER_OF_MASS_IN_MILLIMETER[0], CENTER_OF_MASS_IN_MILLIMETER[1],
                CENTER_OF_MASS_IN_MILLIMETER[2]);
        _toolAttachedToLBR = new Tool("Tool", _loadData);

        XyzAbcTransformation trans = XyzAbcTransformation.ofTranslation(
                TRANSLATION_OF_TOOL[0], TRANSLATION_OF_TOOL[1],
                TRANSLATION_OF_TOOL[2]);
        ObjectFrame aTransformation = _toolAttachedToLBR.addChildFrame(TOOL_FRAME
                + "(TCP)", trans);
        _toolAttachedToLBR.setDefaultMotionFrame(aTransformation);
        // Attach tool to the robot
        _toolAttachedToLBR.attachTo(_lbr.getFlange());
        
        if (!ServoMotion.validateForImpedanceMode(_lbr))
        {
            return;
        }
        
        startImpedenceControl(cStifness, rStifness,nStifness);
		_toolAttachedToLBR.detach();
		_toolAttachedToLBR=null;
    }



    /**
     * Creates a smartServo motion with the given control mode and moves around.
     * 
     * @param controlMode
     *            the control mode which shall be used
     * @see {@link CartesianImpedanceControlMode}
     */
    
    protected static void runSmartServoMotion(final IMotionControlMode controlMode) throws Exception
    {
        final boolean doDebugPrints = false;

        final JointPosition initialPosition = new JointPosition(
                _lbr.getCurrentJointPosition());

        for(int i=1;i<7;i++)
        {
        	MatlabToolboxServer.jpos[i]=
        	initialPosition.get(i);
        }
        
        final SmartServo aSmartServoMotion = new SmartServo(initialPosition);

        // Set the motion properties to 10% of the systems abilities
        aSmartServoMotion.setJointAccelerationRel(0.1);
        aSmartServoMotion.setJointVelocityRel(0.1);

        aSmartServoMotion.setMinimumTrajectoryExecutionTime(20e-3);

        _toolAttachedToLBR.getDefaultMotionFrame().moveAsync(
                aSmartServoMotion.setMode(controlMode));

        // Fetch the Runtime of the Motion part
        final ISmartServoRuntime theSmartServoRuntime = aSmartServoMotion
                .getRuntime();

        // create an JointPosition Instance, to play with
        final JointPosition destination = new JointPosition(
                _lbr.getJointCount());

        boolean errorFlag=false;
        try
        {
          
        	while(
        			MatlabToolboxServer.
        			directSmart_ServoMotionFlag==true)
        	{
 
            	

                ThreadUtil.milliSleep(MILLI_SLEEP_TO_EMULATE_COMPUTATIONAL_EFFORT);

                theSmartServoRuntime.updateWithRealtimeSystem();

                // Get the measured position in cartesian...
                final JointPosition curMsrJntPose = theSmartServoRuntime
                        .getAxisQMsrOnController();

                
                JointPosition currentPos = new JointPosition(
                        _lbr.getCurrentJointPosition());
                
                
                
                for (int k = 0; k < destination.getAxisCount(); ++k)
                {
                		
                		
                		double dj=MatlabToolboxServer.jpos[k]-currentPos.get(k);
                		double disp= getTheDisplacment( dj);
                		double temp=currentPos.get(k)+disp;
                		double absDisp=Math.abs(disp);
                		if(absDisp>jDispMax[k])
                		{
                			jDispMax[k]=absDisp;
                		}
                        updateCycleJointPos[k]=temp;
                        
                }


                for (int k = 0; k < destination.getAxisCount(); ++k)
                {
                    destination.set(k,updateCycleJointPos[k]);
                }
                theSmartServoRuntime
                        .setDestination(destination);


        	}

                
        }
        catch (final Exception e)
        {
        	// stop the controller
            theSmartServoRuntime.stopMotion();
            errorFlag=true;
            throw e;
        }
        if(errorFlag==false)
        {
	        // stop the controller normally 
        	// in case there is no error
	        theSmartServoRuntime.stopMotion();
        }

    }
 
    private static double getTheDisplacment(double dj)
    {
    	return dj;
    }

    /**
     * Create the CartesianImpedanceControlMode class for motion parameterisation.
     * 
     * @see {@link CartesianImpedanceControlMode}
     * @return the created control mode
     */
    
    private static double cSTIFNESS=2000;
    private static double rSTIFNESS=200;
    private static double nSTIFNESS=100;
    
    protected static CartesianImpedanceControlMode createCartImp(double cStifness,
    		double rStifness, double nStifness)
    {
        final CartesianImpedanceControlMode cartImp = new CartesianImpedanceControlMode();
        cartImp.parametrize(CartDOF.TRANSL).setStiffness(cSTIFNESS);
        cartImp.parametrize(CartDOF.ROT).setStiffness(rSTIFNESS);
        cartImp.setNullSpaceStiffness(nSTIFNESS);
        // For your own safety, shrink the motion abilities to useful limits
        cartImp.setMaxPathDeviation(50., 50., 50., 50., 50., 50.);
        return cartImp;
    }

    
    
   
    public static void startImpedenceControl(double cStifness,
    		double rStifness, double nStifness) throws Exception
    {

        // Initialize Cartesian impedance mode       
        final CartesianImpedanceControlMode cartImp = 
        		createCartImp( cStifness,
        	    		 rStifness,  nStifness);

        runSmartServoMotion(cartImp);

        // Return to initial position

    }


}
