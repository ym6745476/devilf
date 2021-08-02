# DevilF 游戏引擎  
A Flutter RPG Game Engine.  
一款使用Flutter开发的RPG游戏引擎。  

<p align="center">
    <img src="https://img.shields.io/badge/devilf-0.0.6-orange" />
    <img src="https://img.shields.io/badge/flutter-2.2.3-green" />
</p>

<p align="center" >
    <img src="https://github.com/ym6745476/devilf/blob/master/logo.png?raw=true" />
</p>

## 引擎介绍  
(Devil Fighter)
自从有了Flutter，轻松实现了三端跨平台，并且不增加包体积，就能拥有一套Native游戏引擎，为APP游戏化提供了更多可能性。  
开发这套引擎的同时，也会同时开发引擎对应的游戏示例，将以2D Tiled RPG游戏作为示例来完善该引擎。  
感谢大家关注，也欢迎贡献你的想法和技术。  

适用范围：中小型游戏，APP内营销活动，小游戏；   
主要特性：游戏循环，精灵动画，交互控制；     
游戏支持：Tiled地图，Plist精灵，碰撞检测，遥杆控制器等。     

## 开发手册  
https://ymbok.com/book-111-146.html  

## 在线体验    
https://ymbok.com/phone-111.html  

## 安装控件
```yaml
dependencies:
  devilf: ^0.0.6
```

### 示例演示
<img src="https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/devilf.gif?z=7" width="600" height="292"/>  

# 引擎框架
<img src="https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/doc_1.png" width="600" height="566"/>  

# 示例功能  
* GameManager：游戏管理器  
* GameScene：游戏场景  
* PlayerSprite：玩家精灵  
* MonsterSprite：怪物精灵  
* EffectSprite：特效精灵 
* MapSprite：地图精灵  

# 核心组件  
* AssetsLoading：游戏资源加载  
* GameScene：游戏场景（游戏界面）  
* UI Widget：Flutter控件（游戏界面的控件）  
* GameWidget：游戏主控件（管理游戏精灵）  
* GameLoop：游戏循环（更新和渲染精灵）   
* Sprite：精灵类  
* TextSprite：文本精灵  
* ImageSprite：图片精灵  
* AnimationSprite：动画精灵  
* ProgressSprite：进度精灵  
* TiledSprite：瓦片精灵  
* Joystick：遥杆控件  

# 推荐Flutter开发框架（Http请求，各类UI组件全搞定）
https://github.com/ym6745476/ym_flutter_widget  

## [0.0.6] - 2021/08/01.  
* 新增[核心] 瓦片精灵    
* 优化[核心] 摇杆不固定位置  
* 新增[示例] 玩家和怪物增加血条显示  
* 新增[核心] ProgressSprite  进度精灵   
* 新增[示例] 目标锁定 自动移动 自动战斗   
* 新增[示例] EffectSprite 攻杀剑术和小火球特效  
* 新增[示例] 怪物死亡动画    
* 新增[示例] 蜘蛛怪物    

## [0.0.5] - 2021/07/16. 
* 优化[核心] 引擎的结构和已有功能  

## [0.0.4] - 2021/07/15. 
* 新增[示例] 摇杆控制玩家移动   
* 新增[核心] Joystick 摇杆控件   

## [0.0.3] - 2021/07/11.  
* 新增[示例] 精灵渲染
* 优化[核心] 重命名全部类增加DF前缀   
* 新增[核心] 读取TexturePacker导出的Plist转Json文件格式  
* 新增[核心] AnimationSprite  
* 新增[核心] ImageSprite  
* 新增[核心] TextSprite  

## [0.0.2] - 2021/07/07.  
* 新增[核心] GameScene  游戏场景  
* 新增[核心] AssetsLoader 资源读取  
* 新增[核心] GameRenderBox 渲染盒子  

## [0.0.1] - 2021/07/06.  
* 新增[核心] GameLoop 游戏循环  
* 新增[核心] GameWidget 游戏控件  
* 新增[核心] Sprite 基础精灵类  
