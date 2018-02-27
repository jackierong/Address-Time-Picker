//
//  BaseView.m
//  FrameworkTest
//
//  Created by witmac on 16/4/26.
//  Copyright © 2016年 cvcphp. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()
{
    CGFloat SWo , SHo, SWH;
    CGFloat  Wo;
    
    UIButton *testButton;
    
}

@end

@implementation BaseView


@synthesize SHo, SWo, Mo, Ho;
@synthesize A11o, A21o, A31o, A32o, A41o, A43o, A51o, A52o, A53o, A54o, A61o, A1T2o;
@synthesize B2Mo, B3Mo, B4Mo,B6Mo, B7Mo, B8Mo, B10Mo, B12Mo, B16Mo, B53o, B34Mo, B36Mo, B64Mo, B21o, B31o, B41o, B51o, B52o, BTNo, B9Mo;
@synthesize C11o, C21o, C31o, C41o, C51o, C52o, C53o, C51T2o, C9MT2o;
@synthesize F1, F2, F3, F4, F5, F6, F7, F8, F9;
@synthesize D21o,D31o,D41o,D51o;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SWo = CW;
        SHo = CH;
        [self layoutSubviews];
        /*
         *  开始生成 设备旋转 通知
         */
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        /*
         *  添加 设备旋转 通知
         *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
         *  @return return value description
         */
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(viewhandleDeviceOrientationDidChange:)
//                                                     name:UIApplicationDidChangeStatusBarFrameNotification
//                                                   object:nil
//         ];
    }
    return self;
}

//- (void)viewhandleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
//{
//    NSInteger faceDirection = [UIApplication sharedApplication].statusBarOrientation;
//    if ((faceDirection == UIInterfaceOrientationPortraitUpsideDown)||(faceDirection ==UIInterfaceOrientationPortrait)||(faceDirection==UIInterfaceOrientationLandscapeLeft)|| (faceDirection ==UIInterfaceOrientationLandscapeRight)) {
//        [self layoutSubviews];
//    }
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    SWo = CW;
    SHo = CH;
    
    NSInteger faceDirection = [UIApplication sharedApplication].statusBarOrientation;
    if (faceDirection == UIDeviceOrientationPortrait || faceDirection == UIDeviceOrientationPortraitUpsideDown) {
        SWo = CW;
        SHo = CH;
    }else{
        SWo = CW;
        SHo = CH;
    }
    
    //    GLogOut( @"屏幕宽高 === %f ====%f ",SW ,SH);
    
    //屏幕宽高比
    SWH = SWo/SHo;
    
    CGFloat Smax = MAX(SWo, SHo);
    //    CGFloat Smin = MIN(SW, SH);
    
    //根据屏幕尺寸得出M0
    CGFloat M0= Smax/64;  //Smin/DPR>800?Smax/144:(Smin/DPR>400?Smax/64:Smin/36);
    Mo=M0*1;
    Mo = floor(Mo);
    Wo = Mo * 6;
    Ho = Mo*4;
    
    //计算D系列控件宽度
    D51o=[self decimalwithFormat:@"0" floatV:((SWo-Mo)/[self decimalwithFormat:@"0" floatV:((SWo-Mo)/(Mo*7))]-Mo)];
    D41o=[self decimalwithFormat:@"0" floatV:((SWo-Mo)/[self decimalwithFormat:@"0" floatV:((SWo-Mo)/(Mo*8))]-Mo)];;
    D31o=[self decimalwithFormat:@"0" floatV:((SWo-Mo)/[self decimalwithFormat:@"0" floatV:((SWo-Mo)/(Mo*10))]-Mo)];;
    D21o=[self decimalwithFormat:@"0" floatV:((SWo-Mo)/[self decimalwithFormat:@"0" floatV:((SWo-Mo)/(Mo*14))]-Mo)];;
    
    
    //计算字体大小
    F1 = Mo*1;
    F2 = Mo*1.2;
    F3 = Mo*1.4;
    F4 = Mo*1.6;
    F5 = Mo*1.8;
    F6 = Mo*2;
    F7 = Mo*2.4;
    F8 = Mo*3;
    F9 = Mo*4;
    
    // 正比宽度...................................................................................................
    A11o = (CGFloat) SWo - Mo * 2;
    //    GLogOut(@"SW=%f  SH=%f M=%f  A11=%f ",SW,SH,M,A11);
    A21o = (CGFloat) (SWo * 0.5 - Mo * 1.5);
    A31o = (CGFloat) (SWo * 0.333 - Mo * 1.33);
    A32o = (CGFloat) (SWo * 0.666 - Mo * 1.66);
    A41o = (CGFloat) (SWo * 0.25 - Mo * 1.25);
    A43o = (CGFloat) (SWo * 0.75 - Mo * 1.75);
    A51o = floor((CGFloat) (SWo * 0.2 - Mo * 1.2));
    A52o = (CGFloat) (SWo * 0.4 - Mo * 1.4);
    A53o = (CGFloat) (SWo * 0.6 - Mo * 1.6);
    A54o = (CGFloat) (SWo * 0.8 - Mo * 1.8);
    A61o = (CGFloat) (SWo * 0.166 - Mo * 1.22);
    A1T2o = (CGFloat) (SWo < SHo ? (SWo - Mo * 2) : (SWo * 0.5 - ceil(Mo * 1.5)));
    
    // 固定大小...................................................................................................
    B2Mo = (CGFloat) Mo * 2;
    B3Mo = (CGFloat) Mo * 3;
    B4Mo = (CGFloat) Mo * 4;
    B6Mo = (CGFloat) Mo * 6;
    B7Mo = (CGFloat) Mo * 7;
    B8Mo = (CGFloat) Mo * 8;
    B9Mo = (CGFloat) Mo * 9;
    B10Mo = (CGFloat) Mo * 10;
    B12Mo = (CGFloat) Mo * 12;
    B16Mo = (CGFloat) Mo * 16;
    B34Mo = (CGFloat) Mo * 34;
    B36Mo = (CGFloat) Mo * 36;
    B64Mo = (CGFloat) Mo * 64;
    B21o = (CGFloat) (Mo * 33 / 2);
    B31o = (CGFloat) (Mo * 32 / 3);
    B41o = (CGFloat) (Mo * 31 / 4);
    B51o = (CGFloat) Mo * 6;
    B52o = (CGFloat) Mo * 13;
    B53o = (CGFloat) Mo * 20;
    BTNo = B51o;
    
    // 补余大小按键，有间距...................................................................................................
    C11o = (float) (SWo < SHo ? Mo * 36 : (SWo - Mo * 36));
    C21o = (float) (SWo - Mo * 39 / 2);
    C41o = (float) (SWo - Mo * 43 / 4);
    C51o = floor((float) (SWo - Mo * 9));
    C52o = (float) (SWo - Mo * 16);
    C53o = (float) (SWo - Mo * 23);
    C51T2o = (float) (SWo < SHo ? (SWo - Mo * 9) : (SWo * 0.5 - Mo * 8.5));
    C9MT2o = (int) (SWo < SHo ? (SWo - B9Mo ): (SWo * 0.5 - Mo * 8.5));
    
}

