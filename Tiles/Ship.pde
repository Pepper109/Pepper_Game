//maybe we should have the player program the ship, i.e. have instruction blocks that automate the ship's activities
// and the player can unlock more abilities in the form of code blocks found by trading or looting enemy ships
//like spells in noita, and the player can set up multiple subroutines they can swap between (but this would cost more intruction blocks)
//would create kind of a deckbuilder roguelike feel? and the player can put stages on faster speed to watch their ship run
//at the start they would likely want one subroutine for farming, and one for combat, and maybe one for crafting materials
//subroutines would have run times, and maybe modifiers like in noita can be found? e.g. complete next two actions simultaneously, or 
//ignore run time of the next instruction
class Ship{
    float posX, posY, maxhitpoints, hitpoints, velocity, maxVelocity, acceleration;
    int gridX, gridY, destGridX, destGridY, ammo1Count, energyCount, waterCount, metalCount;
    boolean harvesting;
    Ship(float posX, float posY){
        this.posX = posX;
        this.posY=posY;
        this.maxhitpoints = 100;
        this.hitpoints =70;
        this.velocity = 0;
        this.maxVelocity = 5;
        this.acceleration = 0.1;
    }

    void display(){
        stroke(255, 255, 0);
        fill(0);
        circle(posX, posY, 20);
    }

    void hp_display(){
        fill(0,0,0);
        rect(posX-15, posY+25, 30, 5);
        fill(255,0,0);
        rect(posX-15, posY+25, 30*hitpoints/maxhitpoints, 5);
    }

    void moveTO(float targetX, float targetY){
        if (posX != targetX || posY != targetY){
           if(velocity < maxVelocity){
                velocity = min(velocity+acceleration, maxVelocity);
            }
            float diffX = targetX-posX;
            float diffY = targetY-posY;
            posX += velocity*diffX/(sqrt(diffX*diffX+diffY*diffY));
            posY += velocity*diffY/(sqrt(diffX*diffX+diffY*diffY));
            if (diffX*diffX+diffY*diffY < velocity*velocity){
                posX = targetX;
                posY = targetY;
                velocity = 0;
            }
        }
    }

    


}