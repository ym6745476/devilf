# DevilF 游戏引擎  

<p align="center" >
    <img src="https://github.com/ym6745476/devilf/blob/master/logo.png?raw=true" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/devilf-0.0.9-orange" />
    <img src="https://img.shields.io/badge/flutter-2.2.3-green" />
</p>

<p align="center" >
    A Flutter 2D RPG Game Engine On Web & Android & IOS.
</p>
<p align="center" >
    一个基于Flutter的2D RPG游戏引擎。
</p>
  
<p align="center" >
   The Devilf Engine Is A Open Source 2D Game Engine.
   The Engine Is Development Using Flutter & Dart Language.
   You Can Use It Independently In Your Flutter Project.
   Some Documentation Of How To Use It Can Be Found Here.
</p>

## 引擎介绍  
Flutter由Google的工程师团队打造，用于创建高性能、跨平台的移动应用。  
使用Flutter可以很容易的实现三端跨平台，为APP游戏化，以及跨平台游戏开发提供了更多可能性。  
感谢大家关注，也欢迎贡献你的想法和技术。欢迎加QQ群讨论：687500695！！！  

## 适用范围：  
中型游戏，营销活动，小游戏。  

## 主要特性：  
游戏循环，精灵渲染，精灵动画，摄像机，瓦片地图，碰撞检测等。   

## 开发手册  
https://ymbok.com/book/devilf.html  

## 在线体验    
https://ymbok.com/download/slayer.html  

## 安装引擎  
```yaml
dependencies:
  devilf: ^0.0.9
```

## 示例演示  
<img src="https://github.com/ym6745476/devilf/blob/master/screenshot/slayer.gif?v=9" width="600" height="292"/>  

## 示例功能  
* GameManager：游戏管理器  
* GameScene：游戏场景  
* PlayerSprite：玩家精灵  
* MonsterSprite：怪物精灵  
* EffectSprite：特效精灵  
* MapSprite：地图精灵  

## 核心组件    
* GameScene：游戏场景  
* GameWidget：游戏控件  
* GameRenderBox：渲染控件  
* GameLoop：游戏循环  
* Sprite：精灵类  
* Camera：摄像机    
* Audio：音效    

## 精灵渲染    
* TextSprite：文本精灵  
* ImageSprite：图片精灵  
* AnimationSprite：动画精灵  
* ProgressSprite：进度精灵  
* TileMapSprite：瓦片精灵  

## 游戏控件   
* Joystick：遥杆   
* Button：按钮   
* CheckButton：选择按钮  

## 游戏功能   
* 资源加载  
* 碰撞检测  
* 坐标转换  
* A*寻路算法  

## [0.0.9] - 2021/08/19.   
* 优化[示例] 修复BUG  
* 新增[示例] 人物界面背包页面 换装  
* 新增[示例] 数据配置文件  
* 优化[示例] 地图移动范围限制    
* 新增[示例] 怪物蛇，假人，两把武器素材  
* 新增[示例] 玩家和怪物动作和战斗音效  

## [0.0.8] - 2021/08/15.   
* 优化[示例] 修复BUG  
* 优化[核心] 代码逻辑优化  
* 新增[核心] 音效类       

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
* 优化[核心] 引擎代码和示例    

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
