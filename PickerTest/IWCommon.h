// 0.账号相关
//#define HNAppKey @"1359433872"
//#define HNAppSecret @"37c372aa97a9329fc561947151c1bd38"

#define HNAppKey @"1777a250768c3"
#define HNAppSecret @"5f9c35c70a5b6f42ecbb22c550d47ed5"
#define HNRedirectURI @"http://www.witknow.com"
#define HNLoginURL [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", HNAppKey, HNRedirectURI]
#define STOREAPPID @"1153888743"

//主页地址
//#define kurl @"http://www.witknow.com/db/b1/b1.html"
//#define kurl @"http://www.baidu.com"
#define kurl @"http://www.sina.com"

// 1.判断设备系统
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define IOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
// 判断是否为iPhone5
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
// 判断是否为iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断设备
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

// 2.获得RGB颜色
#define HNColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define HNLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)//fix by howe
#else
#define HNLog(format, ...)
#endif

//#define krect [UIScreen mainScreen].applicationFrame.size//去掉状态栏
#define krect [UIScreen mainScreen].bounds.size
#define Kvmax (MAX(krect.width,krect.height))
#define Kvmin (MIN(krect.width,krect.height))

#define CW (iPhoneX?krect.width-(islandscape?88:0):krect.width)
#define CH (iPhoneX?krect.height-(islandscape?21:34):krect.height)
//#define CW ((islandscape && ([[NSUERDEFAULTS objectForKey:KlockScreenOrientation] integerValue] == 1 || [[NSUERDEFAULTS objectForKey:KlockScreenOrientation] integerValue] == 3)) ? Kvmin : krect.width)
//#define CH ((islandscape && ([[NSUERDEFAULTS objectForKey:KlockScreenOrientation] integerValue] == 1 || [[NSUERDEFAULTS objectForKey:KlockScreenOrientation] integerValue] == 3)) ? Kvmax : krect.height)

#define SW (krect.width)
#define SH (krect.height)
//#define M (int)(CW<(CH*0.7)?(CW/36.0):(CW<CH?(CW/50.0):(CW/64.0)))
//#define M (MAX(CW, CH) / 64)
#define M MIN(MAX(CW, CH)/64, MIN(CW,CH)/36)
#define W (int)(M*6.0)
#define H (int)(M*4.0)

//#define H ((CW<(CH*0.7)?(CW/36.0):(CW<CH?(CW/50.0):(CW/64.0)))*4.0)

#define bw1 (W*5)
#define Kcol1 (int)(CW / (bw1))
#define Km01 ((CW+M-(bw1+M)*Kcol1)*0.5)

#define Kcol (int)(CW / (W + M))
#define Km0 ((CW+M-(W+M)*Kcol)*0.5)


//自适应字体
#define kfontSizeF2 ((M*1.2)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSizeF3 ((M*1.4)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSizeF4 ((M*1.6)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSizeF5 ((M*1.8)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSizeF6 ((M*2)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSizeF7 ((M*2.4)+([[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]>0?[[NSUERDEFAULTS objectForKey:KFontFontSize] floatValue]:0))
#define kfontSize (kfontSizeF4)

#define CWH ((float)CW/CH)//宽高比
#define NB (CWH<0.7?4:(CWH<1?6:8)) //动态列数
#define IM (int)M
#define IM2 (int)(M*0.5)
#define A11 (int)(CW-M*2)
#define A21 (int)(CW*0.5-M*1.5)
#define A31 (int)(CW*0.333-M*1.33)
#define A32 (int)(CW*0.666-M*1.66)
#define A41 (int)(CW*0.25-M*1.25)
#define A43 (int)(CW*0.75-M*1.75)
#define A51 (int)(CW*0.2-M*1.2)
#define A52 (int)(CW*0.4-M*1.4)
#define A53 (int)(CW*0.6-M*1.6)
#define A54 (int)(CW*0.8-M*1.8)
#define A1T2 (int)(CW<CH?(CW-M*2):(CW*0.5-M*1.5))
#define B12M (int)(M*12)
#define B21 (int)((CW-M)/(NB*0.5)-M)
#define B31 (int)(M*13)
#define B41 (int)((CW-M)/NB-M)
#define B51 (int)(((CW-M)/(NB+1))-M)
#define B52 (int)((CW-M)*2/(NB+1)-M)
#define B53 (int)((CW-M)*3/(NB+1)-M)
#define C10 (int)(CW<CH?M*36:(CW-M*36))
#define C21 (int)(CW-B21-M*3)
#define C31 (int)(CW-B31-M*3)
#define C41 (int)(CW-B41-M*3)
#define C51 (int)(CW-B51-M*3)
#define C52 (int)(CW-B52-M*3)
#define C53 (int)(CW-B53-M*3)
#define C15MT2 (int)(CW<M*57?(CW-M*15):(CW*0.5-M*14.5))
#define C51T2 (int)(CW<CH?(CW-B51-M*3.0):(CW*0.5-B51-M*2.5))
#define C52T2 (int)(CW<CH?(CW-B52-M*3):(CW*0.5-B52-M*2.5))
#define C41T2 (int)(CW<CH?(CW-B41-M*3):(CW*0.5-B41-M*2.5))
#define C31T2 (int)(CW<CH?(CW-B31-M*3):(CW*0.5-B31-M*2.5))

