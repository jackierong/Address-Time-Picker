//
//  TimePicker.m
//  TimerPicker
//
//  Created by Rong on 16/6/28.
//  Copyright © 2016年 Rong. All rights reserved.
//

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "TimePicker.h"
#import "CalcTime.h"

@interface TimePicker () {
}
@property (nonatomic, strong) NSArray *yearArry, *monthArry, *dayArry, *hourArry, *minuteArry;//储存日期的数组
@property (nonatomic, strong) UILabel *maskLB, *dateDetailLB;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, strong) UIScrollView *dayPickerSC, *hourSC, *minuteSC;//滚轮对象
@property (nonatomic, strong) UIButton *subBTN, *changeBTN;
@property (nonatomic, assign) int cellWidth, cellHeight;
@property (nonatomic, strong) NSDictionary *currentDay;//当前日期
@property (nonatomic, assign) TimeStyle style;//滚轮类型
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, copy) void(^ timeBlock)(NSDictionary *);//确认所选日期回调block

@end

@implementation TimePicker

- (instancetype)initWithParentView:(UIView *)view type:(TimeStyle)type {
    
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
        _cellHeight = M * 4;//滚轮内部按钮高度
        _style = type;
        bgView = [[UIView alloc] initWithFrame:CGRectMake(ksetFrameXOnX, ksetFrameYOnX, CW, CH)];//背景阴影图
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];//添加点击隐藏滚轮手势
        [bgView addGestureRecognizer:tap];
        [view addSubview:bgView];
        [bgView setHidden:YES];
        [view addSubview:self];
        [self setFrame:CGRectMake(ksetFrameXOnX, CH - M * 35, CW, M * 35)];
        [self setBackgroundColor:HexRGB(0x115566)];
        [self setupPicker];
        [self setNotifaction];
    }
    return self;
}
/** 监听屏幕是否旋转*/
- (void) setNotifaction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewOrientationDidChanged) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)cancelPicker:(UITapGestureRecognizer *)sender {
    
    [bgView setHidden:YES];
    [self setHidden:YES];
}
#pragma mark -
- (void)setupPicker {
    _currentDay = [NSDictionary dictionary];
    self.dateDic = [[NSMutableDictionary alloc] init];
    //阴阳历转换按钮
    _changeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeBTN setFrame:[self FXY:0 xt:0 yt:0 W1:A51 H1:_cellHeight a:M b:M]];
    [_changeBTN setBackgroundColor:HNColor(248, 168, 107)];
    [_changeBTN addTarget:self action:@selector(changeToChineseCal:) forControlEvents:UIControlEventTouchUpInside];
    [_changeBTN setTag:211];
    [_changeBTN.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
    [_changeBTN setTitle:@"阳历" forState:UIControlStateNormal];
    [self addSubview:_changeBTN];
    if ([_typeStr isEqualToString:@"2"]) {
        [_changeBTN setUserInteractionEnabled:NO];
    }
    //日期显示框
    _dateDetailLB = [[UILabel alloc] initWithFrame:[self FXY:_changeBTN xt:8 yt:0 W1:A53 H1:_cellHeight a:M b:0]];
    [_dateDetailLB setBackgroundColor:HexRGB(0xEDEDED)];
    [_dateDetailLB setNumberOfLines:0];
    [_dateDetailLB setFont:[UIFont systemFontOfSize:kfontSize]];
    [_dateDetailLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_dateDetailLB];
    //确认按钮
    _subBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBTN setFrame:[self FXY:_dateDetailLB xt:8 yt:0 W1:A51 H1:_cellHeight a:M b:0]];
    [_subBTN setBackgroundColor:HNColor(249, 80, 89)];
    [_subBTN.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
    [_subBTN setTitle:@"确认" forState:UIControlStateNormal];
    [_subBTN addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subBTN];
    
    _yearArry = [CalcTime calculationYear];
    _monthArry = [CalcTime calculationMonth];
    _currentDay = [CalcTime calculationNowTime];
    NSLog(@"当前时间：%@", _currentDay);
    _dayArry = [CalcTime calcuDay:[_currentDay objectForKey:@"year"] andMonth:[_currentDay objectForKey:@"month"]];
    _hourArry = [CalcTime calculationHH];
    _minuteArry = [CalcTime calculationMM];
    
    _style == 5 ? [self setupYMDHM] : (_style == 3 ? [self setupYMD] : [self setupHM]);
    /** 中间遮罩层*/
    _maskLB = [[UILabel alloc] initWithFrame:CGRectMake(0, M * 18, CW, _cellHeight)];
    _maskLB.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:0.7];
    [_maskLB setUserInteractionEnabled:NO];
    [self addSubview:_maskLB];
    [self setHidden:YES];
}
#pragma mark - 设置年月日滚轮
- (void)setupYMD {
    _cellWidth = CW / 3;
    NSArray *contentArry = [NSArray array];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIScrollView *pickerSC = [[UIScrollView alloc] initWithFrame:CGRectMake(_cellWidth * i, M * 6, _cellWidth, _cellHeight * 7)];
        [pickerSC setTag:200 + i];
        [pickerSC setShowsVerticalScrollIndicator:NO];
        [pickerSC setShowsHorizontalScrollIndicator:NO];
        [pickerSC setDelegate:self];
        [self addSubview:pickerSC];
        contentArry = pickerSC.tag == 200 ? _yearArry : (pickerSC.tag == 201 ? _monthArry : _dayArry);//分别设置年，月，日的数组
        [pickerSC setBackgroundColor:pickerSC.tag == 200 ? HNColor(136, 136, 136) : (pickerSC.tag == 201 ? HNColor(102, 102, 102) : HNColor(68, 68, 68))];
        [pickerSC setContentSize:CGSizeMake(_cellWidth, (contentArry.count + 6) * _cellHeight)];
        for (NSInteger j = 0; j < (contentArry.count + 6); j++) {
            
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [contentBtn.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
            [contentBtn setFrame:CGRectMake(0, _cellHeight * j, _cellWidth, _cellHeight)];
            [contentBtn addTarget:self action:@selector(clickToMoveMid:) forControlEvents:UIControlEventTouchUpInside];
            if (j < 3 || j > (contentArry.count + 2)) {//滚轮前三个和最后三个日期为空，以便第一个日期和最后一个日期能在滚轮最中间显示
                [contentBtn setTitle:@"" forState:UIControlStateNormal];
                [contentBtn setUserInteractionEnabled:NO];
            } else {
                if (pickerSC.tag == 202) {
                    NSDictionary *dayDic = contentArry[j - 3];
                    [contentBtn setTitle:dayDic[@"day"] forState:UIControlStateNormal];
                    if ([dayDic[@"isZM"] isEqual:@"1"]) {//判断是否为周末
                        [contentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    } else {
                        [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                } else {
                    [contentBtn setTitle:contentArry[j - 3] forState:UIControlStateNormal];
                }
            }
            [pickerSC addSubview:contentBtn];
        }
    }
}
/** 设置年月日时分滚轮*/
- (void)setupYMDHM {
    _cellWidth = CW / 5;
    NSArray *contentArry = [NSArray array];
    for (NSInteger i = 0; i < 5; i++) {
        
        UIScrollView *pickerSC = [[UIScrollView alloc] initWithFrame:CGRectMake(_cellWidth * i, M * 6, _cellWidth, _cellHeight * 7)];
        [pickerSC setTag:200 + i];
        [pickerSC setShowsVerticalScrollIndicator:NO];
        [pickerSC setShowsHorizontalScrollIndicator:NO];
        [pickerSC setDelegate:self];
        [self addSubview:pickerSC];
        contentArry = pickerSC.tag == 200 ? _yearArry : (pickerSC.tag == 201 ? _monthArry : (pickerSC.tag == 202 ? _dayArry : (pickerSC.tag == 203 ? _hourArry : _minuteArry)));//分别设置年，月，日，时，分的数组
        [pickerSC setBackgroundColor:pickerSC.tag == 200 ? HexRGB(0x888888) : (pickerSC.tag == 201 ? HexRGB(0x666666) : (pickerSC.tag == 202 ? HexRGB(0x444444) : (pickerSC.tag == 203 ? HexRGB(0x333333) : HexRGB(0x222222))))];
        [pickerSC setContentSize:CGSizeMake(_cellWidth, (contentArry.count + 6) * _cellHeight)];
        for (NSInteger j = 0; j < (contentArry.count + 6); j++) {
            
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [contentBtn.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
            [contentBtn setFrame:CGRectMake(0, _cellHeight * j, _cellWidth, _cellHeight)];
            [contentBtn addTarget:self action:@selector(clickToMoveMid:) forControlEvents:UIControlEventTouchUpInside];
            if (j < 3 || j > (contentArry.count + 2)) {//滚轮前三个和最后三个日期为空，以便第一个日期和最后一个日期能在滚轮最中间显示
                [contentBtn setTitle:@"" forState:UIControlStateNormal];
                [contentBtn setUserInteractionEnabled:NO];
            } else {
                if (pickerSC.tag == 202) {
                    NSDictionary *dayDic = contentArry[j - 3];
                    [contentBtn setTitle:dayDic[@"day"] forState:UIControlStateNormal];
                    if ([dayDic[@"isZM"] isEqual:@"1"]) {//判断是否为周末
                        [contentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    } else {
                        [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                } else {
                    [contentBtn setTitle:contentArry[j - 3] forState:UIControlStateNormal];
                }
            }
            [pickerSC addSubview:contentBtn];
        }
    }
}
#pragma mark - 设置时分滚轮
- (void)setupHM {
    _cellWidth = CW / 2;
    NSArray *contentArry = [NSArray array];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIScrollView *pickerSC = [[UIScrollView alloc] initWithFrame:CGRectMake(_cellWidth * i, M * 6, _cellWidth, _cellHeight * 7)];
        [pickerSC setTag:203 + i];
        [pickerSC setShowsVerticalScrollIndicator:NO];
        [pickerSC setShowsHorizontalScrollIndicator:NO];
        [pickerSC setDelegate:self];
        [self addSubview:pickerSC];
        contentArry = pickerSC.tag == 203 ? _hourArry : _minuteArry;//分别设置时，分的数组
        [pickerSC setBackgroundColor:pickerSC.tag == 203 ? HexRGB(0x888888) : HexRGB(0x666666)];
        [pickerSC setContentSize:CGSizeMake(_cellWidth, (contentArry.count + 6) * _cellHeight)];
        for (NSInteger j = 0; j < (contentArry.count + 6); j++) {
            
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [contentBtn setFrame:CGRectMake(0, _cellHeight * j, _cellWidth, _cellHeight)];
            [contentBtn addTarget:self action:@selector(clickToMoveMid:) forControlEvents:UIControlEventTouchUpInside];
            if (j < 3 || j > (contentArry.count + 2)) {
                [contentBtn setTitle:@"" forState:UIControlStateNormal];
                [contentBtn setUserInteractionEnabled:NO];
            } else {
                [contentBtn setTitle:contentArry[j - 3] forState:UIControlStateNormal];
            }
            [pickerSC addSubview:contentBtn];
        }
    }
}
- (void)saveMonth:(UIButton *)btn {//chucun
    NSString *month = btn.titleLabel.text;
    if ([month length] < 2) {
        month = [NSString stringWithFormat:@"0%@", btn.titleLabel.text];
    }
    [self.dateDic setObject:month forKey:@"month"];
}
- (void)saveDay:(UIButton *)btn {
    NSString *month = btn.titleLabel.text;
    if ([month length] < 2) {
        month = [NSString stringWithFormat:@"0%@", btn.titleLabel.text];
    }
    [self.dateDic setObject:month forKey:@"day"];
}
#pragma mark - 点击滚轮每个cell时的触发方法
- (void)clickToMoveMid:(UIButton *)sender {
    
    _cellWidth = _style == 5 ? CW / 5 : (_style == 3 ? CW / 3 : CW / 2);//根据滚轮类型计算每个滚轮宽度
    UIScrollView *sv = (UIScrollView *)[sender superview];
    [sv setContentOffset:CGPointMake(sv.contentOffset.x, sender.frame.origin.y - floor(M * 12))];
    if (sender.titleLabel.text.length > 0) {
        sv.tag == 200 ? [self.dateDic setObject:sender.titleLabel.text forKey:@"year"] : (sv.tag == 201 ? [self saveMonth:sender] : (sv.tag == 202 ? [self saveDay:sender] : (sv.tag == 203 ? [self.dateDic setObject:sender.titleLabel.text forKey:@"hour"] : [self.dateDic setObject:sender.titleLabel.text forKey:@"minute"])));
    }
    if (sv.tag == 200 || sv.tag == 201) {
        
        UIScrollView *dayPicker = (UIScrollView *)[self viewWithTag:202];
        [dayPicker removeFromSuperview];
        //根据年和月的变化重新生成日滚轮
        NSArray *dayArry = [CalcTime calcuDay:_dateDic[@"year"] andMonth:_dateDic[@"month"]];
        UIScrollView *pickerSC = [[UIScrollView alloc] initWithFrame:CGRectMake(_cellWidth * 2, M * 6, _cellWidth, _cellHeight * 7)];
        [pickerSC setTag:202];
        [pickerSC setBackgroundColor:HNColor(68, 68, 68)];
        [pickerSC setDelegate:self];
        [pickerSC setShowsVerticalScrollIndicator:NO];
        [pickerSC setShowsHorizontalScrollIndicator:NO];
        [pickerSC setContentSize:CGSizeMake(_cellWidth, (dayArry.count + 6) * _cellHeight)];
        [self addSubview:pickerSC];
        for (NSInteger i = 0; i < (dayArry.count + 6); i++) {
            UIButton *dayBTN = [UIButton buttonWithType:UIButtonTypeCustom];
            [dayBTN.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
            [dayBTN setFrame:CGRectMake(0, _cellHeight * i, _cellWidth, _cellHeight)];
            [dayBTN addTarget:self action:@selector(clickToMoveMid:) forControlEvents:UIControlEventTouchUpInside];
            if (i < 3 || i > (dayArry.count + 2)) {
                [dayBTN setTitle:@"" forState:UIControlStateNormal];
                [dayBTN setUserInteractionEnabled:NO];
            } else {
                NSDictionary *dayDic = dayArry[i - 3];
                [dayBTN setTitle:dayDic[@"day"] forState:UIControlStateNormal];
                if ([dayDic[@"isZM"] isEqual:@"1"]) {
                    [dayBTN setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                } else {
                    [dayBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            [pickerSC addSubview:dayBTN];
        }
        NSMutableArray *judgeArry = [NSMutableArray array];
        for (NSDictionary *dic in dayArry) {
            [judgeArry addObject:dic[@"day"]];
        }
        NSString *dayStr = _dateDic[@"day"];
        if ([[dayStr substringToIndex:1] isEqualToString:@"0"]) {
            dayStr = [_dateDic[@"day"] substringFromIndex:1];
        }
        if ([judgeArry indexOfObject:dayStr] != NSNotFound) {
            for (UIButton *dayBtn in [pickerSC subviews]) {
                if ([dayBtn.titleLabel.text isEqualToString:dayStr]) {
                    [dayBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        } else {
            UIButton *btn = (UIButton *)[pickerSC subviews][[pickerSC subviews].count - 4];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    /** 把遮罩层显示在最上层*/
    [self bringSubviewToFront:_maskLB];
    if ([_changeBTN.titleLabel.text isEqualToString:@"农历"]) {
        [_dateDetailLB setText:[NSString stringWithFormat:@"%@", [CalcTime getChineseCalendarWithDate:[NSString stringWithFormat:@"%@-%@-%@", _dateDic[@"year"], _dateDic[@"month"], _dateDic[@"day"]]]]];
    } else {
        _style == 5 ? [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]] : (_style == 3 ? [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]]] : [_dateDetailLB setText:[NSString stringWithFormat:@"%@:%@", [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]]);
    }
}
/** 屏幕旋转frame变化的方法*/
- (void)viewOrientationDidChanged {
    NSInteger ct;
    _cellWidth = _style == 5 ? CW / 5 : (_style == 3 ? CW / 3 : CW / 2);
    ct = _style == 5 ? 5 : (_style == 3 ? 3 : 2);
    [bgView setFrame:CGRectMake(ksetFrameXOnX, ksetFrameYOnX, CW, CH)];
    CGRect btnRect = CGRectMake(0, 0, floor((CGFloat)(CW * 0.2 - M * 1.2)), _cellHeight);
    [_changeBTN setFrame:btnRect];
    [_subBTN setFrame:btnRect];
    
    CGRect lbRect = CGRectMake(0, 0, (CGFloat)(CW * 0.6 - M * 1.6), _cellHeight);
    [_dateDetailLB setFrame:lbRect];
    [self divlayout:M with:M withPW:CW withPWP:0];
    
    for (NSInteger i = 0; i < ct; i++) {
        CGRect SCRect = CGRectMake(_cellWidth * i, M * 6, _cellWidth, _cellHeight * 7);
        if ([_typeStr isEqualToString:@"2"]) {
            [(UIScrollView *)[self viewWithTag:203 + i] setFrame:SCRect];
            for (NSInteger j = 0; j < [(UIScrollView *)[self viewWithTag:203 + i] subviews].count; j++) {
                UIButton *btn = (UIButton *)[(UIScrollView *)[self viewWithTag:203 + i] subviews][j];
                [btn setFrame:CGRectMake(0, _cellHeight * j, _cellWidth, _cellHeight)];
            }
        } else {
            [(UIScrollView *)[self viewWithTag:200 + i] setFrame:SCRect];
            UIScrollView *sc = (UIScrollView *)[self viewWithTag:200 + i];
            for (NSInteger j = 0; j < [(UIScrollView *)[self viewWithTag:200 + i] subviews].count; j++) {
                UIButton *btn = (UIButton *)[(UIScrollView *)[self viewWithTag:200 + i] subviews][j];
                [btn setFrame:CGRectMake(0, _cellHeight * j, _cellWidth, _cellHeight)];
                if ((sc.tag == 200 && [btn.titleLabel.text isEqualToString:self.dateDic[@"year"]]) || (sc.tag == 201 && [btn.titleLabel.text isEqualToString:self.dateDic[@"month"]]) || (sc.tag == 202 && [btn.titleLabel.text isEqualToString:self.dateDic[@"day"]])) {
                    sc.contentOffset = CGPointMake(sc.contentOffset.x, btn.frame.origin.y - floor(M * 12));
                }
            }
        }
    }
    [_maskLB setFrame:CGRectMake(0, M * 18, CW, _cellHeight)];
    [self setFrame:CGRectMake(ksetFrameXOnX, CH - M * 35, CW, M * 35)];
}
/** 农历阳历转换*/
- (void)changeToChineseCal:(UIButton *)sender {

    if (_style == 2) return;
    if ([sender.titleLabel.text isEqualToString:@"阳历"]) {
        [sender setTitle:@"农历" forState:UIControlStateNormal];
        [_dateDetailLB setText:[NSString stringWithFormat:@"%@", [CalcTime getChineseCalendarWithDate:[NSString stringWithFormat:@"%@-%@-%@", _dateDic[@"year"], _dateDic[@"month"], _dateDic[@"day"]]]]];
    } else {
        _style == 5 ? [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]] : [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]]];
        [sender setTitle:@"阳历" forState:UIControlStateNormal];
    }
}
/** 显示滚轮*/
- (void)showPicker {
    _currentDay = [CalcTime calculationNowTime];
    NSString *currentStr;
    if ([_itemType isKindOfClass:[UITextField class]]) {
        currentStr = [_itemType text];
    } else if ([_itemType isKindOfClass:[UIButton class]]) {
        currentStr = [_itemType titleLabel].text;
    }
    switch (_style) {
        case 5:{//年月日时分
            NSArray *arr = [NSArray array];
            if ([currentStr containsString:@"-"]) {
                NSArray *arr1 = [NSArray array];
                NSArray *arr2 = [NSArray array];
                if ([currentStr containsString:@" "]) {
                    arr1 = [currentStr componentsSeparatedByString:@" "];
                    arr = [arr1[0] componentsSeparatedByString:@"-"];
                    arr2 = [arr1[1] componentsSeparatedByString:@":"];
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:200] subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:201] subviews]) {
                    NSString *month = btn.titleLabel.text;
                    if (month.length < 2) {
                        month = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([month isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:202] subviews]) {
                    NSString *day = btn.titleLabel.text;
                    if (day.length < 2) {
                        day = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([day isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:203] subviews]) {
                    NSString *hour = btn.titleLabel.text;
                    if (hour.length < 2) {
                        hour = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([hour isEqualToString:arr2[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:204] subviews]) {
                    NSString *minute = btn.titleLabel.text;
                    if (minute.length < 2) {
                        minute = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([minute isEqualToString:arr2[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                [self getTimeWithScroll:200];
                [self getTimeWithScroll:201];
                [self getTimeWithScroll:202];
                [self getTimeWithScroll:203];
                [self getTimeWithScroll:204];
            }
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]];
        }
            break;
        case 3:{//年月日
            NSArray *arr = [NSArray array];
            if ([currentStr containsString:@"-"]) {
                NSArray *arr1 = [NSArray array];
                if ([currentStr containsString:@" "]) {
                    arr1 = [currentStr componentsSeparatedByString:@" "];
                    arr = [arr1[0] componentsSeparatedByString:@"-"];
                } else {
                    arr = [currentStr componentsSeparatedByString:@"-"];
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:200] subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:201] subviews]) {
                    NSString *month = btn.titleLabel.text;
                    if (month.length < 2) {
                        month = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([month isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:202] subviews]) {
                    NSString *day = btn.titleLabel.text;
                    if (day.length < 2) {
                        day = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([day isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                [self getTimeWithScroll:200];
                [self getTimeWithScroll:201];
                [self getTimeWithScroll:202];
            }
            UIButton *judgeBtn = (UIButton *)[self viewWithTag:211];
            [judgeBtn setTitle:@"阳历" forState:UIControlStateNormal];
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]]];
            
        }
            break;
        case 2://时分
            [self getTimeWithScroll:203];
            [self getTimeWithScroll:204];
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@:%@",[self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]];
            break;
            
        default:
            break;
    }
    [self setHidden:NO];
    [bgView setHidden:NO];
}
- (void)getTimeWithScroll:(NSInteger)scrollTag {
    for (UIButton *clickB in [(UIScrollView *)[self viewWithTag:scrollTag] subviews]) {
        if ((scrollTag == 200&&[clickB.titleLabel.text isEqualToString:[_currentDay objectForKey:@"year"]])||(scrollTag == 201&&[clickB.titleLabel.text isEqualToString:[_currentDay objectForKey:@"month"]])||(scrollTag == 202&&[clickB.titleLabel.text isEqualToString:[_currentDay objectForKey:@"day"]])||(scrollTag == 203&&[clickB.titleLabel.text isEqualToString:[_currentDay objectForKey:@"hour"]])||(scrollTag == 204&&[clickB.titleLabel.text isEqualToString:[_currentDay objectForKey:@"minute"]])) {
            [clickB sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}
#pragma mark - 显示滚轮
- (void)showPicker:(void(^)(NSDictionary *timeDic))timeBlock withTime:(NSString *)date {
    _currentDay = [CalcTime calculationNowTime];
    switch (_style) {
        case 5:{//年月日时分
            NSArray *arr = [NSArray array];
            if ([date containsString:@"-"]) {
                NSArray *arr1 = [NSArray array];
                NSArray *arr2 = [NSArray array];
                if ([date containsString:@" "]) {
                    arr1 = [date componentsSeparatedByString:@" "];
                    arr = [arr1[0] componentsSeparatedByString:@"-"];
                    arr2 = [arr1[1] componentsSeparatedByString:@":"];
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:200] subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:201] subviews]) {
                    NSString *month = btn.titleLabel.text;
                    if (month.length < 2) {
                        month = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([month isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:202] subviews]) {
                    NSString *day = btn.titleLabel.text;
                    if (day.length < 2) {
                        day = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([day isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:203] subviews]) {
                    NSString *hour = btn.titleLabel.text;
                    if (hour.length < 2) {
                        hour = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([hour isEqualToString:arr2[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:204] subviews]) {
                    NSString *minute = btn.titleLabel.text;
                    if (minute.length < 2) {
                        minute = [NSString stringWithFormat:@"0%@",btn.titleLabel.text];
                    }
                    if ([minute isEqualToString:arr2[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                [self getTimeWithScroll:200];
                [self getTimeWithScroll:201];
                [self getTimeWithScroll:202];
                [self getTimeWithScroll:203];
                [self getTimeWithScroll:204];
            }
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]];
        }
            break;
        case 3:{//年月日
            NSArray *arr = [NSArray array];
            NSArray *arr1 = [NSArray array];
            if ([date containsString:@"-"]) {
                arr1 = [date componentsSeparatedByString:@" "];
                arr = [arr1[0] componentsSeparatedByString:@"-"];
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:200] subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                NSString *monStr = arr[1];
                NSString *mStr;
                if (monStr.length > 1 && [[monStr substringToIndex:1] isEqualToString:@"0"]) {
                    mStr = [monStr substringFromIndex:1];
                } else {
                    mStr = arr[1];
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:201] subviews]) {
                    NSString *month = btn.titleLabel.text;
                    if ([month isEqualToString:mStr]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [(UIScrollView *)[self viewWithTag:202] subviews]) {
                    NSString *day = btn.titleLabel.text;
                    if ([day isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                [self getTimeWithScroll:200];
                [self getTimeWithScroll:201];
                [self getTimeWithScroll:202];
            }
            UIButton *judgeBtn = (UIButton *)[self viewWithTag:211];
            [judgeBtn setTitle:@"阳历" forState:UIControlStateNormal];
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]]];
        }
            break;
        case 2://时分
            [self getTimeWithScroll:203];
            [self getTimeWithScroll:204];
            [_dateDetailLB setText:[NSString stringWithFormat:@"%@:%@",[self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]];
            break;
        default:
            break;
    }
    [self setHidden:NO];
    [bgView setHidden:NO];
    _timeBlock = timeBlock;
}
#pragma mark - 确定按钮点击事件
- (void)submit {
    if ([_itemType isKindOfClass:[UITextField class]]) {
        [self setHidden:YES];
        [bgView setHidden:YES];
        if (_style == 2) {
            [_itemType setText:_dateDetailLB.text];
        } else if (_style == 3) {
            [_itemType setText:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]]];
        } else {
            [_itemType setText:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]]];
        }
        [_itemType endEditing:YES];
    }
    if ([_itemType isKindOfClass:[UIButton class]]) {
        [self setHidden:YES];
        [bgView setHidden:YES];
        if (_style == 2) {
            [_itemType setTitle:_dateDetailLB.text forState:UIControlStateNormal];
        } else if (_style == 3) {
            [_itemType setTitle:[NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]] forState:UIControlStateNormal];
        } else {
            [_itemType setTitle:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"], [self.dateDic objectForKey:@"hour"], [self.dateDic objectForKey:@"minute"]] forState:UIControlStateNormal];
        }
    }
    UIButton *btn = (UIButton *)[self viewWithTag:211];
    if ([btn.titleLabel.text isEqualToString:@"农历"]) {
        NSString *solarStr = [NSString stringWithFormat:@"%@-%@-%@", [self.dateDic objectForKey:@"year"], [self.dateDic objectForKey:@"month"], [self.dateDic objectForKey:@"day"]];
        [_dic setValue:[NSString stringWithFormat:@"%@@@%@", solarStr, _dateDetailLB.text] forKey:@"calendar"];
    } else {
        if (_style != 2) {
            NSString *lunarStr = [NSString stringWithFormat:@"%@", [CalcTime getChineseCalendarWithDate:[NSString stringWithFormat:@"%@-%@-%@", _dateDic[@"year"], _dateDic[@"month"], _dateDic[@"day"]]]];
            [_dic setValue:[NSString stringWithFormat:@"%@@@%@", lunarStr, _dateDetailLB.text] forKey:@"calendar"];
        }
    }
    _constellationStr = [CalcTime calculateConstellationWithMonth:[[self.dateDic objectForKey:@"month"] integerValue] day:[[self.dateDic objectForKey:@"day"] integerValue]];
    _sxStr = [CalcTime getShengxiao:[self.dateDic objectForKey:@"year"]];
    [_dic setValue:_constellationStr forKey:@"constellation"];
    [_dic setValue:_sxStr forKey:@"zodiac"];
    [self.Tdelegate timePicker:self submitSelectedObject:_dic];
    if (_timeBlock) {
        _timeBlock(_dic);
    }
}
#pragma mark - 隐藏滚轮
- (void)hidePicker {
    
    [self setHidden:YES];
    [bgView setHidden:YES];
}
#pragma mark - 滚轮滚动代理
/** 手指一直按着滑动停止*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateScrollViewContentOffset:scrollView];
}
/** 手指松开滚动停止*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateScrollViewContentOffset:scrollView];
}
/** 计算中间cell并返回值*/
- (void)updateScrollViewContentOffset:(UIScrollView *)scroll {
    [self delayMethod:scroll];
//    [self performSelector:@selector(delayMethod:) withObject:scroll afterDelay:0.4f];
}

- (void)delayMethod:(UIScrollView *)scroll {
    CGPoint pt = scroll.contentOffset;
    NSInteger m = (NSInteger)pt.y % (NSInteger)_cellHeight;
    if (m > 0 && m <= (_cellHeight / 2)) {
        scroll.contentOffset = CGPointMake(pt.x, (NSInteger)(pt.y - m));
    } else if (m > (_cellHeight / 2) && m < _cellHeight) {
        scroll.contentOffset = CGPointMake(pt.x, (NSInteger)(pt.y + _cellHeight - m));
    }
    CGPoint point1 = scroll.contentOffset;
    if (point1.y >= 0) {
        NSInteger y = point1.y / _cellHeight;
        [[scroll subviews][y + 3] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
/** 布局*/
- (void)divlayout:(CGFloat)MH with:(CGFloat)MV withPW:(CGFloat)PW withPWP:(CGFloat)PWP {
    
    CGFloat EW = 0,EH = 0,EX = 0,EY=0,LH = 0;
    UIView *tv;
    PWP = PW - PWP;
    EX=PWP+MH;
    for (int i=0;i<self.subviews.count;i++) {
        tv = self.subviews[i];
        EW = tv.frame.size.width;
        EH = tv.frame.size.height;
        if(EX + EW > PWP) {
            EX = M;
            EY = EY+LH+MV;
            LH = EH;
        } else {
            LH = MAX(LH,EH);
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

- (CGRect)FXY:(UIView *)objt xt:(int)xt yt:(int)yt W1:(int)W1 H1:(int)H1 a:(int)a b:(int)b {
    float W0 = objt.frame.size.width;
    float H0 = objt.frame.size.height;
    float X0 = objt.frame.origin.x;
    float Y0 = objt.frame.origin.y;
    int X1 = (int)X0 + (int)(0.5 * ((xt % 6) * W0 - (xt % 4) * W1)) + (int)a;
    int Y1 = (int)Y0 + (int)(0.5 * ((yt % 6) * H0 - (yt % 4) * H1)) + (int)b;
    return CGRectMake(X1, Y1, W1, H1);
}

@end
