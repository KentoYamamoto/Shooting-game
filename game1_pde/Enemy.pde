class Enemy {
  int hp;
  int hp_max;
  int x;
  int y;
  int w;
  int h;
  int atk;
  float def;
  int exp;
  int speed;
  int[][] hit_scale; 
  boolean show;
  Enemy(int X, int Y){
    x = X;
    y = Y;
  }
  void move(int n){
    if(this.x > 700 || 300<this.x &&this.x < 500 )
      this.y -= this.speed;
    else
      this.y += this.speed;
    this.x -= this.speed;
  }
  void e_t01(){
    int[][] n = {{ 0, 0, 25, 25}}; //代入用
    hit_scale = new int[n.length][4]; //4はx,y,w,hの4つ
    for(int i = 0; i < n.length; i++){
      for(int j = 0; j < 4; j++){
        hit_scale[i][j] = n[i][j];
      }
    }
    hp_max =20;
    hp = hp_max;
    w = 25;
    h = 25;
    atk = 50;
    def = 1.0;
    exp = 1;
    speed = 1;
    show = true;
  }
  void damage(int m, int n){
    this.hp -=bullet_data[m].damage*def;
    if(this.hp <= 0){
      chara_exp += this.exp;
      this.show = false;
      this.x = width;
      this.y = height;
    }
  }
}
