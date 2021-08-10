# DevilF 游戏引擎  
A Flutter 2D RPG Game Engine.  
一个基于Flutter的2D RPG游戏引擎。  

<p align="center">
    <img src="https://img.shields.io/badge/devilf-0.0.7-orange" />
    <img src="https://img.shields.io/badge/flutter-2.2.3-green" />
</p>

<p align="center" >
    <img src="https://github.com/ym6745476/devilf/blob/master/logo.png?raw=true" />
</p>

## 引擎介绍  
(Devil Fighter)
自从有了Flutter，轻松实现了三端跨平台，并且不增加包体积，就能拥有一套Native游戏引擎，为APP游戏化提供了更多可能性。  
开发这套引擎的同时，也会同时开发引擎对应的游戏示例，将以2D RPG游戏作为示例来完善该引擎。  
感谢大家关注，也欢迎贡献你的想法和技术。  欢迎加QQ群讨论：687500695！！！

适用范围：中型游戏，营销活动，小游戏等；   
主要特性：游戏循环，精灵渲染，战斗系统；     
游戏支持：精灵动画，摄像机，瓦片地图，碰撞检测，遥杆控制器等。     

## 开发手册  
https://ymbok.com/book/devilf.html  

## 在线体验    
https://ymbok.com/example/devilf.html  

## 安装控件
```yaml
dependencies:
  devilf: ^0.0.7
```

### 示例演示
<img src="https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/devilf.gif" width="600" height="292"/>  

# 引擎框架
<img src="https://raw.githubusercontent.com/ym6745476/devilf/master/screenshot/doc_1.png" width="500" height="473"/>  

# 示例功能  
* GameManager：游戏管理器  
* GameScene：游戏场景  
* PlayerSprite：玩家精灵  
* MonsterSprite：怪物精灵  
* EffectSprite：特效精灵 
* MapSprite：地图精灵  

# 游戏组件  
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
* Camera：摄像机    
* AStar：A*最佳路径算法   

# 界面组件   
* Button：按钮控件   

# 推荐Flutter开发框架（Http请求，各类UI组件全搞定）
https://github.com/ym6745476/ym_flutter_widget  

## [0.0.7] - 2021/08/10.  
* 优化[示例] 自动战斗逻辑优化   
* 优化[示例] 主角和怪物A*寻目标  
* 新增[核心] A*最佳路径算法   
* 新增[核心] 碰撞形状 碰撞函数   
* 新增[核心] 绘制遮挡层和碰撞层    

## [0.0.6] - 2021/08/01.  
* 优化[示例] 技能区域 按钮布局   
* 新增[核心] 按钮控件  
* 新增[核心] 地图瓦片动态加载  
* 新增[核心] Camera 摄像机 主角跟随   
* 新增[示例] Tiled地图显示  
* 新增[核心] 新增瓦片精灵    
* 优化[核心] 摇杆不固定位置  
* 新增[示例] 玩家和怪物增加血条显示  
* 新增[核心] 进度精灵   
* 新增[示例] 目标锁定 自动移动 自动战斗   
* 新增[示例] 攻杀剑术和小火球特效  
* 新增[示例] 怪物死亡动画    
* 新增[示例] 新增蜘蛛怪物    

## [0.0.5] - 2021/07/16. 
* 优化[核心] 引擎的结构和已开发功能  

## [0.0.4] - 2021/07/15. 
* 新增[示例] 摇杆控制玩家移动   
* 新增[核心] Joystick 摇杆控件   

## [0.0.3] - 2021/07/11.  
* 新增[示例] 精灵渲染  
* 优化[核心] 重命名全部类增加DF前缀   
* 新增[核心] 读取TexturePacker导出的Plist转Json文件格式  
* 新增[核心] AnimationSprite  动画精灵  
* 新增[核心] ImageSprite  图像精灵  
* 新增[核心] TextSprite  文本精灵  

## [0.0.2] - 2021/07/07.  
* 新增[核心] GameScene  游戏场景  
* 新增[核心] AssetsLoader 资源读取  
* 新增[核心] GameRenderBox 渲染盒子  

## [0.0.1] - 2021/07/06.  
* 新增[核心] GameLoop 游戏循环  
* 新增[核心] GameWidget 游戏控件  
* 新增[核心] Sprite 基础精灵类  
