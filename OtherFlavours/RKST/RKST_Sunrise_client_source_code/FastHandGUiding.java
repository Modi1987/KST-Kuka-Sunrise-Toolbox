package lbrExampleApplications_client;

// Copyright: Mohammad SAFEEA, 9th-April-2018

import com.kuka.generated.ioAccess.MediaFlangeIOGroup;
import com.kuka.roboticsAPI.controllerModel.Controller;
import com.kuka.roboticsAPI.deviceModel.LBR;

public class FastHandGUiding {

	private static MediaFlangeIOGroup daIO;
	private static boolean handGuidingFlag;
	
	
    // Button variables
    private static int[] filterBuffer;
    
    private static final int filterSize=4; // 7 worked well
	
    private static double analogAverage=0;
    private static int filteredInt=0;
    private static int previousInt=0;
    
    private static long risingEdgeTime=0;
    private static long fallingEdgeTime=0;
    
    
    // Button press times
    private static final int min1=50;
    private static final int max1=700;
    
    
    private static final int min3=1500;
    private static final int max3=100000;
    
    private static LBR _lbr;
    
    public static void handGUiding(LBR lbr, Controller kuka_Sunrise_Cabinet_1)
    {
		// Initialize the button variables
		// Filter for the button press
		filterBuffer=new int[filterSize];
		// Initialize the filter with zeros
		for(int i=0;i<filterSize;i++)
		{
			filterBuffer[i]=0;
		}
		
	    analogAverage=0;
	    filteredInt=0;
	    previousInt=0;
	    
		risingEdgeTime=0;
		fallingEdgeTime=0;
		// End of the initialization

		
		// Create IO of the mediaflange
    	_lbr=lbr;
		daIO=new MediaFlangeIOGroup(kuka_Sunrise_Cabinet_1);
		handGuidingFlag=true;
    	while(handGuidingFlag)	
    	{
    		
    		lbr.setESMState("1");
    		daIO.setLEDBlue(true);

    		lbr.move(com.kuka.roboticsAPI.motionModel.HRCMotions.handGuiding());
    		
    		lbr.setESMState("2");
    		
    		/// Nested loop used to analyse the green button after the fast motion
    		boolean nestedLoopFlag=true;
    		while(nestedLoopFlag)
    		{
    			// read Button state
    			String s=getButtonStateInFastHandGuiding();
    			if(s.equals("same mode")) // 
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
    	daIO.setLEDBlue(false);
    }
    
    
    
	private static boolean raisingEdgeFlagFast=false;
    private static String getButtonStateInFastHandGuiding() {
		// fast hand guiding, button state
    	for(int i=1;i<filterSize;i++)
		{
			filterBuffer[i-1]=filterBuffer[i];
		}
    	filterBuffer[filterSize-1]=readButtonState();
    	
    	double sum=0;
    	
    	for(int i=0;i<filterSize;i++)
		{
    		sum=sum+filterBuffer[i];
		}
    	
    	analogAverage=sum/filterSize;
    	
    	if(analogAverage>0.5)
    	{
    		previousInt=filteredInt;
    		filteredInt=1;
    	}
    	else
    	{
    		previousInt=filteredInt;
    		filteredInt=0;
    	}
    	
   	
    	if(filteredInt-previousInt==1)
    	{
    		if(raisingEdgeFlagFast==false)
    		{
	    		risingEdgeTime= System.currentTimeMillis();
	    		fallingEdgeTime=0;
	    		
	    		raisingEdgeFlagFast=true;
    		}
    		
    		return "";
    	}
    		
    	else if(filteredInt-previousInt==0 && raisingEdgeFlagFast==true)
    	{
            	// Make lights signals, 

            		long tempInterval=System.currentTimeMillis()-risingEdgeTime;
            		if((tempInterval>min3) && (tempInterval<max3))
            		{
            			flickerTheLightsFastHandGuiding(tempInterval);
            		}
            		
            	
            	return "";
            	       	
    	}
    	// detect on falling edge
    	else if(filteredInt-previousInt==-1)
    	{
    		raisingEdgeFlagFast=false;

    		
    		daIO.setLEDBlue(true);
    		fallingEdgeTime=System.currentTimeMillis();

    		
        	
        	long tempo=fallingEdgeTime-risingEdgeTime;
        	if((tempo > min1) && (tempo < max1))
        	{
        	    analogAverage=0;
        	    filteredInt=0;
        	    previousInt=0;
        	    
        	    risingEdgeTime=0;
        	    fallingEdgeTime=0;
        		return "same mode";

        	}

        	else if((tempo > min3) && (tempo < max3))
        	{
        	    analogAverage=0;
        	    filteredInt=0;
        	    previousInt=0;
        	    
        	    risingEdgeTime=0;
        	    fallingEdgeTime=0;
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

    	}
    	else
    	{
    		daIO.setLEDBlue(true);

    	}
    }
    



	public static void endHandGuiding()
    {

    	handGuidingFlag=false;
    	
		// To turn off the fast hand guiding you shall put the ESMState to two
		_lbr.setESMState("2");
    }

    
    
}