#define D51 (int)((CW-M)/floorf((CW-M)/(M*7))-M-0.5)
#define D41 (int)((CW-M)/floorf((CW-M)/(M*8))-M-0.5)
#define D31 (int)((CW-M)/floorf((CW-M)/(M*10))-M-0.5)
#define D21 (int)((CW-M)/floorf((CW-M)/(M*14))-M-0.5)


//////////////////////////////////////////
//  //sort(排序) the mediaList by pinYin(首字母) 根据 mediaList类pinYin属性的首字母 进行排序
#define kSortDescriptors    ([NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]])
//以上是OrderButton的背景图片
#define KOrderButtonImage @"topnav_orderbutton.png"
#define KOrderButtonImageSelected @"topnav_orderbutton_selected_unselected.png"

//
//#define kMediaListUrl (@"http://180.153.43.105/Interface/browserNews/listBrowserNewsType.action?LIST_TYPE=group")
//#define kMediaListUrl (@"http://121.43.233.185/news/newsAction/getNewsTypeList.action")

//资讯 目录 URL
#define kMediaListUrl (@"http://121.43.233.185/witbrowserwos/news/getNewsTypeList.do")

//导航 数据 URL
#define KNavigationListUrl (@"http://121.43.233.185/mavenwitbrowser/navweb/retrieve.do")
#define KNavigationListNewUrl (@"http://121.43.233.185/mavenwitbrowser/nav/retrieve.do")
//导航数据版本 是否更新  URL
#define KNavigationVersionUrl (@"http://121.43.233.185/version/nav_catalog.html")

//获取我的信息更改时间接口
#define kMyInfoUpdateTime @"http://121.43.233.185/mavenwitlinkweb/perprivate/checktime.do"

//发送推荐码
#define kInvitationCode @"http://121.43.233.185/mavenwitlinkweb/user/invitation.do"

//空白页面请求地址
#define kBlankWebRequest [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]

#define fileStr  ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define filePathCurrent ([fileStr stringByAppendingString:@"/modelArray0.swh"])
#define filePath1  ([fileStr stringByAppendingString:@"/modelArray1.swh"])
#define filePath2  ([fileStr stringByAppendingString:@"/modelArray2.swh"])
#define filePath3  ([fileStr stringByAppendingString:@"/modelArray3.swh"])
#define filePath4  ([fileStr stringByAppendingString:@"/modelArray4.swh"])
#define NavigationList ([fileStr stringByAppendingString:@"/NavigationList.swh"])
#define NavigationlistJsonArry ([fileStr stringByAppendingString:@"/NavigationlistJsonArry.swh"])
/////////////////////////////////////////
//Database
#define kDatabasePath(name) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:(name)]

//历史和收藏 数据库
#define kHNDatabase @"HNDatabase.sqlite"

//收藏的目录 沙盒地址
//#define kCollectClassName @"CollectClass.data"

#define kCollectClassName [NSString stringWithFormat:@"%@CollectClass.data",KgetUserguid]

//更主题的通知
#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

//字体变化 储存本地 的KEY
#define KFontFontSize [NSString stringWithFormat:@"%@_FontSize",KgetUserguid]

/**
 *  ////////////////////// 分割
 */
