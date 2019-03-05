package lbrExampleApplications;

//Copyright: Mohammad SAFEEA, 9th-April-2018

//import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.LBR;
import com.kuka.roboticsAPI.ioModel.IOTypes;

public class MediaFlangeFunctions {

    private LBR _lbr; 
	private Controller kuka_Sunrise_Cabinet_1;
	//private MediaFlangeIOGroup daIO;
	private BackgroundTask dabak;

	MediaFlangeFunctions(Controller kuka_Sunrise_Cabinet_1,LBR _lbr,BackgroundTask dabak)
	{
		this.kuka_Sunrise_Cabinet_1=kuka_Sunrise_Cabinet_1;
		this._lbr	=_lbr;
		this.dabak=dabak;
		//daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		
	}
	
	public boolean blueOn()
	{
		//daIO.setLEDBlue(true);
		return true;
	}
	
	public boolean blueOff()
	{
		//daIO.setLEDBlue(false);
		return true;
	}
	
	public boolean pin1On()
	{
		//daIO.setOutputX3Pin1(true);
		return true;
	}
	
	public boolean pin1Off()
	{
		//daIO.setOutputX3Pin1(false);
		return true;
	}
	
	public boolean pin11On()
	{
		//daIO.setOutputX3Pin11(true);
		return true;
	}
	
	public boolean pin11Off()
	{
		//daIO.setOutputX3Pin11(false);
		return true;
	}
	
	public boolean pin2On()
	{
		//daIO.setOutputX3Pin2(true);
		return true;
	}
	
	public boolean pin2Off()
	{
		//daIO.setOutputX3Pin2(false);
		return true;
	}
	
	public boolean pin12On()
	{
		//daIO.setOutputX3Pin12(true);
		return true;
	}
	
	public boolean pin12Off()
	{
		//daIO.setOutputX3Pin12(false);
		return true;
	}
	
	
	/*
	 * 		("InputX3Pin10", IOTypes.BOOLEAN, 1);
		("InputX3Pin16", IOTypes.BOOLEAN, 1);
		("InputX3Pin13", IOTypes.BOOLEAN, 1);
		("InputX3Pin3", IOTypes.BOOLEAN, 1);
		("InputX3Pin4", IOTypes.BOOLEAN, 1);
		*/
    private static final String stopCharacter="\n"+Character.toString((char)(10));
	
	public void getPin10()
	{
		//boolean bool=daIO.getInputX3Pin10();
		boolean bool=true;
		if(bool ==true)
		{
			String message="1"+stopCharacter;
			dabak.sendCommand(message);
		}
		else
		{
			String message="0"+stopCharacter;
			dabak.sendCommand(message);
		}

	}

	public void getPin16()
	{
		//boolean bool=daIO.getInputX3Pin16();
		boolean bool=true;
		if(bool ==true)
		{
			String message="1"+stopCharacter;
			dabak.sendCommand(message);
		}
		else
		{
			String message="0"+stopCharacter;
			dabak.sendCommand(message);
		}

	}

	public void getPin13()
	{
		//boolean bool=daIO.getInputX3Pin13();
		boolean bool=true;
		if(bool ==true)
		{
			String message="1"+stopCharacter;
			dabak.sendCommand(message);
		}
		else
		{
			String message="0"+stopCharacter;
			dabak.sendCommand(message);
		}

	}
	
	public void getPin3()
	{
		//boolean bool=daIO.getInputX3Pin3();
		boolean bool=true;
		if(bool ==true)
		{
			String message="1"+stopCharacter;
			dabak.sendCommand(message);
		}
		else
		{
			String message="0"+stopCharacter;
			dabak.sendCommand(message);
		}

	}

	public void getPin4()
	{
		//boolean bool=daIO.getInputX3Pin4();
		boolean bool=true;
		if(bool ==true)
		{
			String message="1"+stopCharacter;
			dabak.sendCommand(message);
		}
		else
		{
			String message="0"+stopCharacter;
			dabak.sendCommand(message);
		}

	}
}

