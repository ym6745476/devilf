# Devilf 游戏引擎  
A little game engine implemented with flutter.  

<p align="center">
    <img src="https://img.shields.io/badge/devilf-0.0.2-orange" />
    <img src="https://img.shields.io/badge/flutter-2.2.3-green" />
</p>

<p align="center" >
    <img src="https://github.com/ym6745476/devilf/blob/master/logo.png?raw=true" />
</p>

## 引擎介绍  
(Devil Fighter)
自从有了Flutter，轻松实现了三端跨平台，并且不增加包体积，就能拥有一套Native游戏引擎，为APP游戏化提供了更多可能性。  
开发这套引擎的同时，也会同时开发引擎对应的游戏demo，将以2d tiled rpg游戏作为示例来完善该引擎。  
感谢大家关注，也欢迎贡献你的想法和技术。  

引擎主页：https://ymbok.com   
适用范围：中小型游戏，APP内营销活动，小游戏   
主要特性：游戏循环，精灵动画，交互控制     
游戏支持：Tiled地图，Plist精灵，碰撞检测，遥杆控制器等     

## 在线演示    
https://ymbok.com/phone-3.html  

### 截图 
<img src="https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/1.gif" width="300" height="617"/>  

# 结构关系图 
---------------------------- GameScene -----------------------------  
-------------------------------- | ---------------------------------  
------------------ UI Widget --------- GameWidget ------------------  
-------------------------------- | ---------------------------------  
-------------------------- - GameLoop ------------------------------  
-------------------------------- | ---------------------------------  
------------------------------ Sprite ------------------------------  
-------------------------------- | ---------------------------------  
-------- TextSprite ------- ImageSprite --- AnimationSprite --------  

# 功能说明
* GameScene：游戏场景  
* UI Widget：Flutter内置UI控件  
* GameWidget：管理游戏Widget和Sprite的控件  
* GameLoop：通过GameLoop显示Sprite更新和渲染  
* Sprite：精灵基础类  
* TextSprite：文本显示精灵  
* ImageSprite：图片精灵  
* AnimationSprite：动画帧精灵  
* AssetsLoading：资源加载  
