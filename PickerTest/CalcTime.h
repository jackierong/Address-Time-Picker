//
//  CalcTime.h
//  TimerPicker
//
//  Created by Rong on 16/6/27.
//  Copyright © 2016年 Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcTime : NSObject

/**
 *获取当前日期
 */
+ (NSDictionary *)calculationNowTime;

/**
 *获取传入时间
 */
//+ (NSDictionary *)setPassTimeSource:(NSString *)time;

/**
 *获取年
 */
+ (NSArray *)calculationYear;

/**
 *获取月
 */
+ (NSArray *)calculationMonth;

/**
 *根据月份获取天数
 */
+ (NSArray *)calculationDay:(NSString *)iyear andMonth:(NSString *)month;

/**
 *获取天数(判断是否是周末)
 */
+ (NSArray *)calcuDay:(NSString *)iyear andMonth:(NSString *)month;

/**
 *根据时间获取星期几
 */
+ (NSString *)ObtainWeek:(NSString *)day andMonth:(NSString *)month andYear:(NSString *)year;

/**
 *获取时
 */
+ (NSArray *)calculationHH;

/**
 *获取分
 */
+ (NSArray *)calculationMM;

/**
 *获取星座
 */
+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;

/**
 *获取农历日期
 */
+ (NSString *)getChineseCalendarWithDate:(NSString *)dateStr;

/**
 *获取生肖
 */
+ (NSString *)getShengxiao:(NSString *)year;

@end
