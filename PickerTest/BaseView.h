//
//  BaseView.h
//  FrameworkTest
//
//  Created by witmac on 16/4/26.
//  Copyright © 2016年 cvcphp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Divlayout.h"
#import "UIColor+DLExtension.h"
#import "UIFont+DLExtension.h"

#define GWScreenWidth [UIScreen mainScreen].bounds.size.width
#define GWScreenHeight [UIScreen mainScreen].bounds.size.height

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define krect [UIScreen mainScreen].bounds.size


#define Kvmax (MAX(krect.width,krect.height))
#define Kvmin  (MIN(krect.width,krect.height))

#define CW ([UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeRight?Kvmax:Kvmin)
#define CH (CW==Kvmax?Kvmin:Kvmax)

@interface BaseView : UIView

@property (nonatomic) CGFloat SWo, SHo, Mo, Ho ;
@property (nonatomic) CGFloat A11o, A21o, A31o, A32o, A41o, A43o, A51o, A52o, A53o, A54o, A61o, A1T2o;
@property (nonatomic) CGFloat B2Mo, B3Mo, B4Mo,B6Mo, B7Mo, B8Mo, B10Mo, B12Mo, B16Mo, B53o, B34Mo, B36Mo, B64Mo, B21o, B31o, B41o, B51o, B52o, BTNo, B9Mo;
@property (nonatomic) CGFloat C11o, C21o, C31o, C41o, C51o, C52o, C53o, C51T2o, C9MT2o;
@property (nonatomic) CGFloat F1, F2, F3, F4, F5, F6, F7, F8, F9;
@property (nonatomic) NSInteger D21o,D31o,D41o,D51o;

- (UIButton *) BTN:(float)x withY:(float)y withWidth:(CGFloat)width withfontSize:(NSInteger)fontSize withTitle:(NSString *)title withRadius:(CGFloat)radius withTitleColor:(NSString *)color withbackGroundColor:(NSString *)bgColor withimgName:(NSString *)ImgName withAlpha:(CGFloat)alpha;

- (UILabel *) LB:(float)x withY:(float)y withWidth:(CGFloat)width withfontName:(FontName)font withfontSize:(NSInteger)fontSize withText:(NSString *)text withRadius:(CGFloat)radius withTextColor:(NSString *)txcolor withtextAlgnment:(NSTextAlignment)Alignment withbackGroundColor:(NSString *)bgColor;

@end
