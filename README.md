# Devilf 恶魔游戏引擎  
A little game engine implemented with flutter.  

<p align="center" >
    <img src="https://img.shields.io/badge/flutter-2.2.3-green" />
</p>

<p align="center" >
    <img src="https://github.com/ym6745476/devilf/blob/master/logo.png?raw=true" />
</p>

## 引擎介绍  

引擎主页: https://ymbok.com   
适用范围：中小型游戏，APP内营销活动，小游戏   
主要特性：游戏循环，精灵动画，交互控制     
游戏支持：Tiled地图，Plist精灵，碰撞检测，遥杆控制器等     

### 截图 
![图片说明](https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/1.png "1.png")


# 结构关系图 
------------------------------------ GameScene ----------------------------------  
---------------------------------------- | --------------------------------------  
-------------------------- UI Widget --------- GameWidget -----------------------  
---------------------------------------- | --------------------------------------  
---------------------------------- - GameLoop -----------------------------------  
---------------------------------------- | --------------------------------------  
-------------------------------------- Sprite -----------------------------------  
---------------------------------------- | --------------------------------------  
------ FpsSprite ------ PlayerSprite ------ MapSprite ------ MonsterSprite ------   

# 功能说明
* GameScene：游戏场景  
* UI Widget：Flutter UI控件  
* GameWidget：管理游戏Widget 和 Sprite的控件  
* Game：通过Game Loop完成Sprite渲染  
* Sprite：精灵基础类  
* FpsSprite：Sprite的派生类显示帧数  
* PlayerSprite：玩家精灵类  
* MonsterSprite：怪物精灵类  
* MapSprite：地图精灵类  
