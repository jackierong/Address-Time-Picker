//
//  AddressPicker.h
//  NewnewAddress
//
//  Created by Rong on 17/1/10.
//  Copyright © 2017年 Rong. All rights reserved.
//

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define krect [UIScreen mainScreen].bounds.size
#define Kvmax (MAX(krect.width,krect.height))
#define Kvmin  (MIN(krect.width,krect.height))

#define CW0 ([UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation==UIDeviceOrientationLandscapeRight?Kvmax:Kvmin)
#define CH0 (CW0==Kvmax?Kvmin:Kvmax)
#define M0 MAX(CW0, CH0) / 64

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "IWCommon.h"
//滚轮样式枚举
typedef NS_ENUM(NSInteger, AddressStyle) {
    
    AddressStyle_ProvAndCity = 2,//只显示省市
    AddressStyle_ProvCityAndTown,
    AddressStyle_TotalAddress//所有
    
};

@class AddressPicker;
@protocol AddressPickerDelegate <NSObject>

@optional
- (void)addressPicker:(AddressPicker *)picker getSelectedAddress:(NSString *)address;//获取已选地址的代理

@end

@interface AddressPicker : UIView<UIScrollViewDelegate>

@property (nonatomic) id itemType;/** 赋值的输入框*/
@property (nonatomic, assign) AddressStyle style;/** 滚轮样式*/
@property (nonatomic, weak) id<AddressPickerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame SuperView:(UIView *)sView pickerType:(AddressStyle)type;

- (void)showPicker;/** 显示滚轮视图方法*/

- (void)hidePicker;/** 隐藏滚轮视图方法*/

- (void)showPicker:(void(^)(NSString *address))addressBlock withAddress:(NSString *)address;/** 显示滚轮并传值*/

@end
