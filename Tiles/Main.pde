import java.util.HashSet;
import java.util.HashMap;

HashSet<Integer> aliveCond = new HashSet<>();
HashSet<Integer> birthCond = new HashSet<>();
HashSet<Ship> ships = new HashSet<>();
HashSet<Projectile> projectiles = new HashSet<>();
HashSet<Projectile> projectilesToRemove = new HashSet<>();
HashSet<Player> players = new HashSet<>();
HashMap<Integer, Float> tileDistribution = new HashMap<>();
HashMap<Integer, Tile> tiles = new HashMap<>();
boolean simStart = true;
PImage energy, ice, rock, beam, mining, missile;
int tileYCount, tileXCount, frameCount = 0, updateInterval = 20, numTileType = 4;
float tileSize;
PFont font;                           // STEP 1 Declare PFont variable
Ship player1Ship = new Ship(new PVector(200,200));
Player player1 = new Player(player1Ship);
Ship player2Ship = new Ship(new PVector(800,400));
Player player2 = new Player(player2Ship);
int mineEnergyCost = 200;
int mineMetalCost = 300;
int rocketEnergyCost = 400;
int rocketMetalCost = 400;
PVector targetLocation = player1Ship.position.copy();

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
  ships.add(player1Ship);
  players.add(player1);
  ships.add(player2Ship);
  players.add(player2);
  projectiles.add(new Projectile(new PVector(200,200), new PVector(400,400), 0.1, new PVector(4,0), 5, 0.1, 280, 1000, player1Ship));
  
  tileDistribution.put(0, 0.3);
  tileDistribution.put(1, 0.3);
  tileDistribution.put(2, 0.3);
  tileDistribution.put(3, 0.1);


  for (int i = 0; i < tileXCount; i++) {
    for (int j = 0; j < tileYCount; j++) {
      tiles.put(getKey(i,j), new Tile(tileSize, i, j, generateTileType(tileDistribution)));
    }
  }
  energy = loadImage("lightning1.png");
  ice = loadImage("ice1.png");
  rock = loadImage("rock1.png");
  beam = loadImage("teleport1.png");
  mining = loadImage("mining1.png");
  missile = loadImage("missile.png");
  print("done setup");
  
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
  c.updateVisibility();
  c.display();
  if (c.modifier == 1){
    if (c.tileType == 0){
        player1.energy += 1;
    }
    if (c.tileType == 1){
        player1.water += 1;
    }
    if (c.tileType == 2){
        player1.metal += 1;
    }
  }
}


  for (Player p : players){
    if (frameCount % 10 == 0){
      p.energy -= (int) p.ship.velocity.copy().mag();
      p.water -= 2;
      if (p.ship.hitpoints < p.ship.maxhitpoints && p.water > 10){
        p.ship.hitpoints += 1;
        p.water -= 10;
      }
    }
    p.ship.moveTO(targetLocation);
  }

  for (Ship s : ships){
    s.display();
    s.hp_display();
  }
  for (Projectile p : projectiles){
    p.display();
    p.targetShip(p.shipTarget);
    p.lifetime -= 1;
    if (p.lifetime <= 0){
      p.alive = false;
    }
    if (p.position == p.target){
      p.alive = false;
    }
    if (p.alive == false){
      projectilesToRemove.add(p);
    }
  }
  projectiles.removeAll(projectilesToRemove);
  projectilesToRemove.clear();

  textFont(font,16);                  // STEP 3 Specify font to be used
  fill(10,255,255);                         // STEP 4 Specify font color
  text("Water: " + player1.water,10,100);   // STEP 5 Display Text
  text("Energy: " + player1.energy,10,80);
  text("Metal: " + player1.metal,10,60);
  text("Mine Cost: " + mineEnergyCost + " Energy, " + mineMetalCost + " Metal", 10, 40);
  text("Rocket Cost: " + rocketEnergyCost + " Energy, " + rocketMetalCost + " Metal", 10, 20);

  circle(400,400, 20);


}

void mousePressed() {
  print("pressed!");
  print(tileSize);
  //Tile c = getTile(new PVector(mouseX, mouseY));
  //c.modifier = 1;
}


