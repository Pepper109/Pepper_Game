class Player{
    int water, energy, metal;
    Ship ship;
    Player(Ship ship){
        this.water = 1000;
        this.energy = 1000;
        this.metal = 1000;
        this.ship = ship;
    }

    void updateShipSpeed(){
        ship.maxVelocity = ship.initialMaxVelocity * energy/1000;
        ship.acceleration = ship.initialAcceleration * energy/1000;
    }
}