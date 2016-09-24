Body b1 = new Body();
Body b2 = new Body();
JSONObject json;
String ds_path = "../TGSCDataset/";
String ds_file_name = "fragonly-All.json";
float boiling_point=221.693614;
float flash_point=92.272101;
float logP=3.520312;
float odor_substantivity=152.90637363;
float refractive_index=1.468392;
float specific_gravity=0.941115;
String[] scent_components = new String[0]; // {"http://www.thegoodscentscompany.com/data/rw1019161.html","http://www.thegoodscentscompany.com/data/es1027531.html"};
ArrayList<Body> bodieslist = new ArrayList<Body>();
Body[] bodies = {}; // new Body[0];
Mixer mixer = new Mixer();

void setup() {
  size(500, 500);
  background(255);
  smooth();
  frameRate(10);
  
  scent_components = append(scent_components, "http://www.thegoodscentscompany.com/data/rw1096561.html") ;
  scent_components = append(scent_components, "http://www.thegoodscentscompany.com/data/co1666531.html");
  scent_components = append(scent_components, "http://www.thegoodscentscompany.com/data/es1584811.html");
  String json_file_name = ds_path + ds_file_name;
  //print(json_file_name);
  json = loadJSONObject(json_file_name);
  //print(json);
  //  print(scent_components.length);
  int scent_components_count = scent_components.length;
  Object[] arr = new Object[scent_components_count];
     int i=0;
   for (String sc: scent_components) {
    //for (int i==0; i<=scent_components_count; i++) {
      JSONObject compData = json.getJSONObject(sc);
      Body b = new Body();
      //print(compData.getString("name") + "\n");
      b.odor_name = compData.getString("name");
    
      try {
      b.specific_gravity = compData.getFloat("specific_gravity");
      } catch(Exception ex) {b.specific_gravity = specific_gravity;}
    
      try {
      b.flash_point = compData.getFloat("flash_point");
      } catch(Exception ex) {b.flash_point = flash_point;}
    
      try {
      b.boiling_point = compData.getFloat("boiling_point");
      } catch(Exception ex) {b.flash_point = boiling_point;}
    
       try {
       b.substantivity = compData.getFloat("odor_substantivity");
       } catch(Exception ex) {b.flash_point = odor_substantivity;}
    
       b.odor_type = compData.getString("odor_type");
    
       b.odor_strength = compData.getString("odor_strength");
    
       //String[] descr1 = {"lavender","floral","herbal","woody"};
       JSONArray descr1 = compData.getJSONArray("odor_description");
       //
       //for(String d: descr1.getStringArray()) {
       //  print(d);
       //}
       b.odor_description = descr1.getStringArray();//compData.getJSONObject("odor_description").getStringArray(); //( // descr1; //{"floral","jasmin"};
    
       //b.bodycolor = color(240,210,240);
       //b.bodycolor = color(240,210,240);
       
       b.setup();
       //bodies[i]=b;
       bodieslist.add(b);
       
       //print(b.odor_strength);
       println(b.odor_name);
       println(b.odor_type);
       println(b.odor_description);
       i++;
      }
  //println(bodies.length); 
  //arr[0] = b1;
  //arr[1] = b2;
  //bodies = arr;
  //print(arr.length());
  //Body bb = b;
  bodies = bodieslist.toArray(new Body[bodieslist.size()]);
}

void draw() {
   background(255);
   fill(200);
   pushMatrix();
     //text(bodies[2].odor_name,25,50);
   popMatrix();
   mixer.getComponentList();
   mixer.getBodies();
   //bodies[2].renderBody();
 }

 void mousePressed() {
   //saveFrame("/home/masha/artwork.png");
   Body lb = new Body();
   lb.r=100;
   lb.n = (b1.n + b2.n)/3;
   lb.m = (b1.m + b2.m)/3;
   lb.d = (b1.d + b2.d)/3;
   lb.step = (b1.step + b2.step)/3;
   lb.iq = (b1.iq + b2.iq)/3;
   lb.helix_quantity=(b1.helix_quantity + b2.helix_quantity)/3;
   lb.bodycolor = b1.bodycolor + b2.bodycolor;
   pushMatrix();
    translate(mouseX, mouseY);
    lb.renderBody();
   popMatrix();
 }

class Mixer {
  void getComponentList(){
    int i=0;
    for (Body b: bodies) {
      i=i+10;
      //print(" " + i + " ");
      //print("Mixer say" + b.odor_name);
      pushMatrix();
        text(b.odor_name,25,i);
      popMatrix();
   }
  }
  void getBodies() {
    for (Body b: bodies) {
      b.renderBody();
    }
  }
}

class Body {
  String odor_name;  
  float specific_gravity; 
  float flash_point;
  float boiling_point;
  float substantivity;
  String odor_type;
  String odor_strength = "medium";
  String[] odor_description;
  float r = 300;
  float r_incr_step = 0;
  
  float sw;
  float n;
  float m;
  float d;
  float step;
  float x, y, x2, y2;
  float iq;
  float helix_quantity;
  String txt;
  color bodycolor;
  
 void setup(){
   txt = odor_name;
   sw = getStrenght(odor_strength);
   r=100*sw;
   n = (boiling_point - flash_point)/10;
   m = odor_description.length; 
   d = 1/specific_gravity; //wordToNumber(odor_name);
   step = sw/specific_gravity;
   iq = 6/sw; //1000/(sw*flash_point);
   helix_quantity = flash_point/50;
   r_incr_step = (flash_point*sw)/(substantivity*specific_gravity*1000);
   if (r_incr_step==Float.POSITIVE_INFINITY){r_incr_step=1;}
 }

int getStrenght(String word){
  //print("word=" + word);
  int rezult = 0;
   //if (word.equals("medium")) {rezult=2;}
   if (word.equals("high")) {rezult=3;}
   if (word.equals("low")) {rezult=1;}
   else {rezult=2;}
  return rezult;
}

void renderBody() {
  pushMatrix();
    translate(250,250);
    //ellipse(10,10,200,200);
    for (int i = 0; i < 360*helix_quantity; i += iq) {
    x = r*cos(radians(i*n/m))*sin(radians(i));
    y =  r*cos(radians(i*n/m))*cos(radians(i));
    x2 = r*cos(radians((i+d)*n/m))*sin(radians(i+d));
    y2 =  r*cos(radians((i+d)*n/m))*cos(radians(i+d));
    if (r < height) {
        r = r+r_incr_step;
    }
    
    stroke(bodycolor);
    strokeWeight(0.5);
    line(x, y, x2, y2);
    noStroke();
    fill(bodycolor);
    ellipse(x, y, 2, 2);
    ellipse(x2,y2,2,2);
    color(240,210,240);
    
    
  }
  d +=step;
  popMatrix();
}
 
}