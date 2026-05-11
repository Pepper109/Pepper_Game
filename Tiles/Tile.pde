class Tile{
  float tileSize, posX, posY;
  int gridX, gridY, neighbourCount, id, tileType;
  //gas asteroids (fuel), rock/metal asteroids (ammunition, repairs), abandoned fuel cells (energy for leaving the stage)
  //planets have genetic material (currency - in the entire universe, diamond is more common than wood idea)
  //uranium asteroids (for nuclear fuel, nukes, or eventually kovarex enrichment)
  //abandoned military equipment (shield tiles that block projectiles)
  //start with fog of war, able to place down drills to harvest remotely and come back to collect (but anyone can steal from them)
  //able to place radars
  boolean alive, aliveNext;
  HashMap<Ship, Integer> visibility = new HashMap();

Tile(float tileSize, int gridX, int gridY, int tileType){
this.tileSize= tileSize;
this.gridX = gridX;
this.tileType = tileType;
this.gridY = gridY;
this.alive  = false;
this.id = (gridX+gridY)*(gridX+gridY+1)/2 + gridY;
}

int getAliveNeighboursCount(){
int aliveNeighboursCount = 0;
    for (int i=gridX-1;i <= gridX+1; i++){
        for (int j= gridY-1;  j<= gridY+1; j++){
            if (i < 0 || j < 0 || i >= tileXCount || j >= tileYCount) continue;
            Tile c = tiles.get(getKey(i,j));
            if (c!= null && c.alive == true && (i==gridX && j==gridY)==false){
                aliveNeighboursCount +=1;
                }
        }
    }
    return aliveNeighboursCount;
}

void updateAlive(){
    this.aliveNext = false;
    if (alive == true && aliveCond.contains(this.getAliveNeighboursCount())){
        this.aliveNext = true;
    }
    if (alive == false && birthCond.contains(this.getAliveNeighboursCount())){
        this.aliveNext = true;
    }
}


void display(){
    Ship s = getPlayerShip();
    boolean displayed = false;
    if (visibility.get(s) == 2){
        if (tileType == 0){
            image(energy, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
        }
        if (tileType == 1){
            image(ice, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
        }
        if (tileType == 2){
            image(rock, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
        }
        displayed = true;
        //rect(gridX*tileSize, gridY*tileSize, tileSize, tileSize);
    }
    if (visibility.get(s) == 1){
        stroke(0);
        fill(100,100,100);
        rect(gridX*tileSize, gridY*tileSize, tileSize, tileSize);
        displayed = true;
    }
    if (displayed == false){
        stroke(0);
        fill(0);
        rect(gridX*tileSize, gridY*tileSize, tileSize, tileSize);
    }

}

void updateVisibility(){
    for (Ship s : ships){
        if (visibility.containsKey(s) == false){
            visibility.put(s, 0);
        }
        if (getTaxiDistance(getTile(s.posX, s.posY).gridX, getTile(s.posX, s.posY).gridY, gridX, gridY) < s.visibilityRange){
            visibility.put(s, 2);
        }
        else {
            if (visibility.get(s) > 0){
                visibility.put(s, 1);
            }
            else {
                visibility.put(s, 0);
            }
        }
    }
}
//Update visibility first when introducing new ship!! since this adds ships to the list.

}
