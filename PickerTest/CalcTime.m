
//
//  CalcTime.m
//  TimerPicker
//
//  Created by Rong on 16/6/27.
//  Copyright © 2016年 Rong. All rights reserved.
//

#import "CalcTime.h"

@implementation CalcTime

/**
 *获取当前日期
 */
+ (NSDictionary *)calculationNowTime {
    
    NSString *format = @"yyyy-MM-dd HH:mm";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSString *time = [dateformatter stringFromDate:[NSDate date]];
    
    NSArray *arry = [time componentsSeparatedByString:@" "];
    NSArray *arry1 = [arry[0] componentsSeparatedByString:@"-"];
    NSArray *arry2 = [arry[1] componentsSeparatedByString:@":"];
    
    return @{@"year":arry1[0], @"month":[NSString stringWithFormat:@"%tu", [arry1[1] integerValue]], @"day":[NSString stringWithFormat:@"%tu", [arry1[2] integerValue]], @"hour":[NSString stringWithFormat:@"%tu",[arry2[0] integerValue]], @"minute":arry2[1]};
    
}
/**
 *获取年
 */
+ (NSArray *)calculationYear {
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    for (int i = 1900; i <= 2100; i++) {
        NSString *str = [NSString stringWithFormat:@"%tu",i];
        [arry addObject:str];
    }
    return arry;
}
/**
 *获取月
 */
+ (NSArray *)calculationMonth {
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
}

/**
 *根据年份和月份获取天数
 */
+ (NSArray *)calculationDay:(NSString *)iyear andMonth:(NSString *)month{
    NSInteger year = [iyear integerValue];
    NSInteger imonth = [month integerValue];
    
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
    {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    }
    
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
    {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
    }
    
    if((year % 4 == 1)||(year % 4 == 2)||(year % 4 == 3))
    {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    }
    
    if(year % 400 == 0 || year )
    {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
    }
    
    if(year % 100 == 0)
    {
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    }
    
    return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
    
}

/**
 *根据时间获取星期几
 */
+ (NSString *)ObtainWeek:(NSString *)day andMonth:(NSString *)month andYear:(NSString *)year{
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    NSInteger dayInter = [day integerValue];
    NSInteger monthInter = [month integerValue];
    NSInteger yearInter = [year integerValue];
    
    [_comps setDay:dayInter];
    [_comps setMonth:monthInter];
    [_comps setYear:yearInter];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    NSString *weak;
    switch (_weekday) {
        case 1:
            weak = @"周日";
            break;
        case 2:
            weak = @"周一";
            break;
        case 3:
            weak = @"周二";
            break;
        case 4:
            weak = @"周三";
            break;
        case 5:
            weak = @"周四";
            break;
        case 6:
            weak = @"周五";
            break;
        case 7:
            weak = @"周六";
            break;
        default:
            break;
    }
    
    return weak;
}
/**
 *获取时
 */
+ (NSArray *)calculationHH {
    return @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
}
/**
 *获取分
 */
+ (NSArray *)calculationMM {
    return @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
}
/**
 *获取天数(判断是否是周末)
 */
+ (NSArray *)calcuDay:(NSString *)iyear andMonth:(NSString *)month {
    
    NSMutableArray *arryD = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arry = [self calculationDay:iyear andMonth:month];
    for (int i = 1; i <= arry.count; i++) {
        
        NSString *week = [self ObtainWeek:arry[i - 1] andMonth:month andYear:iyear];
        NSString *day = [NSString stringWithFormat:@"%tu",i];
        if([week isEqual:@"周六"] || [week isEqual:@"周日"]) {
            [arryD addObject:@{@"day":day,@"isZM":@"1"}];
        }else{
            [arryD addObject:@{@"day":day,@"isZM":@"0"}];
        }
    }
    
    return arryD;
}

/**
 *获取农历日期
 */
+ (NSString *)getChineseCalendarWithDate:(NSString *)dateStr {
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子(鼠)", @"乙丑(牛)", @"丙寅(虎)", @"丁卯(兔)",  @"戊辰(龙)",  @"己巳(蛇)",  @"庚午(马)",  @"辛未(羊)",  @"壬申(猴)",  @"癸酉(鸡)",
                             @"甲戌(狗)",   @"乙亥(猪)",  @"丙子(鼠)",  @"丁丑(牛)", @"戊寅(虎)",   @"己卯(兔)",  @"庚辰(龙)",  @"辛己(蛇)",  @"壬午(马)",  @"癸未(羊)",
                             @"甲申(猴)",   @"乙酉(鸡)",  @"丙戌(狗)",  @"丁亥(猪)",  @"戊子(鼠)",  @"己丑(牛)",  @"庚寅(虎)",  @"辛卯(兔)",  @"壬辰(龙)",  @"癸巳(蛇)",
                             @"甲午(马)",   @"乙未(羊)",  @"丙申(猴)",  @"丁酉(鸡)",  @"戊戌(狗)",  @"己亥(猪)",  @"庚子(鼠)",  @"辛丑(牛)",  @"壬寅(虎)",  @"癸卯(兔)",
                             @"甲辰(龙)",   @"乙巳(蛇)",  @"丙午(马)",  @"丁未(羊)",  @"戊申(猴)",  @"己酉(鸡)",  @"庚戌(狗)",  @"辛亥(猪)",  @"壬子(鼠)",  @"癸丑(牛)",
                             @"甲寅(虎)",   @"乙卯(兔)",  @"丙辰(龙)",  @"丁巳(蛇)",  @"戊午(马)",  @"己未(羊)",  @"庚申(猴)",  @"辛酉(鸡)",  @"壬戌(狗)",  @"癸亥(猪)", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld %ld %ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year - 1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month - 1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day - 1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年 %@%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}
/**
 *获取星座
 */
+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}
/**
 *获取生肖
 */
+ (NSString *)getShengxiao:(NSString *)year {
    
    NSString* one = [year substringWithRange:NSMakeRange(0, 4)];
    int a = [one intValue];
    NSString *shengxiao;
    if (a % 12 == 0) {
        shengxiao = @"猴";
    }
    else if (a % 12 == 1) {
        shengxiao = @"鸡";
    }
    else if (a % 12 == 2) {
        shengxiao = @"狗";
    }
    else if (a % 12 == 3) {
        shengxiao = @"猪";
    }
    else if (a % 12 == 4) {
        shengxiao = @"鼠";
    }
    else if (a % 12 == 5) {
        shengxiao = @"牛";
    }
    else if (a % 12 == 6) {
        shengxiao = @"虎";
    }
    else if (a % 12 == 7) {
        shengxiao = @"兔";
    }
    else if (a % 12 == 8) {
        shengxiao = @"龙";
    }
    else if (a % 12 == 9) {
        shengxiao = @"蛇";
    }
    else if (a % 12 == 10) {
        shengxiao = @"马";
    }
    else if (a % 12 == 11) {
        shengxiao = @"羊";
    }
    return shengxiao;
    
}

@end
