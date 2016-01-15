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
│   │   ├── Base：可复用的基础控件
│   │   ├── Util：一些常用控件和Category
│   │   ├── Manager：管理（工具）类
│   │   └── XXX：第三方类库
│   ├── Model：和服务器交互的 Model 
│   ├── Assets.xcassets：这里有一部分的文件
│   ├── 小模块：项目解耦出来可以单独使用的控件
│   │   ├── 上传：上传 post 的控件
│   │   ├── Chat：聊天相关界面
│   │   ├── Intro：引导页
│   │   ├── Login：登陆界面
│   │   └── SignUp：注册界面
│   ├── Discover：发现页
│   │   ├── Post：查看动态页面
│   │   │   ├── ViewModel：给 View 填充数据使用的数据模型（为了写代码方便）
│   │   │   ├── View：单独的小视图
│   │   │   └── 其他：PostView 主页面和容器 Cell
│   │   ├── Todo：日程动态页面
│   │   │   ├── View：单独的小视图
│   │   │   └── 其他：DiscoverTodoViewController 主页面和容器 Cell
│   │   └── 其他:DiscoverViewController 和容器 Cell
│   ├── Me：“我”页
│   │   ├── Cell：“我”页面中使用的 TableViewCell 
│   │   ├── HeadView：展示头像的 View（用在 TableView 中）
│   │   └── 其他：登出的业务逻辑、视图控制器
│   ├── Todo：日程页面
│   │   ├── AddTodo：添加日程相关
│   │   ├── AddFriend：查找好友、好友信息展示相关
│   │   ├── Cell：日程展示页面的 Cell 
│   │   └── 其他：三种展示形式的视图控制器（日历模式、所有模式、类型模式）
└── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具

