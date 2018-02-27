//
//  TimePicker.h
//  TimerPicker
//
//  Created by Rong on 16/6/28.
//  Copyright © 2016年 Rong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWCommon.h"

typedef NS_ENUM(NSInteger, TimeStyle) {
    //滚轮类型枚举
    TimeStyle_DateAndTime = 5,//年月日时分
    TimeStyle_Date = 3,//年月日
    TimeStyle_Time = 2//时分
    
};

@class TimePicker;
@protocol TimePickerDelegate <NSObject>

@optional
/** 开始滚动方法*/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
/** 停止滚动方法*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
/** 计算中间cell并返回值*/
- (void)updateScrollViewContentOffset:(UIScrollView *)scroll;
/** 确定时返回值代理(其中@"constellation"对应的value是星座，@"zodiac"对应的value是生肖，@"calendar"是日期返回)*/
- (void)timePicker:(TimePicker *)picker submitSelectedObject:(NSMutableDictionary *)selectedObject;

@end

@interface TimePicker : UIView<UIScrollViewDelegate> {
    UIView *bgView;
}

/** 判断是否是周末*/
@property (nonatomic, assign) BOOL isZM;

@property (nonatomic, weak) id <TimePickerDelegate> Tdelegate;

@property (nonatomic, copy) NSString *constellationStr, *sxStr;//星座和生肖

@property (nonatomic, strong) NSMutableDictionary *dateDic;/** 存时间的字典*/

@property (nonatomic, strong) id itemType;/** 赋值的输入框*/
@property (nonatomic, assign) BOOL inputChinese;

/** 初始化方法, type表示传入的滚轮类型*/
- (instancetype)initWithParentView:(UIView *)view type:(TimeStyle)type;

- (void)showPicker;/** 显示滚轮视图方法*/

- (void)showPicker:(void(^)(NSDictionary *timeDic))timeBlock withTime:(NSString *)date;/** 显示滚轮并传值*/

- (void)hidePicker;/** 隐藏滚轮视图方法*/

@end