#define NSUERDEFAULTS [NSUserDefaults standardUserDefaults]
//获取 userguid
#define KgetUserguid [NSUERDEFAULTS objectForKey:Kuserguid]
//获取 token
#define KgetToken [NSUERDEFAULTS objectForKey:[NSString stringWithFormat:@"%@-token", KgetUserguid]]
//获取 password
#define KgetPassword [NSUERDEFAULTS objectForKey:Kpassword]
//获取 userPhone
#define KgetUserPhone [NSUERDEFAULTS objectForKey:KuserName]
//获取搜索记录
#define KgetSearchHis [NSUERDEFAULTS objectForKey:[NSString stringWithFormat:@"%@-searchHis", KgetUserPhone]]
//单指滑动隐藏标签栏
#define KSystemSettingMark [NSString stringWithFormat:@"KSystemSettingMark%@",KgetUserguid]
#define KbrowserToolbarHidden [[NSUERDEFAULTS objectForKey:KSystemSettingMark] integerValue]

/**登录设置*/
//服务器返回的 guid
#define Kuserguid @"userguid"
//用户名
#define KuserName @"userName"
//密码 key
#define Kpassword @"password"
//token key
#define Ktoken @"token"
//记住用户名 key
#define KrememberUserName @"rememberUserName"
//记住密码 key
#define KrememberPw @"rememberPw"
//自动登录 key
#define KautoLogin @"autoLogin"
//末次登录用户名
#define KlastLoginUserName @"lastLoginUserName"
//末次登录密码
#define KlastLoginPw @"lastLoginPw"
//末次登录设置
#define KlastLoginSetting @"lastLoginSetting"
////是否注销
//#define KisCancle @"isCancle"
//是否曾经登陆
#define KeverLaunched @"everLaunched"
//是否第一次登录
#define KfirstLaunch @"firstLaunch"
//第一次登录时间
#define KfirstLaunchTime @"firstLaunchTime"
//是否后台打开网页
#define KifBackground @"toolForegroundIsOk"

//与用户关联的设置
//末次离开模块按钮被选中
#define KlastSelectedHomeMenuView [NSString stringWithFormat:@"%@%@",KgetUserguid,@"lastSelectedHomeMenuViewBtn"]
//被选中的模块按钮
#define KselectedHomeMenuView [NSString stringWithFormat:@"%@%@",KgetUserguid,@"selectedHomeMenuViewBtn"]
//主体颜色 key
#define KthemeName [NSString stringWithFormat:@"%@%@",KgetUserguid,@"themeName"]
//左右手
#define KchangingHands [NSString stringWithFormat:@"%@%@",KgetUserguid,@"changingHands"]
//全屏标屏
#define KfullScreen [NSString stringWithFormat:@"%@%@",KgetUserguid,@"fullScreen"]
//是否已经在手势上全屏
#define KisFullScreen [NSUERDEFAULTS boolForKey:KfullScreen]
//是否锁屏
#define KlockScreen [NSString stringWithFormat:@"%@%@",KgetUserguid,@"lockScreen"]
#define KlockScreenOrientation [NSString stringWithFormat:@"%@%@",KgetUserguid,@"lockScreenOrientation"]
//系统设置
#define KSystemSetting [NSString stringWithFormat:@"%@KSystemSetting",KgetUserguid]
//夜间\日间模式
#define KnightMode [NSString stringWithFormat:@"%@%@",KgetUserguid,@"nightMode"]
//无图\有图模式
#define KpicModel [NSString stringWithFormat:@"%@%@",KgetUserguid,@"picModel"]
//同步历史 本地储存信息
#define KuploadHistoryLog [NSString stringWithFormat:@"%@%@",KgetUserguid,@"historyUploadLog"]

//是否横屏
#define islandscape ([UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeRight)
//title栏 高度
#define KmainTabbarHeight (KisFullScreen?H:KstatedBarHeight+H)
//手机状态栏 高度
#define KstatedBarHeight (KisFullScreen?(iPhoneX?(islandscape?0:44):0):(iPhoneX?(islandscape?0:44):20))
//iPhoneX的横屏留宽
#define ksetFrameXOnX (iPhoneX?(islandscape?44:0):0)
//iPhoneX的Y坐标
#define ksetFrameYOnX (iPhoneX?(KisFullScreen?(islandscape?0:44):0):0)
//[[UIApplication sharedApplication] statusBarFrame].size.height
//时间格式
#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss.S")
