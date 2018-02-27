//
//  UIView+Divlayout.h
//  WHUSliderViewDemo
//
//  Created by JGW on 16/4/13.
//  Copyright © 2016年 SuperNova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Divlayout)

/*
 *浮动布局  左对齐
 */
- (void) divlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPWP:(CGFloat)PWP;

/*
 *浮动布局，右对齐，传入参数：MH:子对象横向间距；MV：子对象纵向间距；PW：父容器宽度。
 *PWP:除去padding的父容器有效宽度；EW/EH：子对象宽度/高度；EX/EY:子对象坐标；LH:最大行高度。
 */
- (void) divRightlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPWP:(CGFloat)PWP;

/*
 *浮动布局  右上对齐
 */

- (void) divFTRlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPH:(CGFloat)PH withPWP:(CGFloat)PWP;

/*浮动布局，左上对齐，传入参数：MH:子对象横向间距；MV：子对象纵向间距；PH：父容器高度。
 PWP:除去padding的父容器有效宽度；EW/EH：子对象宽度/高度；EX/EY:子对象坐标；LH:最大列宽度。
 */
- (void) divFTLlayout:(CGFloat)MH with:(CGFloat)MV  withPH:(CGFloat)PH withPWP:(CGFloat)PWP;

/*
 *瀑布布局，传入参数：MH:子对象横向间距；MV：子对象纵向间距；PW：父容器宽度；AW最小子对象宽度。
 *PWP:除去padding的父容器有效宽度；EW/EH：子对象宽度/高度；EX/EY:子对象坐标；LH:最大行高度。
 */

//- (void) divFALLlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withAW:(CGFloat)AW withPWP:(CGFloat)PWP;

@end
