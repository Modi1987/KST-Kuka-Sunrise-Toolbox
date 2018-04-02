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
import com.kuka.roboticsAPI.controllerModel.Controller;
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
	private LBR _lbr;
	
	public MediaFlangeIOGroup daIO;

	@Override
	public void initialize() 
	{
		kuka_Sunrise_Cabinet_1 = getController("KUKA_Sunrise_Cabinet_1");
		_lbr = (LBR) getDevice(kuka_Sunrise_Cabinet_1,
				"LBR_iiwa_7_R800_1");
		
		daIO = new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		
	}
	
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
		
		Frame f1,f2;
		double r=75;
		f1=_lbr.getCurrentCartesianPosition(_lbr.getFlange());
		f2=_lbr.getCurrentCartesianPosition(_lbr.getFlange());
		
		f1.setY(f1.getY()+r);
		f1.setZ(f1.getZ()-r);
		
		f1.setGammaRad(f1.getGammaRad()+Math.PI/8);
		
		f2.setZ(f2.getZ()-2*r);
		
		f2.setGammaRad(f2.getGammaRad()+Math.PI/2);
		
		_lbr.getFlange().move(circ(f1,f2).setCartVelocity(50));
		
		
		
		
	}

	/**
	 * Auto-generated method stub. Do not modify the contents of this method.
	 */
	public static void main(String[] args) {
		FirstTest app = new FirstTest();
		app.runApplication();
	}
}
