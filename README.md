# OhShock
OhShock项目




日程更新逻辑：
更新时和服务器端进行同步：添加服务器中有本地没有的到本地，添加本地有的服务器中没有的到服务器。

日程提醒逻辑：
服务器通过通知方式下达日程提醒。（后期再尝试动态添加到日历的功能）

目录结构：
.
    ├── OhShock
    │   ├── Ohshock：杂七杂八
    │   │   └── images：放了一些图片
    │   │     
    │   ├── Vender：工具类、没有用 pod 管理的第三方类
    │   │   ├── Base:可复用的基础控件
    │   │   ├── Util：工具类（category）、成熟的控件
    │   │   └── XXX：第三方类库
    │   │
    │   ├── Model：和服务器交互的 Model 
    │   │
    │   ├── Assets.xcassets：这里有一部分的文件
    │   │
    │   ├── 小模块：项目解耦出来可以单独使用的控件
    └── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具
