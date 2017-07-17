package lbrExampleApplications;

import java.util.StringTokenizer;

public class StringManipulationFunctions {
	
	public static double jointRelativeVelocity(String daCommand)
	{
		StringTokenizer st= new StringTokenizer(daCommand,"_");
		String temp="0";
		if(st.hasMoreElements())temp=st.nextToken();
		if(st.hasMoreElements())temp=st.nextToken();
		return Double.parseDouble(temp);
	}

}
