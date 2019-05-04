import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

PImage slider1;
PImage slider2;
PImage slider3;
PImage colourWheel;
PImage circle;
String input;
Boolean busy = false;

void setup(){
  size(1280,780);
  orientation(LANDSCAPE);
 slider1 = loadImage("slider1.png");
 slider2 = loadImage("slider2.png");
 slider3 = loadImage("slider3.png");
 colourWheel = loadImage("colorWheel.png");
 circle = loadImage("circle.png");
}

void draw(){
  imageMode(CENTER);
  background(230);
  image(slider1,width/5,height/2,width/28,height/2);
  image(slider2,(width/5)*2,height/2,width/28,height/2);
  image(slider3,(width/5)*4,height/2,width/28,height/2);
  image(circle,(width/5)*3,height/2);
  image(colourWheel,(width/5)*3,height/2, height/3, height/3);

}


//{"status":"on","hue":100,"level":50}'//
void mousePressed(){
//if ((mouseX >= ((width/5)*3)- colourWheel.width/2) && mouseX <= ((width/5)*3) + colourWheel.width/2){
//if((mouseY >= (height/2)- colourWheel.height/2) && mouseY <= (height/2) + colourWheel.height/2){
  
int red = int((float(mouseY)/float(height)) * 255);
int green = int((float(mouseX)/float(width)) * 255);
int blue = 200;

 float angle = atan2(mouseY-height/2, mouseX-((width/5)*3));
  angle = map(angle*180/PI,-180,180,0,360);  

  input = "{\"status\":\"on\",\"hue\":"+ int(angle)+",\"level\":50}";
  println(input);
  if (!busy) thread("sendCommand");
  //}
//}
}

void sendCommand(){
  busy = true;
      try{
    URL url = new URL("http://192.168.1.8/gateways/0x43e8/rgb_cct/1");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setDoOutput(true);
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json");
  
        OutputStream os = conn.getOutputStream();
    os.write(input.getBytes());
    os.flush();
    BufferedReader br = new BufferedReader(new InputStreamReader(
        (conn.getInputStream())));
    String output;
    System.out.println("Output from Server .... \n");
    while ((output = br.readLine()) != null) {
      System.out.println(output);
    }
    conn.disconnect();
    } catch (MalformedURLException e) {
    e.printStackTrace();
    } catch (IOException e) {
    e.printStackTrace();
   }
   busy = false;
}
