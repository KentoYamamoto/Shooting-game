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
    int timer_time;
    int timer_count;
    int speed;
    int mode;
    int mode_MAX;
    boolean cooltime; 
    boolean unlock;
    float[][] xy;
    boolean[] hit;
    Bullet(String Name, int Cost, int Damage, int Number, int Now, int Timer, int Count, int Speed,int Mode, int Mode_MAX, boolean Cooltime, boolean Unlock){
          name = Name;
          cost =Cost;
          damage =Damage;
          number =Number;
          timer_time = Timer;
          timer_count = Count;
          speed =Speed;
          mode = Mode;
          mode_MAX = Mode_MAX;
          cooltime = Cooltime;
          unlock = Unlock;
          xy = new float[2][number]; 
          hit = new boolean[number];
     }
}