- (NSMutableArray *)FXY:(NSInteger) xt withyt:(NSInteger)yt withX0:(CGFloat)X0 withY0:(CGFloat)Y0 withW0:(CGFloat)W0 withH0:(CGFloat)H0 withW1:(CGFloat)W1 withH1:(CGFloat)H1 witha:(CGFloat)a withb:(CGFloat)b{
    
    NSInteger X1, Y1;
    
    X0 =  ceil(X0); //[self decimalwithFormat:@"0" floatV:X0];
    Y0 =  ceil(Y0); //[self decimalwithFormat:@"0" floatV:Y0];
    a =   ceil(a); //[self decimalwithFormat:@"0" floatV:a];
    b =   ceil(b);  //[self decimalwithFormat:@"0" floatV:b];
    
    X1=X0+ceil(0.5*((xt%6)*W0-(xt%4)*W1))+a; //[self decimalwithFormat:@"0" floatV:(0.5*((xt%6)*W0-(xt%4)*W1))]
    
    Y1=Y0+ceil(0.5*((yt%6)*H0-(yt%4)*H1))+b;  //[self decimalwithFormat:@"0" floatV:(0.5*((yt%6)*H0-(yt%4)*H1))]
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSNumber *obj0,*obj1;
    
    obj0 = [NSNumber numberWithInteger:X1];
    obj1 = [NSNumber numberWithInteger:Y1];

    [array addObject:obj0];
    [array addObject:obj1];
    
    return array;
}

- (UILabel *) LB:(float)x withY:(float)y withWidth:(CGFloat)width withfontName:(FontName)font withfontSize:(NSInteger)fontSize withText:(NSString *)text withRadius:(CGFloat)radius withTextColor:(NSString *)txcolor withtextAlgnment:(NSTextAlignment)Alignment withbackGroundColor:(NSString *)bgColor{
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, Ho)];
    [lb setTextColor:[UIColor colorWithHexString:txcolor]];
    [lb setFont:[UIFont fontForFontName:font size:fontSize]];
    [lb.layer setMasksToBounds:YES];
    [lb.layer setCornerRadius:radius];
    [lb setTextAlignment:Alignment];
    [lb setLineBreakMode:NSLineBreakByWordWrapping];
    [lb setNumberOfLines:0];
    if (bgColor.length == 0) {
        [lb setBackgroundColor:[UIColor clearColor]];
    }else{
        [lb setBackgroundColor:[UIColor colorWithHexString:bgColor]];
    }
    [lb setText:text];
    return lb;
}

- (UIButton *) BTN:(float)x withY:(float)y withWidth:(CGFloat)width withfontSize:(NSInteger)fontSize withTitle:(NSString *)title withRadius:(CGFloat)radius withTitleColor:(NSString *)color withbackGroundColor:(NSString *)bgColor withimgName:(NSString *)ImgName withAlpha:(CGFloat)alpha{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, Ho)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:radius];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    if (bgColor.length == 0) {
        [btn setBackgroundColor:[UIColor clearColor]];
    }else{
        [btn setBackgroundColor:[UIColor colorWithHexString:bgColor]];
    }
    [btn setImage:[UIImage imageNamed:ImgName] forState:UIControlStateNormal];
    [btn setAlpha:alpha];
    return btn;
}

- (NSInteger) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [[numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]] integerValue];
}

@end
