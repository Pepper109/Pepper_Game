class Projectile{
    float  maxVelocity, homingRate, acceleration, homingRange, lifetime;
    int type;
    boolean alive;
    PVector position, velocity, target;
    //craft and launch different projectiles that consume different resources
    //rockets cost more gases, has homing
    //railgun ammunition costs more metals, has instant travel time, pierces shields
    //nukes cost uranium-235, are slow but explode 4 hex aoe destroying all tiles present

    Projectile(PVector position, PVector target, float homingRate, PVector velocity,
     float maxVelocity, float acceleration, float homingRange, float lifetime){
        this.position = position;
        this.target = target;
        this.homingRate = homingRate;
        this.velocity = velocity;
        this.maxVelocity = maxVelocity;
        this.acceleration = acceleration;
        this.homingRange = homingRange;
        this.alive = true;
        this.lifetime = lifetime;
    }

    void display(){
        rotate(atan2(velocity.y, velocity.x));
        image(missile, position.x, position.y, 20, 80);
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
            if (abs(rotateRate) > abs(diffAngle)){
                rotateRate = diffAngle;
            }
            velocity.rotate(-rotateRate);
            position.add(velocity);
            if (PVector.dist(position, target) < velocity.mag()){
                position.set(target);
                velocity.mult(0);
                alive = false;
            }
        }
    }

}