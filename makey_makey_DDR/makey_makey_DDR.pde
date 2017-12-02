Arrow[] objects = new Arrow[1];
int good = 0;
int bad = 0;


void setup(){
 frameRate(40);
 fullScreen();
 background(255);
 int rand = int(random(4));
 objects[0] = new Arrow(rand, height - 1.5*height/8);
 
}



void newArrow(){ // call in draw, adds an arrow to the array every 4/200 times draw gets called.
  float x = random(105);
  if(x > 103){
    randomArrow();
  }
}
  
void randomArrow(){
  int rand = int(random(4));
  Arrow next = new Arrow(rand, height - 1.5*height/8);
  objects = (Arrow[])expand(objects, objects.length+1);
  for(int i = objects.length-1; i > 0; i--){
    objects[i] = objects[i-1]; // move all objects up in the array, leave objects[0] empty
  }
  objects[0] = next; // fill objects[0] with next
}

void updateObj(){ // call in draw, removes object from array if its off screen, moves arrows upwards
  for(int i = 0; i < objects.length; i++){
    objects[i].y -= 4;
    if(objects[i].y > height-200){
      objects = (Arrow[])shorten(objects);
    }
  }
}

void display(){
  for(int i = 0; i<objects.length; i++){
    image(objects[i]. arr, objects[i].x, objects[i].y);
  }
}
  
class Arrow{
  float x;
  float y;
  int randint;
  PImage arr;
  Arrow(int randomint, float why){
    y = why;
    randint = randomint;
    x = (width*randint/4)+200;
    arr = loadImage("arrow"+randint+".png");
  }
}

void input(int x){
  textSize(32);
  fill(0);
  for(int i = objects.length - 1; i >= 0; i--){
    if(objects[i].randint == x){
      if(50 < objects[i].y && 800 > objects[i].y){
        println("goes in if");
        //not able to print "Good!"
        text("Good!", objects[i].x + 200, 200);
        good ++;
        return;
      }
      else{
        println("goes in else");
        text("You Suck!", objects[i].x + 200, 200);
        bad ++;
        return;
      }
    }
  }
  text("You Suck", width*x/4 + 400, 200);
  bad++;
}

void draw(){
  background(255);
  //outlines do not work
  PImage outline0 = loadImage("outline0.png");
  PImage outline1 = loadImage("outline1.png");
  PImage outline2 = loadImage("outline2.png");
  PImage outline3 = loadImage("outline3.png");
  image(outline0, 200, 150);
  image(outline1, (width*1/4) + 200, 150);
  image(outline2, (width*2/4) + 200, 150);
  image(outline3, (width*3/4) + 200, 150);
  newArrow();
  updateObj();
  display();
  if(keyPressed){
    if(key == CODED){
      if(keyCode == LEFT){
        input(0);
      }
      else if(keyCode == UP){
        input(1);
      }
      else if(keyCode == DOWN){
        input(2);
      }
      else if(keyCode == RIGHT){
        input(3);
      }
    }
  }
  textSize(32);
  fill(0);
  text("Good: " + good, 50, 100);
  text("Bad: " + bad, 50, 150);
}
      
     
      
  