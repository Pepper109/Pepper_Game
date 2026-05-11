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
    if (tileType == 0){
        image(energy, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
    }
    if (tileType == 1){
        image(ice, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
    }
    if (tileType == 2){
        image(rock, gridX*tileSize, gridY*tileSize, tileSize, tileSize);
    }
    //rect(gridX*tileSize, gridY*tileSize, tileSize, tileSize);
}




}
