package lbrExampleApplications;


import static com.kuka.roboticsAPI.motionModel.BasicMotions.circ;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.lin;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.linRel;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptp;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptpHome;

import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.applicationModel.RoboticsAPIApplication;
import com.kuka.roboticsAPI.applicationModel.tasks.RoboticsAPITask;
import com.kuka.roboticsAPI.applicationModel.tasks.UseRoboticsAPIContext;
import com.kuka.roboticsAPI.conditionModel.ICondition;
import com.kuka.roboticsAPI.conditionModel.JointTorqueCondition;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.JointEnum;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;
import com.kuka.roboticsAPI.geometricModel.math.Transformation;

/**
 * Implementation of a robot application.
 * <p>
 * The application provides a {@link RoboticsAPITask#initialize()} and a 
 * {@link RoboticsAPITask#run()} method, which will be called successively in 
 * the application lifecycle. The application will terminate automatically after 
 * the {@link RoboticsAPITask#run()} method has finished or after stopping the 
 * task. The {@link RoboticsAPITask#dispose()} method will be called, even if an 
 * exception is thrown during initialization or run. 
 * <p>
 * <b>It is imperative to call <code>super.dispose()</code> when overriding the 
 * {@link RoboticsAPITask#dispose()} method.</b> 
 * 
 * @see UseRoboticsAPIContext
 * @see #initialize()
 * @see #run()
 * @see #dispose()
 */
public class FirstTest extends RoboticsAPIApplication {
	private Controller kuka_Sunrise_Cabinet_1;
	private static LBR _lbr;
	
	public MediaFlangeIOGroup daIO;

	@Override
	public void initialize() 
	{
		kuka_Sunrise_Cabinet_1 = getController("KUKA_Sunrise_Cabinet_1");
		_lbr = (LBR) getDevice(kuka_Sunrise_Cabinet_1,
				"LBR_iiwa_7_R800_1");
		
		daIO = new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		
	}
	
static double[] jpos={-Math.PI / 180 * 90., -Math.PI / 180 * 10., 0., -Math.PI / 180 * 100., Math.PI / 180 * 90.,
        Math.PI / 180 * 90., 0.};
static double jRelVel=0.1;

    private void moveToInitialPosition()
    {
    	_lbr.move(
        		ptp(0., -Math.PI / 180 * 10., 0., -Math.PI / 180 * 100., Math.PI / 180 * 90.,
                        Math.PI / 180 * 90., 0.).setJointVelocityRel(0.15));
        /* Note: The Validation itself justifies, that in this very time instance, the load parameter setting was
         * sufficient. This does not mean by far, that the parameter setting is valid in the sequel or lifetime of this
         * program */
        try
        {
        	
        }
        catch (IllegalStateException e)
        {
            getLogger().info("Omitting validation failure for this sample\n"
                    + e.getMessage());
        }
    }

	@Override
	public void run() {

		moveToInitialPosition();
		
		double[] indeces={0,3};
		double[] torques={5,5};
		PTPmotionJointSpaceConditional(indeces,torques);
		
		
	}

	public static void PTPmotionJointSpaceConditional(double[] indeces,double[] torques)
	{
		JointTorqueCondition[] con= new JointTorqueCondition [7];
		JointEnum[] jointsNum=new JointEnum[7];
		jointsNum[0]=JointEnum.J1;
		jointsNum[1]=JointEnum.J2;
		jointsNum[2]=JointEnum.J3;
		jointsNum[3]=JointEnum.J4;
		jointsNum[4]=JointEnum.J5;
		jointsNum[5]=JointEnum.J6;
		jointsNum[6]=JointEnum.J7;
		
		int num=indeces.length;
		if(num==0)
		{

		}
		
		for(int i=0;i<num;i++)
		{
			int index=(int)indeces[i];
			con[i]=new JointTorqueCondition(jointsNum[index],-torques[i],+torques[i]);
		}
		
		ICondition comb=con[0];
		
		for(int i=1;i<num;i++)
		{
			comb=comb.or(con[i]);
		}
		
		_lbr.move(
        		ptp(jpos[0],jpos[1],
        				jpos[2],
        				jpos[3],jpos[4],
        				jpos[5],
        				jpos[6]).setJointVelocityRel(jRelVel).breakWhen(comb));
		
	
	}
	
	/**
	 * Auto-generated method stub. Do not modify the contents of this method.
	 */
	public static void main(String[] args) {
		FirstTest app = new FirstTest();
		app.runApplication();
	}
}
