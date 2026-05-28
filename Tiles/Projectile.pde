class Projectile{
    float  maxVelocity, homingRate, acceleration, homingRange;
    int type;
    boolean alive;
    PVector position, velocity, target;
    //craft and launch different projectiles that consume different resources
    //rockets cost more gases, has homing
    //railgun ammunition costs more metals, has instant travel time, pierces shields
    //nukes cost uranium-235, are slow but explode 4 hex aoe destroying all tiles present

    Projectile(PVector position, PVector target, float homingRate, PVector velocity,
     float maxVelocity, float acceleration, float homingRange){
        this.position = position;
        this.target = target;
        this.homingRate = homingRate;
        this.velocity = velocity;
        this.maxVelocity = maxVelocity;
        this.acceleration = acceleration;
        this.homingRange = homingRange
        this.alive = true;
    }

    void moveTO(PVector target){
        if (PVector.dist(position, target) > 0.00001){
           if(velocity.mag() < maxVelocity){
                velocity.add(velocity.copy().normalize().mult(acceleration));
                velocity.limit(maxVelocity);
            }
            float diffAngle = PVector.angleBetween(target.copy().sub(position), velocity);
            float rotateRate = diffAngle*homingRate*homingRange*homingRange/(1+PVector.dist(position, target)*PVector.dist(position, target));
            velocity.rotate(rotateRate);
            position.add(velocity);
            if (PVector.dist(position, target) < velocity.mag()){
                position.set(target);
                velocity.mult(0);
                alive = false;
            }
        }
    }

}