int getKey(int n, int m){
    return (m+n)*(m+n+1)/2+m;
}

Tile getTile(PVector pos){
    //print ((int)floor(x/tileSize));
    return tiles.get(getKey((int)floor(pos.x/tileSize), (int)floor(pos.y/tileSize)));
}

boolean spaceTriggered = false;
boolean cTriggered = false;
boolean wTriggered = false;
boolean aTriggered = false;
boolean sTriggered = false;
boolean dTriggered = false;
void keyPressed(){
    if (key == ' ' && spaceTriggered == false){
      print("projectile created");
        projectiles.add(new Projectile(player1Ship.position.copy(), player2Ship.position.copy(), 0.1, player1Ship.velocity.copy().mult(0.33), 5, 0.1, 280, 1000, player2Ship));
        spaceTriggered = true;
        print("projectile created");
    }
    if (key == 'c' && cTriggered == false){
      Tile c = getTile(player1Ship.position);
      if (player1.energy >= mineEnergyCost && player1.metal >= mineMetalCost && c.modifier != 1){
        c.modifier = 1;
        player1.energy -= mineEnergyCost;
        player1.metal -= mineMetalCost;
        mineEnergyCost = (int) (mineEnergyCost*1.1);
        mineMetalCost = (int)(mineMetalCost*1.1);
        cTriggered = true;
      }
    }
    
    if (key == 'w' && wTriggered == false){
      targetLocation.add(new PVector(0, -10000));
      wTriggered = true;
    }
    if (key == 'a' && aTriggered == false){
      targetLocation.add(new PVector(-10000, 0));
      aTriggered = true;
    }
    if (key == 's' && sTriggered == false){
      targetLocation.add(new PVector(0, 10000));
      sTriggered = true;
    }
    if (key == 'd' && dTriggered == false){
      targetLocation.add(new PVector(10000, 0));
      dTriggered = true;
    }
}

void keyReleased() {
    if (key == ' '){
      spaceTriggered = false;
    }
    if (key == 'c'){
      cTriggered = false;
    }
    if (key == 'w'){
      wTriggered = false;
      targetLocation.sub(new PVector(0, -10000));
    }
    if (key == 'a'){
      aTriggered = false;
      targetLocation.sub(new PVector(-10000, 0));
    }
    if (key == 's'){
      sTriggered = false;
      targetLocation.sub(new PVector(0, 10000));
    }
    if (key == 'd'){
      dTriggered = false;
      targetLocation.sub(new PVector(10000, 0));
    }
    if (wTriggered == false && aTriggered == false && sTriggered == false && dTriggered == false){
      targetLocation = player1Ship.position.copy().add(player1Ship.velocity.copy());
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

int getTaxiDistance(int x1, int y1, int x2, int y2){
  return Math.abs(x1-x2)+Math.abs(y1-y2);
}

Ship getPlayer1Ship(){
  for (Ship s : ships){
    if (s.isPlayer == 1){
      return s;
    }
  }
  print("ship not found");
  return null;
}

float angleBetween(PVector v1, PVector v2) {
  float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
  if (a < 0) a += TWO_PI;
  return a;
}

// float angleBetween(float x1, float y1, float x2, float y2) {

//     float dot = x1 * x2 + y1 * y2;
//     float det = x1 * y2 - y1 * x2;

//     float angle = (float)Math.atan2(det, dot); // (-pi, pi]

//     if (angle < 0) {
//         angle += 2.0f * (float)Math.PI;
//     }

//     return angle; // [0, 2pi)
// }

// float angleVector(float x, float y){
//   return angleBetweeen(x,y,1,0);
// }

// float[] rotate(float x, float y, float theta) {
//     float cos = (float)Math.cos(theta);
//     float sin = (float)Math.sin(theta);

//     float xr = x * cos - y * sin;
//     float yr = x * sin + y * cos;

//     return new float[]{xr, yr};
// }

// float norm(float x, float y) {
//     return (float)Math.sqrt(x * x + y * y);
// }

// float distance(float x1, float y1, float x2, float y2){
//   return norm(x1-x2, y1-y2);
// }