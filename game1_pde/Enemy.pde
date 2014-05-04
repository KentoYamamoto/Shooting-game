class Enemy {
  int hp;
  int x;
  int y;
  int w;
  int h;
  int exp;
  int[][] hit_scale; 
  boolean show;
  Enemy(int X, int Y){
    x = X;
    y = Y;
  }
  void move(int n){
    if(this.x > 700 || 300<this.x &&this.x < 500 )
      this.y -= 1;
    else
      this.y += 1;
    this.x -= 1;
  }
  void e_t01(){
    int[][] n = {{ 0, 0, 50, 50}}; //代入用
    hit_scale = new int[n.length][4]; //4はx,y,w,hの4つ
    for(int i = 0; i < n.length; i++){
      for(int j = 0; j < 4; j++){
        hit_scale[i][j] = n[i][j];
      }
    }
    hp = 5;
    w = 50;
    h = 50;
    exp = 1;
    show = true;
  }
  void damage(int m, int n){
    this.hp -=bullet_data[m].damage;
    if(this.hp <= 0){
      chara_exp += this.exp;
      this.show = false;
    }
  }
}
