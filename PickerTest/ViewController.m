//
//  ViewController.m
//  PickerTest
//
//  Created by Rong on 17/1/13.
//  Copyright © 2017年 Rong. All rights reserved.
//

#import "ViewController.h"
#import "AddressPicker.h"
#import "TimePicker.h"
#import "OOLabel.h"
#import "OOLabelTwo.h"
#import "WBPopOverView.h"

@interface ViewController ()<TimePickerDelegate, AddressPickerDelegate>

@property (nonatomic, strong) UIButton *myTV, *urTV;
@property (nonatomic, strong) AddressPicker *addressPV;/** 自定义地址滚轮视图的对象*/
@property (nonatomic, strong) TimePicker *timeV;/** 时间滚轮对象*/
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) UILabel *xzLb, *sxLb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewhandleDeviceOrientationDidChanged) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];/** 监测横屏通知*/
    
    [self setupUI];
    [self setupPicker];
    
    UIButton *testBtn = [UIButton buttonWithType:0];
    [testBtn setBackgroundColor:[UIColor greenColor]];
    [testBtn setFrame:CGRectMake(100, 400, 100, 80)];
    [self.view addSubview:testBtn];
    [UIView animateWithDuration:3.0f animations:^{
        testBtn.alpha = 0.0f;
    }];
    
    OOLabel *testLb = [[OOLabel alloc] init:CGPointMake(100, 500) str:@"测试"];
    [self.view addSubview:testLb];
    
//    OOLabelTwo *testLbTwo = [[OOLabelTwo alloc] initWithFrame:CGRectMake(150, 400, 100, 80)];
//    [self.view addSubview:testLbTwo];
    
    CGPoint point=CGPointMake(self.sxLb.frame.origin.x+self.sxLb.frame.size.width/2, self.sxLb.frame.origin.y+self.sxLb.frame.size.height);//箭头点的位置
    WBPopOverView *view=[[WBPopOverView alloc]initWithOrigin:point Width:160 Height:100 Direction:WBArrowDirectionUp3];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 160, 100)];
    lable.text=@"这里显示生肖";
    lable.textColor=[UIColor whiteColor];
    [view.backView addSubview:lable];
    [view popView];
    [self.view addSubview:view];
    
//    CGPoint point1=CGPointMake(self.xzLb.frame.origin.x+self.xzLb.frame.size.width/2, self.xzLb.frame.origin.y+self.xzLb.frame.size.height);//箭头点的位置
//    WBPopOverView *view1=[[WBPopOverView alloc]initWithOrigin:point1 Width:160 Height:100 Direction:WBArrowDirectionUp2];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
//    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 160, 100)];
//    lable1.text=@"这里显示星座";
//    lable1.textColor=[UIColor whiteColor];
//    [view1.backView addSubview:lable1];
//    [view1 popView];
//    [self.view addSubview:view1];
}
//滚轮初始化方法
- (void)setupPicker {
    //时间滚轮
    _timeV = [[TimePicker alloc] initWithParentView:self.view type:5];
    [_timeV setTdelegate:self];
    [_timeV setInputChinese:YES];
    //地址滚轮
    _addressPV = [[AddressPicker alloc] initWithFrame:CGRectMake(0, CH - M * 35, CW, M * 35) SuperView:self.view pickerType:3];
    [_addressPV setDelegate:self];
    
}
//
- (void)setupUI {
    
    self.urTV = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, CW, CH / 9)];
    [self.urTV setBackgroundColor:[UIColor purpleColor]];
    [self.urTV setTitle:@"安徽-蚌埠-禹会区-秦集镇" forState:UIControlStateNormal];
    [self.urTV addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.urTV];
    self.myTV = [[UIButton alloc] initWithFrame:CGRectMake(0, CH / 9 + 20, CW, CH / 9)];
    [self.myTV setBackgroundColor:[UIColor cyanColor]];
    [self.myTV setTitle:@"请选择时间" forState:UIControlStateNormal];
    [self.myTV addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myTV];
    self.xzLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CH * 2 / 9 + 20, CW / 2, CH / 9)];
    self.sxLb = [[UILabel alloc] initWithFrame:CGRectMake(CW / 2, CH * 2 / 9 + 20, CW / 2, CH / 9)];
    [self.xzLb setBackgroundColor:[UIColor blueColor]];
    [self.sxLb setBackgroundColor:[UIColor blueColor]];
    [self.xzLb setTextAlignment:NSTextAlignmentCenter];
    [self.sxLb setTextAlignment:NSTextAlignmentCenter];
    [self.xzLb.layer setBorderWidth:0.5];
    [self.sxLb.layer setBorderWidth:0.5];
    [self.view addSubview:self.xzLb];
    [self.view addSubview:self.sxLb];
    
    [self.xzLb setText:@"星座"];
    [self.sxLb setText:@"生肖"];
    
}

- (void)didselect:(UIButton *)textField {
    /** 把触发的控件类型传给滚轮*/
    if (textField == self.myTV) {
        _timeV.itemType = textField;
        [_timeV showPicker];
    }
    if (textField == self.urTV) {
        _addressPV.itemType = textField;
        [_addressPV showPicker];
    }
}
/**获取已选日期*/
- (void)timePicker:(TimePicker *)picker submitSelectedObject:(NSMutableDictionary *)selectedObject {
    
    self.dic = selectedObject;
    NSLog(@"星座是:%@, 生肖是:%@", [selectedObject valueForKey:@"constellation"], [selectedObject valueForKey:@"zodiac"]);
    [self.xzLb setText:[selectedObject valueForKey:@"constellation"]];
    [self.sxLb setText:[selectedObject valueForKey:@"zodiac"]];
}
/**获取已选地址*/                                                                                                 
- (void)addressPicker:(AddressPicker *)picker getSelectedAddress:(NSString *)address {
    
    NSLog(@"地址：%@", address);
}

- (void)viewhandleDeviceOrientationDidChanged {
    
    [self.urTV setFrame:CGRectMake(0, 20, CW, CH / 9)];
    [self.myTV setFrame:CGRectMake(0, CH / 9 + 20, CW, CH / 9)];
    [self.xzLb setFrame:CGRectMake(0, CH * 2 / 9 + 20, CW / 2, CH / 9)];
    [self.sxLb setFrame:CGRectMake(CW / 2, CH * 2 / 9 + 20, CW / 2, CH / 9)];
    [_addressPV setFrame:CGRectMake(ksetFrameXOnX, CH - M * 35, CW, M * 35)];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

@end
