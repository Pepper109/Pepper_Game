import java.util.HashSet;
import java.util.HashMap;

HashSet<Integer> aliveCond = new HashSet<>();
HashSet<Integer> birthCond = new HashSet<>();
HashSet<Ship> ships = new HashSet<>();
HashMap<Integer, Float> tileDistribution = new HashMap<>();
HashMap<Integer, Tile> tiles = new HashMap<>();
boolean simStart = true;
PImage energy, ice, rock;
int tileYCount, tileXCount, frameCount = 0, updateInterval = 20, numTileType = 3;
float tileSize;
PFont font;                           // STEP 1 Declare PFont variable

void setup() {
  size(1200, 800);
  font = createFont("Arial",16,true); // STEP 2 Create Font
  tileSize = width/30.0;
  tileYCount = (int)floor(height/tileSize);
  tileXCount = (int)floor(width/tileSize);

  aliveCond.add(2);
  aliveCond.add(3);
  aliveCond.add(444);
  birthCond.add(3);

  ships.add(new Ship(200, 200));
  
  for (int i = 0; i < numTileType; i++){
    tileDistribution.put(i, (float) 1/numTileType);
  }


  for (int i = 0; i < tileXCount; i++) {
    for (int j = 0; j < tileYCount; j++) {
      tiles.put(getKey(i,j), new Tile(tileSize, i, j, generateTileType(tileDistribution)));
    }
  }
  energy = loadImage("lightning1.png");
  ice = loadImage("ice1.png");
  rock = loadImage("rock1.png");
  
}

void draw() {
  background(111);
  frameCount++;
  for (Tile c : tiles.values()) {
      if (frameCount % updateInterval == 0 && simStart == true){
        c.updateAlive();
  }
  }
  for (Tile c : tiles.values()) {
  if (frameCount % updateInterval == 0 && simStart == true){
    c.alive = c.aliveNext;
  }
  c.display();
  }

  for (Ship s : ships){
    s.display();
    s.hp_display();
    s.moveTO(mouseX,mouseY);
  }

  textFont(f,16);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color
  text("Hello Strings!",10,100);   // STEP 5 Display Text


}

void mousePressed() {
  print("pressed!");
  print(tileSize);
  Tile c = getTile(mouseX, mouseY);
  if (c!= null){
  c.alive = !c.alive;
  print("alived!");
  }
}


int getKey(int n, int m){
    return (m+n)*(m+n+1)/2+m;
}

Tile getTile(float x, float y){
    print ((int)floor(x/tileSize));
    return tiles.get(getKey((int)floor(x/tileSize), (int)floor(y/tileSize)));
}

boolean sTriggered = false;
void keyPressed(){
    if (key == 's' && sTriggered == false){
        simStart = !simStart;
        sTriggered = true;
    }
}

void keyReleased() {
    if (key == 's'){
      sTriggered = false;
    }
}


int generateTileType(HashMap<Integer, Float> tileDistribution){
  float rand = (float) Math.random();
  int ret = 0;
  float check = 0;
  for (int i=0; i<numTileType; i++){
    check += tileDistribution.get(i);
    if (rand > check){
      ret +=1;
  }
  }
  return ret;
}
 //randomizes tiles according to a given distribution that adds up to 1
