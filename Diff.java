
import lejos.robotics.navigation.DifferentialPilot;
import lejos.robotics.RegulatedMotor;
import lejos.util.PilotProps;

public class Diff{

	static RegulatedMotor leftMotor;
	static RegulatedMotor rightMotor;
	
	public static void main(String[] args) {

				
		
		PilotProps pp = new PilotProps();
	    	float wheelDiameter = Float.parseFloat(pp.getProperty(PilotProps.KEY_WHEELDIAMETER, "5.6"));
	    	float trackWidth = Float.parseFloat(pp.getProperty(PilotProps.KEY_TRACKWIDTH, "13.0"));
	    	leftMotor = PilotProps.getMotor(pp.getProperty(PilotProps.KEY_LEFTMOTOR, "B"));
	    	rightMotor = PilotProps.getMotor(pp.getProperty(PilotProps.KEY_RIGHTMOTOR, "C"));
	    	boolean reverse = Boolean.parseBoolean(pp.getProperty(PilotProps.KEY_REVERSE,"false"));


		DifferentialPilot pilot = new DifferentialPilot(wheelDiameter, trackWidth, leftMotor, rightMotor, reverse);  // parameters
		pilot.travel(50);  //  move backward for 50 cm
		//Comment out for travelling in arc
		//pilot.travelArc(50,50);	
		pilot.stop();
		
	}

}

