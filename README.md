# WKCWalker

原项目 SLCWalker 移步 WKCWalker (两者都可用, 后续只更新WKCWalker).

 ![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/titleBg.png).

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCWalkersvg?style=flat)](https://cocoapods.org/pods/WKCWalker) [![License: MIT](https://img.shields.io/cocoapods/l/WKCWalker.svg?style=flat)](http://opensource.org/licenses/MIT)

The animation is loaded in a chained manner. The following functions are classified by MARK.

This project will maintain and update for a long time.

1. MAKE, all based on the animation of the center point.
2. TAKE, all based on the boundary point. (At this time, the temporary repeat parameter is invalid, to be processed later).
3. MOVE, relative movement (based on the center point).
4. ADD, relative movement (based on the boundary).
5. Universal is for all types of animated styles.
6. Do not use the then parameter and use multiple animations at the same time, Such as makeWith(20).animate(1).makeHeight(20).animate(1), Will work at the same time.
7.  Transition animation.

Note: If there are no special comments, the parameters apply to all types.

For the specified animation method, you need the first call. For example, makeWidth, etc.

There are simple requirements for the calling sequence, starting with make, take, move, or add, ending with animate (for collectionView or tableView with reloadDataWithWalker), and no other special order in the middle.

### Version record

1.0.5 Progress init.

1.0.8 Function optimization.

1.1.1 get layout frame.

1.1.3 fix makeSize bug.

1.1.4 add Demo.














## 中文


链式方式加载动画,以下功能以MARK为分类作划分.
本项目会长期维护更新.
1.  MAKE分类,全部是以中心点为依据的动画.

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Make.gif).

2. TAKE分类,全部以边界点为依据.(此时暂时repeat参数是无效的,待后续处理).

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Take.gif).

3. MOVE分类,相对移动 (以中心点为依据).

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Move.gif).

4. ADD分类,相对移动(以边界为依据).

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Add.gif).

5. 通用是适用于所有类型的动画样式.

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Path.gif).

6. 不使用then参数,同时使用多个动画如makeWith(20).animate(1).makeHeight(20).animate(1) 会同时作用; 使用then参数时如makeWith(20).animate(1).then.makeHeight(20).animate(1) 会在动画widtha完成后再进行动画height.
7. TRANSITION 转场动画.

![Alt text](https://github.com/WKCLoveYang/WKCWalker/raw/master/screenShort/Transition.gif).

注: 如果没有特殊注释,则表示参数适用于所有类型.

### 使用.

```
 pod 'WKCWalker'
 
```
1. 对于调用顺序有简单要求, 以make,take,move或者add等开始,以animate结束(对于collectionView或者tableView是以reloadDataWithDancer结束),其他在中间无特殊顺序要求. 例如:
```swift

self.view.moveX(-100).easeLiner.delay(2).reverses(YES).animate(2);

collectionView.c_makeScale(0.01).c_itemDuration(2).c_itemDelay(0.1).c_spring.reloadDataWithWalker();
```

UIView和CALayer同样适用.

OC请移步[WKCDancer](https://github.com/WKCLoveYang/WKCDancer).使用方法完全相同.

## 版本
1.0.5 初次确定版本.

1.0.8 功能优化.

1.1.1 处理layout不能获取坐标的问题.

1.1.3 修复makeSize的bug.

1.1.4 增加DEMO.

