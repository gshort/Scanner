public class StatusUpdater extends Thread {
  private String url;
  public long lastUpdate;
  public volatile boolean pause;

  public StatusUpdater (String s){
      url = s;
  }
  
  public void run() {
    while(true) {
      if(!pause) {
        lastUpdate = System.currentTimeMillis() / 1000;
        pingScanned.rewind();
        pingScanned.play();
        String result = loadStrings(url)[0];
        if(result.indexOf("error") >= 0) {
          pingFailure.rewind();
          pingFailure.play();
        } else {
          pingSuccess.rewind();
          pingSuccess.play();
        }
        println(result);
        pause = true;
      }
    }
  }
}
