//
//  UIView+Divlayout.m
//  WHUSliderViewDemo
//
//  Created by JGW on 16/4/13.
//  Copyright © 2016年 SuperNova. All rights reserved.
//

#import "UIView+Divlayout.h"
#import "BaseView.h"

@implementation UIView (Divlayout)

/*
 *浮动布局  左对齐
 */
- (void) divlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPWP:(CGFloat)PWP {
    BaseView *baseV = [[BaseView alloc] init];
    CGFloat EW = 0,EH = 0,EX = 0,EY=0,LH = 0;
    UIView *tv;
    PWP = PW - PWP;
    EX=PWP+MH;
    for (int i=0;i<self.subviews.count;i++){
        tv = self.subviews[i];
        EW = tv.frame.size.width;
        EH = tv.frame.size.height;
        if( EX+EW>PWP)
        {

            EX = baseV.Mo;
            EY=EY+LH+MV;
            
            LH=EH;
        }else
        {
            LH=MAX(LH,EH);
        }
        
        CGRect theRect;
        theRect.origin.x = EX;
        theRect.origin.y = EY;
        theRect.size.width = EW;
        theRect.size.height = EH;
        [tv setFrame:theRect];
        EX=EX+EW+MH;
        
    }
}

/*
 *浮动布局，右对齐，传入参数：MH:子对象横向间距；MV：子对象纵向间距；PW：父容器宽度。
 *PWP:除去padding的父容器有效宽度；EW/EH：子对象宽度/高度；EX/EY:子对象坐标；LH:最大行高度。
 */
- (void) divRightlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPWP:(CGFloat)PWP{
    
    CGFloat  EW = 0,EH = 0,EX = 0,EY=0,LH = 0;
    UIView *tv;
    
    PWP = PW - PWP;
    EX=PWP+MH;
    
    for (int i=0;i<self.subviews.count;i++){
        tv = self.subviews[i];
        //        GLogOut(@"-%f  ---%f  -- %f   -- %f",tv.frame.origin.x , tv.frame.origin.y,tv.frame.size.width ,tv.frame.size.height);
        EW = tv.frame.size.width;
        EH = tv.frame.size.height;
        if( EX-EW-MH<0)
        {
            EX= PWP-EW;
            EY= EY+LH+MV;
            LH=EH;
        }else
        {
            EX=EX-EW-MH;
            LH=MAX(LH,EH);
        }
        
        CGRect theRect;
        theRect.origin.x = EX;
        if (EY == 0) {
            UIDevice *device = [UIDevice currentDevice];
            if (device.orientation == UIDeviceOrientationFaceUp ||device.orientation == UIDeviceOrientationFaceDown || device.orientation == UIDeviceOrientationPortrait ||device.orientation == UIDeviceOrientationUnknown) {
                EY = EY +20;
            }
        }else if (EY == EY +20){
            EY = EY - 20;
        }
        theRect.origin.y = EY;
        theRect.size.width = EW;
        theRect.size.height = EH;
        [tv setFrame:theRect];
        //        EX=EX+EW+MH;
        //        GLogOut(@"==-%f  ==---%f  -- %f   -- %f",tv.frame.origin.x , tv.frame.origin.y,tv.frame.size.width ,tv.frame.size.height);
        
    }
}

/*
 *浮动布局  右上对齐
 */

- (void) divFTRlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPH:(CGFloat)PH withPWP:(CGFloat)PWP{
    CGFloat PHP=0, EW = 0,EH = 0,EX = 0,EY=0,LH = 0,LX=0;
    UIView *tv;
    
    PHP = PH - PWP;
    LX= PW - PWP;
    
    for (int i=0;i<self.subviews.count;i++){
        tv = self.subviews[i];
        //        GLogOut(@"-%f  ---%f  -- %f   -- %f",tv.frame.origin.x , tv.frame.origin.y,tv.frame.size.width ,tv.frame.size.height);
        EW = tv.frame.size.width;
        EH = tv.frame.size.height;
        if(EY+EH+MV>PHP)
        {
            EY=0;
            LX=LX-LH-MH;
            LH=EW;
        }else
        {
            LH=MAX(LH,EW);
        }
        
        EX=LX-EW;
        
        CGRect theRect;
        theRect.origin.x = EX;
        if (EY == 0) {
            UIDevice *device = [UIDevice currentDevice];
            if (device.orientation == UIDeviceOrientationFaceUp ||device.orientation == UIDeviceOrientationFaceDown || device.orientation == UIDeviceOrientationPortrait ||device.orientation == UIDeviceOrientationUnknown) {
                EY = EY +20;
            }
        }else if (EY == EY +20){
            EY = EY - 20;
        }
        
        theRect.origin.y = EY;
        theRect.size.width = EW;
        theRect.size.height = EH;
        [tv setFrame:theRect];
        EY=EY+EH+MV;
    }
}

/*浮动布局，左上对齐，传入参数：MH:子对象横向间距；MV：子对象纵向间距；PH：父容器高度。
 PWP:除去padding的父容器有效宽度；EW/EH：子对象宽度/高度；EX/EY:子对象坐标；LH:最大列宽度。
 */
- (void) divFTLlayout:(CGFloat)MH with:(CGFloat)MV  withPH:(CGFloat)PH withPWP:(CGFloat)PWP{
    BaseView *baseV = [[BaseView alloc] init];
    
    CGFloat PHP=0, EW = 0,EH = 0,EX = 0,EY=0,LH = 0;
    UIView *tv;
    
    PHP = PH - PWP -20;
    for (int i=0;i<self.subviews.count;i++){
        tv = self.subviews[i];
        //        GLogOut(@"-%f  ---%f  -- %f   -- %f",tv.frame.origin.x , tv.frame.origin.y,tv.frame.size.width ,tv.frame.size.height);
        EW = tv.frame.size.width;
        EH = tv.frame.size.height;
        if(EY+EH+MV>PHP)
        {
            EY=0;
            EX=EX+LH+MH;
            LH=EW;
        }else
        {
            LH=MAX(LH,EW);
        }
        if (EX == 0) {
            EX = baseV.Mo;
        }
        CGRect theRect;
        theRect.origin.x = EX;
        if (EY == 0) {
            UIDevice *device = [UIDevice currentDevice];
            if (device.orientation == UIDeviceOrientationFaceUp ||device.orientation == UIDeviceOrientationFaceDown || device.orientation == UIDeviceOrientationPortrait ||device.orientation == UIDeviceOrientationUnknown) {
                EY = EY +20;
            }
        }else if (EY == EY +20){
            EY = EY - 20;
        }
        theRect.origin.y = EY;
        theRect.size.width = EW;
        theRect.size.height = EH;
        [tv setFrame:theRect];
        EY=EY+EH+MV;
    }
}

@end
