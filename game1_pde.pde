class Bullet_setup{
  Bullet_setup(int n){
    switch (n){
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }
}

class Bullet{
    String name;
    int cost;
    int damage;
    int number;
    int now;
    int timer_time; //60fps = 1 second
    int speed;
    int mode_MAX;
    boolean charge; 
    boolean unlock;
    float[][] xy;
    boolean[] hit;
    Bullet(String Name, int Cost, int Damage, int Number, int Now, int Timer, int Speed, int Mode_MAX, boolean Charge, boolean Unlock){
          name = Name;
          cost =Cost;
          damage =Damage;
          number =Number;
          speed =Speed;
          mode_MAX = Mode_MAX;
          charge = Charge;
          unlock = Unlock;
          xy = new float[2][number]; 
          hit = new boolean[number];
     }
}