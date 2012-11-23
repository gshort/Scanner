import processing.video.*;
import com.google.zxing.*;
import java.awt.image.BufferedImage;
import java.util.*;
import ddf.minim.*;

Capture cam; //Set up the camera
com.google.zxing.Reader reader = new com.google.zxing.MultiFormatReader();
HashMap statusUpdaters = new HashMap();
Minim minim;
AudioSnippet pingScanned;
AudioSnippet pingSuccess;
AudioSnippet pingFailure;

int WIDTH = 1280;
int HEIGHT = 720;

// Grabs the image file 

void setup() {
  size(WIDTH, HEIGHT);
  PFont metaBold;
  metaBold = loadFont("SansSerif-48.vlw");
  textFont(metaBold, 48); 
  textAlign(CENTER, CENTER);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println("[" + i + "] " + cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }
  minim = new Minim(this);
  pingScanned = minim.loadSnippet("pingScanned.wav");
  pingSuccess = minim.loadSnippet("pingSuccess.wav");
  pingFailure = minim.loadSnippet("pingFailure.wav");
}
 

void draw() {
  if (cam.available() == true) {
    cam.read(); 
    image(cam, 0,0);
    try {
      //Create a bufferedimage
      BufferedImage buf = new BufferedImage(WIDTH,HEIGHT, 1); // last arg (1) is the same as TYPE_INT_RGB
      buf.getGraphics().drawImage(cam.getImage(),0,0,null);
      // Now test to see if it has a QR code embedded in it
      LuminanceSource source = new BufferedImageLuminanceSource(buf);
      BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source)); 
      Result result = reader.decode(bitmap); 
      //Once we get the results, we can do some display
      if (result.getText() != null) {
        ResultPoint[] points = result.getResultPoints();
        //Draw some ellipses on at the control points
        for (int i = 0; i < points.length; i++) {
          fill(#ff8c00);
          ellipse(points[i].getX(), points[i].getY(), 20,20);
          fill(#ff0000);
          text(i, points[i].getX(), points[i].getY());
        }
        String url = "http://eriemakerspace.com/ems_in_out.php?app=testApp&status=AUTO&code=" + URLEncode(result.getText());
        StatusUpdater updater;
        if(!statusUpdaters.containsKey(result.getText())) {
          statusUpdaters.put(result.getText(), new StatusUpdater(url));
          updater = (StatusUpdater)statusUpdaters.get(result.getText());
          updater.start();
        } else {
          updater = (StatusUpdater)statusUpdaters.get(result.getText());
        }
        if(System.currentTimeMillis() / 1000 - updater.lastUpdate > 10) {
          updater.pause = false;
        }
      }
    } catch (Exception e) {
       //println(e.toString()); 
    }
  }
}

String URLEncode(String string){
 String output = new String();
 try{
   byte[] input = string.getBytes("UTF-8");
   for(int i=0; i<input.length; i++){
     if(input[i]<0)
       output += '%' + hex(input[i]);
     else if(input[i]==32)
       output += '+';
     else
       output += char(input[i]);
   }
 }
 catch(UnsupportedEncodingException e){
   e.printStackTrace();
 }

 return output;
}
