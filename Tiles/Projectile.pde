class Projectile{
    float  maxVelocity, homingRate, acceleration, homingRange, lifetime, maxRotateRate;
    int type;
    boolean alive;
    PVector position, velocity, target;
    Ship shipTarget;
    //craft and launch different projectiles that consume different resources
    //rockets cost more gases, has homing
    //railgun ammunition costs more metals, has instant travel time, pierces shields
    //nukes cost uranium-235, are slow but explode 4 hex aoe destroying all tiles present

    float capFloat(float f, float cap){
        if (abs(f) > cap){
            if (f > cap){
                return cap;
            }
            if (f< cap){
                return -cap;
            }
        }
        return f;
    }

    Projectile(PVector position, PVector target, float lifetime, Ship shipTarget){
        this.position = position;
        this.target = target;
        this.lifetime = lifetime;
        this.shipTarget = shipTarget;
    }


    //useless methods, they don't get run. it's just here to make the compiler happy
    void display(){}
    void targetShip(Ship ship){}
    void moveTO(PVector target){}

}

class Missile extends Projectile{

    Missile(PVector position, PVector target, float homingRate, PVector velocity,
     float maxVelocity, float acceleration, float homingRange, float lifetime, Ship shipTarget){
        super(position, target, lifetime, shipTarget);
        this.position = position;
        this.target = target;
        this.homingRate = homingRate;
        this.velocity = velocity;
        this.maxVelocity = maxVelocity;
        this.acceleration = acceleration;
        this.homingRange = homingRange;
        this.alive = true;
        this.lifetime = lifetime;
        this.shipTarget = shipTarget;
        this.maxRotateRate = 0.13;
    }

    void display(){
        pushMatrix();
        imageMode(CENTER);
        translate(position.x, position.y);
        rotate(PI/2+atan2(velocity.y, velocity.x));
        image(missile, 0, 0, 20, 80);
        popMatrix();
        imageMode(CORNER);
    }

    
    void targetShip(Ship ship){
        moveTO(ship.position.copy());
    }

    void moveTO(PVector target){
        if (PVector.dist(position, target) > 0.00001){
           if(velocity.mag() < maxVelocity){
            if (velocity.mag() >0.001){
                velocity.add(velocity.copy().normalize().mult(acceleration));
            }
            if ((velocity.mag() < 0.001)){
                velocity.add(target.copy().sub(position).normalize().mult(acceleration));
            }
                velocity.limit(maxVelocity);
            }
            float diffAngle = angleBetween(target.copy().sub(position), velocity);
            if (diffAngle > PI){
                diffAngle = diffAngle-2*PI;
            }
            float rotateRate = (maxVelocity*2-velocity.mag())/maxVelocity*diffAngle*homingRate*homingRange*(float) Math.sqrt(homingRange)/(1+PVector.dist(position, target)*PVector.dist(position, target));
            rotateRate = capFloat(rotateRate, maxRotateRate);
            if (abs(rotateRate) > abs(diffAngle)){
                rotateRate = diffAngle;
            }
            velocity.rotate(-rotateRate);
            position.add(velocity);
            if (PVector.dist(position, target) < velocity.mag()){
                position.set(target);
                shipTarget.hitpoints -= 35;
                velocity.mult(0);
                alive = false;
            }
        }
    }

}

class Bullet extends Projectile{
    Bullet(PVector position, PVector target, float lifetime, Ship shipTarget, PVector velocity){
        super(position, target, lifetime, shipTarget);
        this.velocity = velocity;
    }

    void moveTO(PVector target){
        if (PVector.dist(position, target) >= velocity.mag()){
            position = position.add(velocity);
        }
        if (PVector.dist(position, target)< velocity.mag()){
            position = target;
        }
    }

    void display(){
        pushMatrix();
        imageMode(CENTER);
        translate(position.x, position.y);
        rotate(PI/2+atan2(velocity.y, velocity.x));
        image(missile, 0, 0, 20, 80);
        popMatrix();
        imageMode(CORNER);
    }
}