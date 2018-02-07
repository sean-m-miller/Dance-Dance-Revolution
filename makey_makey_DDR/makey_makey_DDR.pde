Arrow[] objects = new Arrow[1]; //game object array, starts with one randomly generated arrow
int good = 0;
int bad = 0;
int inframe = 0;
int arframe = 0; // prevents arrows being generated too closely to eachother
int hot = 0;
int hotx = 0;
int lvl = 2; // determines speed of arrows
int timer = 0;
int len;
int gameframe = 0;
int actlvl = 1;
int realx = 0;
boolean game = false; // game is NOT over

void setup(){
 frameRate(40);
 fullScreen();
 background(255);
 int rand = int(random(4));
 objects[0] = new Arrow(rand, height - 1.5*height/8);
}

void newArrow(){ // call in draw, adds an arrow to the array every 50 times draw gets called.
  float x = random(105);
  if(x > 88 && arframe >= 30){
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

void updateObj(){ // call in draw, removes objects from array if they're off screen, moves arrows upwards
  for(int i = 0; i < objects.length; i++){
    objects[i].y -= 4 + (lvl*lvl); //speed at which arrows move upward is determined by lvl
    if(objects[i].y > height-200){ // if offcreen
      objects = (Arrow[])shorten(objects); // remove highest arrow
    }
  }
}

void display(){ //display game objects contained in array on screen
  for(int i = 0; i<objects.length; i++){
    image(objects[i]. arr, objects[i].x, objects[i].y);
  }
}
  
class Arrow{ //game object class. Each arrow has an x value and an orientation determined by randint
  float x;
  float y;
  int randint;
  PImage arr;
  Arrow(int randomint, float why){
    y = why;
    randint = randomint;
    x = (width*randint/4)+200;
    arr = loadImage("arrow"+randint+".png");
    arframe = 0; 
  }
}

void input(int x){ // interpret user input, edits player's score and removes items from game object array
  textSize(32);
  fill(0);
  if (inframe >= 24){ // button can be pressed once every 24 "frames" (prevents one press of button counting more than once)
    for(int i = objects.length - 1; i >= 0; i--){ //start at highest index, search down
      if(objects[i].randint == x){ //if button orientation equals 
        if(50 < objects[i].y && 250 > objects[i].y){ // acceptible button press
          text("Good!", realx + objects[i].x + 200, 200);
          good ++; //update varible used for "good: " display
          hot++; //update variable used for total amount of good hits
          println(hot);
          println(hotx);
          if(hot % 10 == 0){
            while(hotx*10 < hot){
              hotx++; //update variable used to tell amount of hotstreak
            }
          }
          for(int j = i; j < objects.length-1; j++){
            objects[j] = objects[j+1]; //move all arrows above the well-pressed arrow in the array (higher on the screen) down one spot,
            //overwriting the well-pressed arrow
          }
          objects = (Arrow[])shorten(objects); //shorten array by 1 (eliminate highest index)
          inframe = 0; //restart frame control
          return;
        }
        else{ //unacceptible button press
          text("Bad!", realx + objects[i].x + 200, 200);
          bad ++;
          hot = 0;
          hotx = 0;
          for(int j = i; j < objects.length-1; j++){
            objects[j] = objects[j+1]; //move elements down, overwriting badly-pressed arrow
          }
          objects = (Arrow[])shorten(objects); //eliminate largest index
          inframe = 0; //restart frame control
          return;
        }
      }
    }
    text("Bad!", realx + width*x/4 + 400, 200);
    bad++;
    hot = 0;
    hotx = 0;
  }
}

//Loops while game is played
void draw(){
  if(!game){ // while game has not been won
    inframe++; // frame rate control
    arframe++;
    background(255);
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
    if(keyPressed){ //handle user input
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
    text("Good: " + good, 50 + realx, 100);
    text("Bad: " + bad, 50 + realx, 150);
    text("Level: " + actlvl, 50 + realx, 200);
    if(hot >= 10){
      textSize(40);
      fill(255, 0, 0);
      text("HOTSTREAK!!!: " + hotx, realx + width/2 - 200, 100);
    }
    if(hotx == 2){
      game = true;
    }
  }
  else{ //win state
    background(255);
    gameframe ++;
    textSize(32);
    fill(0);
    textAlign(CENTER, CENTER);
    text("Congratulations! You won! Press any key to play again... but this time, at a harder level!", width/2, height/2);
    if(gameframe > 50 && keyPressed){
      if(actlvl == 1){ // dumb if statement, needed to fix a dumb bug where formatting would for some reason change after actlvl incrimented
        realx+=60;
      }
      lvl+=2;
      actlvl++;
      len = objects.length;
      for(int i = 0; i< len; i++){
        objects = (Arrow[])shorten(objects);
      }
      good = 0;
      bad = 0;
      hot = 0;
      hotx = 0;
      gameframe = 0;
      game = false;
    }
  }
}
