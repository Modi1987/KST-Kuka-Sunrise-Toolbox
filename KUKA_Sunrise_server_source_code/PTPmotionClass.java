package lbrExampleApplications;

import static com.kuka.roboticsAPI.motionModel.BasicMotions.circ;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.lin;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.linRel;
import static com.kuka.roboticsAPI.motionModel.BasicMotions.ptp;

import java.util.StringTokenizer;

import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.geometricModel.Frame;

public class PTPmotionClass {
	private static LBR _lbr; 
	private static BackgroundTask daback;
	private Controller kuka_Sunrise_Cabinet_1;
	private MediaFlangeIOGroup daIO;
	
    //private static final String stopCharacter="\n"+Character.toString((char)(10));
    private static final String stopCharacter=Character.toString((char)(10));

	
	PTPmotionClass(LBR _lbr,BackgroundTask daback,Controller kuka_Sunrise_Cabinet_1)
	{
		this._lbr=_lbr;
		this.daback=daback;
		this.kuka_Sunrise_Cabinet_1=kuka_Sunrise_Cabinet_1;
		daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
	}
	
	public static void PTPmotionJointSpace()
	{
		_lbr.move(
        		ptp(MatlabToolboxServer.jpos[0],MatlabToolboxServer.jpos[1],
        				MatlabToolboxServer.jpos[2],
        				MatlabToolboxServer.jpos[3],MatlabToolboxServer.jpos[4],
        				MatlabToolboxServer.jpos[5],
        				MatlabToolboxServer.jpos[6]).setJointVelocityRel(MatlabToolboxServer.jRelVel));
		
		String tempString="done"+stopCharacter;
		daback.sendCommand(tempString);
		
	}
	
	public static void PTPmotionCartizianSpace()
	{
		Frame daframe= _lbr.getCurrentCartesianPosition(_lbr.getFlange());
		int kkk=0;
		daframe.setX(MatlabToolboxServer.EEFpos[kkk]);
		kkk=kkk+1;
		daframe.setY(MatlabToolboxServer.EEFpos[kkk]);
		kkk=kkk+1;
		daframe.setZ(MatlabToolboxServer.EEFpos[kkk]);
		kkk=kkk+1;
		daframe.setAlphaRad(MatlabToolboxServer.EEFpos[kkk]);
		kkk=kkk+1;
		daframe.setBetaRad(MatlabToolboxServer.EEFpos[kkk]);		
		kkk=kkk+1;
		daframe.setGammaRad(MatlabToolboxServer.EEFpos[kkk]);
		
		
		_lbr.move(lin(daframe).setCartVelocity(MatlabToolboxServer.jRelVel));
		
		String tempString="done"+stopCharacter;
		daback.sendCommand(tempString);
		
	}
	
	public static void PTPmotionCartizianSpaceCircle()
	{
		Frame daframe1= _lbr.getCurrentCartesianPosition(_lbr.getFlange());
		Frame daframe2= _lbr.getCurrentCartesianPosition(_lbr.getFlange());
		int kkk=0;
		daframe1.setX(MatlabToolboxServer.EEFposCirc1[kkk]);
		kkk=kkk+1;
		daframe1.setY(MatlabToolboxServer.EEFposCirc1[kkk]);
		kkk=kkk+1;
		daframe1.setZ(MatlabToolboxServer.EEFposCirc1[kkk]);
		kkk=kkk+1;
		daframe1.setAlphaRad(MatlabToolboxServer.EEFposCirc1[kkk]);
		kkk=kkk+1;
		daframe1.setBetaRad(MatlabToolboxServer.EEFposCirc1[kkk]);		
		kkk=kkk+1;
		daframe1.setGammaRad(MatlabToolboxServer.EEFposCirc1[kkk]);
		
		kkk=0;
		daframe2.setX(MatlabToolboxServer.EEFposCirc2[kkk]);
		kkk=kkk+1;
		daframe2.setY(MatlabToolboxServer.EEFposCirc2[kkk]);
		kkk=kkk+1;
		daframe2.setZ(MatlabToolboxServer.EEFposCirc2[kkk]);
		kkk=kkk+1;
		daframe2.setAlphaRad(MatlabToolboxServer.EEFposCirc2[kkk]);
		kkk=kkk+1;
		daframe2.setBetaRad(MatlabToolboxServer.EEFposCirc2[kkk]);		
		kkk=kkk+1;
		daframe2.setGammaRad(MatlabToolboxServer.EEFposCirc2[kkk]);
		
		
		_lbr.move(circ(daframe1,daframe2).setCartVelocity(MatlabToolboxServer.jRelVel));
		
		String tempString="done"+stopCharacter;
		daback.sendCommand(tempString);
		
	}
	
	public static void PTPmotionCartizianSpaceRelWorld()
	{
		
		Frame daframe= _lbr.getCurrentCartesianPosition(_lbr.getFlange());
		

		daframe.setX(MatlabToolboxServer.EEFpos[0]+daframe.getX());

		daframe.setY(MatlabToolboxServer.EEFpos[1]+daframe.getY());

		daframe.setZ(MatlabToolboxServer.EEFpos[2]+daframe.getZ());

		
		
		_lbr.move(lin(daframe).setCartVelocity(MatlabToolboxServer.jRelVel));
		
		String tempString="done"+stopCharacter;
		daback.sendCommand(tempString);
		
	}
	
	
	public static void PTPmotionCartizianSpaceRelEEf()
	{
		
		double x,y,z;
		x=MatlabToolboxServer.EEFpos[0];

		y=MatlabToolboxServer.EEFpos[1];

		z=MatlabToolboxServer.EEFpos[2];

		
		_lbr.getFlange().move(linRel(x,y,z).setCartVelocity(MatlabToolboxServer.jRelVel));
		
		String tempString="done"+stopCharacter;
		daback.sendCommand(tempString);
		
	}
	

}
