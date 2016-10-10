# IOSApp
集成了iOS开发中常用的基本类库，方便工程开发的时候环境搭建。

框架简介：
框架使用cocoapod管理，运行的时候点击 IOSApp.xcworkspace。
框架方便第一次工程开发环境的搭建，集成了基础的网络请求以及缓存的处理。实现了手势右滑返回。

网络库：AFNetworking
解析model：YYModel

目录结构
IOSApp
  ——Common				//存放工程通用的类

  ——LDCache				//存放工程缓冲管理类
	
  ——Model				//存放model数据结构	
	
  ——Networking				//存放工程网络相关
	
     ——LDNetworking.h				//网络基础类，封装AFNetworking
		 
     ——NetworkStatusCode.h			//定义一些网络状态码
		 
     ——Server.h					//服务器地址
		 
     ——ServerConnecting.h			//服务器请求的协议/借口	
		 
  ——Resource				//资源文件，如声音等
		
  ——thirdSDK				//一些无法通过pod加入的第三方库
	
  ——ViewController			//ViewController
	


