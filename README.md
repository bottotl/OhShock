# OhShock
OhShock项目




日程更新逻辑：
更新时和服务器端进行同步：添加服务器中有本地没有的到本地，添加本地有的服务器中没有的到服务器。

日程提醒逻辑：
服务器通过通知方式下达日程提醒。（后期再尝试动态添加到日历的功能）

目录结构：

####下面介绍一下文件的大概目录先：
    .
    ├── OhShock
    │   ├── Ohshock：杂七杂八
    │   │   └── images：放了一些图片
    │   ├── Vender：工具类、没有用 pod 管理的第三方类
    │   ├── Resources：资源文件
    │   ├── Util：一些常用控件和Category、Manager之类
    │   │   ├── Common：对原生控件的一些扩展
    │   │   ├── Manager：管理（工具）类
    │   │   └── OC_Category：对原生控件的一些扩展（和Common重复了……）
    │   ├── Vendor：用到的一些第三方类库，一般都有改动
    │   │   ├── FDFullscreenPopGesture：全屏丝滑返回
    │   │   ├── FDTemplateLayoutCell：动态计算 Cell 高度
    │   │   └── JTCalender：日历控件
    │   ├── ViewControllers：控制器，对应app中的各个页面
    │   │   ├── Main：对应 Main.storyboard 中的页面
    │   │   ├── Me：对应 Me.storyboard 中的页面
    │   │   ├── Discover：对应 Discover.storyboard 中的页面
    │   │   ├── ToChatMain：对应 ToChatMain.storyboard 中的页面 
    │   │   └── Todo：对应 Todo.storyboard 中的页面
    │   └── Views：视图类
    │       ├── UIMessageInputView：输入框（在多个页面用到）
    │       ├── Cell：所有的 UITableViewCell 都放在这里
    │       ├── CollectionCell：所有的 UICollectionViewCell 都放在这里
    │       └── XXX：其它视图
    └── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具

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
