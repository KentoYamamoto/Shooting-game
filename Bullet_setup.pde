class Bullet_setup{
  Bullet_setup(int n){
    
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
    boolean charge; 
    boolean unlock;
    float[][] xy;
    boolean[] hit;
    Bullet(String a, int b, int c, int d, int e, int f, int g, boolean h, boolean i){
          name = a;
          cost =b;
          damage =c;
          number =d;
          speed =g;
          charge = h;
          unlock = i;
          xy = new float[2][number]; 
          hit = new boolean[number];
     }
}
