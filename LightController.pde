public class LightController extends Thread {
//  private Arduino arduino;
  private int ArdStatusFailPin = 6;
  private int ArdStatusInPin = 7;
  private int ArdStatusOutPin = 8;
  private int ArdRingRPin = 9;
  private int ArdRingGPin = 10;
  private int ArdRingBPin = 11;

  public LightController (Object context){
/*    arduino = new Arduino(context, Arduino.list()[0], 57600);
    arduino.pinMode(ArdStatusFailPin, Arduino.OUTPUT);
    arduino.pinMode(ArdStatusInPin, Arduino.OUTPUT);
    arduino.pinMode(ArdStatusOutPin, Arduino.OUTPUT);
    arduino.pinMode(ArdRingRPin, Arduino.OUTPUT);
    arduino.pinMode(ArdRingGPin, Arduino.OUTPUT);
    arduino.pinMode(ArdRingBPin, Arduino.OUTPUT);*/
  }
  
  public void run() {
    while(true) {
    }
  }
}
