
#import "AddressPicker.h"

@interface AddressPicker() {
    
    FMDatabase *db1;
    FMResultSet *resultSet;
    NSInteger tagValue, idNo, typeNo;
    CGFloat kWidth, cellHeight;//滚轮宽度,按钮高度
    NSString *initialStr, *provID, *townID, *streetCode;
    UIScrollView *detailSC;//地址与行政编号切换的scroll
    CGRect fRect;
    UIView *bgView;
}

@property (nonatomic) UILabel *detailLB, *maskLB;
@property (nonatomic) UIButton *subBTN, *contentBTN;
@property (nonatomic) UIScrollView *provPicker, *cityPicker, *townPicker, *streetPicker;
@property (nonatomic) NSArray *provArry;//省字典
@property (nonatomic) NSMutableArray *cityArry, *townArry, *streetArry;//市，县，街道字典
@property (nonatomic) NSMutableDictionary *textMDic;/** 存放当前显示地址的字典*/
@property (nonatomic, copy) NSString *keyTitle;//当前选中的地址名称
@property (nonatomic, assign) NSInteger keyID, initialID;
@property (nonatomic, copy) void(^ addressBlock)(NSString *);

@end

@implementation AddressPicker
//初始化
- (instancetype)initWithFrame:(CGRect)frame SuperView:(UIView *)sView pickerType:(AddressStyle)type {
    
    if (self == [super initWithFrame:frame]) {
        
        self.textMDic = [NSMutableDictionary dictionary];
        fRect = frame;
        [self setBackgroundColor:HNColor(27, 86, 101)];
        bgView = [[UIView alloc] initWithFrame:CGRectMake(ksetFrameXOnX, ksetFrameYOnX, CW, CH)];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
        [bgView addGestureRecognizer:tap];
        [sView addSubview:bgView];
        [bgView setHidden:YES];
        [sView addSubview:self];
        _style = type;//滚轮样式
        [[self db] open];
        cellHeight = M * 4;
        [self setupTitleView];
        kWidth = fRect.size.width / type;//根据样式设定滚轮不同的宽度
        [self setupProvPicker];
        
    }
    return self;
}

- (void)cancelPicker:(UITapGestureRecognizer *)sender {
    
    [bgView setHidden:YES];
    [self setHidden:YES];
}
/** 滚轮上方显示框和确定按钮*/
- (void)setupTitleView {
    
    CGFloat kw = self.frame.size.width;
    detailSC = [self createScrollWithFrame:CGRectZero bgColor:[UIColor whiteColor] tag:905 superView:self];
    [detailSC setContentSize:CGSizeMake(floor((float)(kw - M * 9)), cellHeight * 2)];
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *lb = [[UILabel alloc] init];
        [lb setTag:900 + i];
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFont:[UIFont systemFontOfSize:kfontSize]];
        [detailSC addSubview:lb];
    }
    _subBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBTN setTitle:@"确定" forState:UIControlStateNormal];
    [_subBTN.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
    [_subBTN setBackgroundColor:HNColor(249, 80, 89)];
    [_subBTN.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_subBTN];
    [_subBTN addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    _maskLB = [[UILabel alloc] init];
    [_maskLB setBackgroundColor:[UIColor lightGrayColor]];
    [_maskLB setAlpha:0.5];
    [self addSubview:_maskLB];
    
}
/** 滚轮上显示内容的按钮*/
- (void)setupContentBtnsinPicker {
    
    NSArray *arr = [NSArray array];
    UIScrollView *scroll;
    for (UIScrollView *SC in [self subviews]) {
        arr = [NSArray arrayWithArray:SC.tag == 100?_provArry:(SC.tag == 101?_cityArry:(SC.tag == 102?_townArry:_streetArry))];//省
        scroll = SC.tag == 100?_provPicker:(SC.tag == 101?_cityPicker:(SC.tag == 102?_townPicker:_streetPicker));
    }
    for (NSInteger i = 0; i < (arr.count + 6); i++) {
        
        _contentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBTN setFrame:CGRectMake(0, cellHeight * i, kWidth, cellHeight)];
        [_contentBTN.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentBTN.titleLabel setFont:[UIFont systemFontOfSize:kfontSize]];
        if (i < 3 || i > (arr.count + 2)) {
            [_contentBTN setTitle:@"" forState:UIControlStateNormal];
            [_contentBTN setUserInteractionEnabled:NO];
        } else {
            [_contentBTN setTitle:arr[i - 3] forState:UIControlStateNormal];
            [_contentBTN setUserInteractionEnabled:YES];
        }
        
        [_contentBTN addTarget:self action:@selector(scrollToMid:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:_contentBTN];
    }
}
/** 省滚轮*/
- (void)setupProvPicker {
    _provArry = @[@" ",@"北京",@"上海",@"天津",@"浙江",@"安徽",@"重庆",@"福建",@"甘肃",@"广东",@"广西",@"贵州",@"海南",@"河北",@"河南",@"黑龙江",@"湖北",@"湖南",@"吉林",@"江苏",@"江西",@"辽宁",@"内蒙古",@"宁夏",@"青海",@"山东",@"山西",@"陕西",@"四川",@"云南",@"西藏",@"新疆",@"台湾",@"香港", @"澳门"];
    
    _provPicker = [self createScrollWithFrame:CGRectZero bgColor:HNColor(67, 68, 69) tag:100 superView:self];
    [_provPicker setContentSize:CGSizeMake(kWidth, cellHeight * (_provArry.count + 6))];
    [self setupContentBtnsinPicker];
    [[_provPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self setHidden:YES];
}
/** 市滚轮*/
- (void)setupCityPicker {
    
    _cityArry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from area where name='%@' and id<100", _textMDic[@"prov"]];
    resultSet = [[self db] executeQuery:sqlStr];
    _keyID = 10000;
    while ([resultSet next]) {
        _keyID = [resultSet intForColumn:@"id"];
        _initialID = [[[NSString stringWithFormat:@"%ld", (long)_keyID] substringToIndex:2] integerValue];
    }
    if (_initialID == 11 || _initialID == 12 || _initialID == 31 || _initialID == 50) {
        initialStr = [NSString stringWithFormat:@"select * from area where id>%ld0000 and id<%ld9999", (long)_keyID, _keyID];
    } else {
        initialStr = [NSString stringWithFormat:@"select * from area where id>%ld00 and id<%ld99", (long)_keyID, _keyID];
    }
    resultSet = [[self db] executeQuery:initialStr];
    while ([resultSet next]) {
        [_cityArry addObject:[resultSet stringForColumn:@"name"]];
    }
    if (_cityArry.count > 0) {
        [_cityArry insertObject:@" " atIndex:0];
    }
    _cityPicker = [self createScrollWithFrame:CGRectZero bgColor:HNColor(66, 69, 85) tag:101 superView:self];
    [_cityPicker setContentSize:CGSizeMake(kWidth, cellHeight * (_cityArry.count + 6))];
    [self setupContentBtnsinPicker];
    
    [[_cityPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}
/** 县滚轮*/
- (void)setupTownPicker {
    
    _townArry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]];
    resultSet = [[self db] executeQuery:sqlStr];
    while ([resultSet next]) {
        if ([[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] substringToIndex:2] integerValue] == [provID integerValue]) {
            _keyID = [resultSet intForColumn:@"id"];
            _initialID = [[[NSString stringWithFormat:@"%ld", (long)_keyID] substringToIndex:2] integerValue];
        }
    }
    if (_initialID == 11 || _initialID == 12 || _initialID == 31 || _initialID == 50) {
        initialStr = [NSString stringWithFormat:@"select * from area where id>%ld000 and id<%ld999", (long)_keyID, _keyID];
    } else {
        initialStr = [NSString stringWithFormat:@"select * from area where id>%ld00 and id<%ld99", (long)_keyID, _keyID];
    }
    resultSet = [[self db] executeQuery:initialStr];
    while ([resultSet next]) {
        [_townArry addObject:[resultSet stringForColumn:@"name"]];
        
    }
    if (_townArry.count > 0) {
        [_townArry insertObject:@" " atIndex:0];
    }
    _townPicker = [self createScrollWithFrame:CGRectZero bgColor:HNColor(66, 68, 118) tag:102 superView:self];
    [_townPicker setContentSize:CGSizeMake(kWidth, cellHeight * (_townArry.count + 6))];
    [self setupContentBtnsinPicker];
    
    [[_townPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
}
/** 街道滚轮*/
- (void)setupStreetPicker {
    
    _streetArry = [NSMutableArray array];
    if (_keyTitle.length > 1) {
        NSString *sqlStr = [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"town"]];
        resultSet = [[self db] executeQuery:sqlStr];
        while ([resultSet next]) {
            if ([[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] substringToIndex:2] integerValue] == [provID integerValue]) {
                _keyID = [resultSet intForColumn:@"id"];
                _initialID = [[[NSString stringWithFormat:@"%ld", (long)_keyID] substringToIndex:2] integerValue];
            }
        }
        initialStr = [NSString stringWithFormat:@"select * from area where id>%ld000 and id<%ld999", (long)_keyID, _keyID];
        
        resultSet = [[self db] executeQuery:initialStr];
        while ([resultSet next]) {
            [_streetArry addObject:[resultSet stringForColumn:@"name"]];
            
        }
        if (_streetArry.count > 0) {
            [_streetArry insertObject:@" " atIndex:0];
        }
        
    } else {
        _streetArry = [NSMutableArray arrayWithCapacity:0];
    }
    _streetPicker = [self createScrollWithFrame:CGRectZero bgColor:HNColor(67, 68, 149) tag:103 superView:self];
    [_streetPicker setContentSize:CGSizeMake(kWidth, cellHeight * (_streetArry.count + 6))];
    [self setupContentBtnsinPicker];
    
    [[_streetPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
}
/** 滚轮上选中内容居中的点击事件*/
- (void)scrollToMid:(UIButton *)sender {
    
    UIScrollView *sv = (UIScrollView *)[sender superview];
    [sv setContentOffset:CGPointMake(sv.contentOffset.x, sender.frame.origin.y - floor(cellHeight * 3))];
    _keyTitle = sender.titleLabel.text;
    if (_keyTitle.length > 0) {
        switch (sv.tag) {
            case 100:
                [self.textMDic setObject:_keyTitle forKey:@"prov"];
                if ([self viewWithTag:101]) {
                    if (_keyTitle.length > 1) {
                        [_cityPicker removeFromSuperview];
                        _cityPicker = nil;
                        [_townPicker removeFromSuperview];
                        [_streetPicker removeFromSuperview];
                        _streetPicker = nil;
                        _townPicker = nil;
                    } else {
                        for (UIButton *btn in [_cityPicker subviews]) {
                            [btn removeFromSuperview];
                        }
                        for (UIButton *btn in [_townPicker subviews]) {
                            [btn removeFromSuperview];
                        }
                        for (UIButton *btn in [_streetPicker subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                }
                if (_keyTitle.length > 1) {
                    resultSet = [[self db] executeQuery:[NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"prov"]]];
                    while ([resultSet next]) {
                        if ([NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]].length == 2) {
                            provID = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]];
                        }
                    }
                }
                [self setupCityPicker];//根据选择的省份生成市滚轮
                break;
            case 101:
                [self.textMDic setObject:_keyTitle forKey:@"city"];
                if (_style == 2) {
                } else {
                    if ([self viewWithTag:102]) {
                        if (_keyTitle.length > 1) {
                            [_townPicker removeFromSuperview];
                            [_streetPicker removeFromSuperview];
                            _streetPicker = nil;
                            _townPicker = nil;
                        } else {
                            for (UIButton *btn in [_townPicker subviews]) {
                                [btn removeFromSuperview];
                            }
                            for (UIButton *btn in [_streetPicker subviews]) {
                                [btn removeFromSuperview];
                            }
                        }
                    }
                    [self setupTownPicker];//根据选择的城市生成县滚轮
                }
                break;
            case 102:
                [self.textMDic setObject:_keyTitle forKey:@"town"];
                if (_keyTitle.length > 1) {
                    resultSet = [[self db] executeQuery:[NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"town"]]];
                    while ([resultSet next]) {
                        if ([NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]].length == 6 && [[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] substringToIndex:2] isEqualToString:provID]) {
                            townID = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]];
                        } else {
                            townID = @"";
                        }
                    }
                }
                if ([self viewWithTag:103]) {
                    if (_keyTitle.length > 1) {
                        [_streetPicker removeFromSuperview];
                        _streetPicker = nil;
                    } else {
                        for (UIButton *btn in [_streetPicker subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    
                }
                NSLog(@"%@", _textMDic[@"town"]);
                [self setupStreetPicker];//根据选择的县生成街道滚轮
                break;
            case 103:
                [self.textMDic setObject:_keyTitle forKey:@"street"];
                ;
                break;
                
            default:
                break;
        }
    }
    
    [self bringSubviewToFront:_maskLB];
    
    UILabel *lb = (UILabel *)[self viewWithTag:900];
    NSString *str;
    //给显示框赋值
    if (_keyTitle.length == 0 && [_textMDic[@"prov"] isEqualToString:@" "]) {
        [lb setText:[NSString stringWithFormat:@""]];
    } else if (_keyTitle.length <= 1 && [_textMDic[@"city"] isEqualToString:@" "]) {
        [lb setText:[NSString stringWithFormat:@"%@", [self.textMDic objectForKey:@"prov"]]];
        str = [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"prov"]];
    } else if (_keyTitle.length <= 1 && [_textMDic[@"town"] isEqualToString:@" "]) {
        [lb setText:[NSString stringWithFormat:@"%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"]]];
        str = [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]];
    } else if (_keyTitle.length <= 1 && [_textMDic[@"street"] isEqualToString:@" "]) {
        [lb setText:(_style == 2) ? [NSString stringWithFormat:@"%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"]] : [NSString stringWithFormat:@"%@-%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"], [self.textMDic objectForKey:@"town"]]];
        str = (_style == 2) ? [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]] : [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"town"]];
    } else {
        if (_initialID == 11 || _initialID == 12 || _initialID == 31 || _initialID == 50 || _initialID == 71 || _initialID == 81) {
            [lb setText:(_style == 2) ? [NSString stringWithFormat:@"%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"]] : [NSString stringWithFormat:@"%@-%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"], [self.textMDic objectForKey:@"town"]]];
            str = (_style == 2) ? [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]] : [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"town"]];
        } else if (_initialID == 82) {
            [lb setText:[NSString stringWithFormat:@"%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"]]];
            str = [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]];
        } else {
            [lb setText:(_style == 2) ? [NSString stringWithFormat:@"%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"]] : ((_style == 3) ? [NSString stringWithFormat:@"%@-%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"], [self.textMDic objectForKey:@"town"]] : [NSString stringWithFormat:@"%@-%@-%@-%@", [self.textMDic objectForKey:@"prov"], [self.textMDic objectForKey:@"city"], [self.textMDic objectForKey:@"town"], [self.textMDic objectForKey:@"street"]])];
            str = (_style == 2) ? [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"city"]] : ((_style == 3) ? [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"town"]] : [NSString stringWithFormat:@"select * from area where name='%@'", _textMDic[@"street"]]);
        }
    }
    if ([_textMDic[@"prov"] isEqualToString:@" "]) {
        streetCode = @"";
    } else {
        resultSet = [[self db] executeQuery:str];
        while ([resultSet next]) {
            if ([NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]].length >= 6 && townID.length > 0) {
                if ([[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] substringToIndex:6] isEqualToString:townID]) {
                    streetCode = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]];
                }
            } else if ([[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] substringToIndex:2] isEqualToString:provID]) {
                streetCode = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]];
            }
            
        }
    }
    UILabel *lb1 = (UILabel *)[self viewWithTag:901];
    [lb1 setText:streetCode];
}
/** 显示滚轮*/
- (void)showPicker {
    //根据已显示的地址关联到滚轮的内容
    if (([_itemType isKindOfClass:[UITextField class]] && [[_itemType text] containsString:@"-"]) || ([_itemType isKindOfClass:[UIButton class]] && [[[_itemType titleLabel] text] containsString:@"-"])) {
        NSArray *arr;
        if ([_itemType isKindOfClass:[UITextField class]]) {
            arr = [[_itemType text] componentsSeparatedByString:@"-"];
        }
        if ([_itemType isKindOfClass:[UIButton class]]) {
            arr = [[[_itemType titleLabel] text] componentsSeparatedByString:@"-"];
        }
        switch ([arr count]) {
            case 2:
                
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_townPicker subviews]) {
                    [btn removeFromSuperview];
                }
                for (UIButton *btn in [_streetPicker subviews]) {
                    [btn removeFromSuperview];
                }
                break;
            case 3:
                NSLog(@"省：%@，市：%@，县：%@", arr[0], arr[1], arr[2]);
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_townPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_streetPicker subviews]) {
                    [btn removeFromSuperview];
                }
                break;
            case 4:
                NSLog(@"省：%@，市：%@，县：%@，街：%@", arr[0], arr[1], arr[2], arr[3]);
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_townPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_streetPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[3]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                break;
                
            default:
                break;
        }
        
    } else {
        [[_provPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];

    }
    [self setHidden:NO];
    [bgView setHidden:NO];
}

- (void)showPicker:(void(^)(NSString *address))addressBlock withAddress:(NSString *)address {
    
    if ([address containsString:@"-"]) {
        NSArray *arr = [address componentsSeparatedByString:@"-"];
        switch ([arr count]) {
            case 2:
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [[_townPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
                for (UIButton *btn in [_streetPicker subviews]) {
                    [btn removeFromSuperview];
                }
                break;
            case 3:
                NSLog(@"省：%@，市：%@，县：%@", arr[0], arr[1], arr[2]);
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_townPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [[_streetPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
                break;
            case 4:
                NSLog(@"省：%@，市：%@，县：%@，街：%@", arr[0], arr[1], arr[2], arr[3]);
                for (UIButton *btn in [_provPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[0]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_cityPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[1]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_townPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[2]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                for (UIButton *btn in [_streetPicker subviews]) {
                    if ([btn.titleLabel.text isEqualToString:arr[3]]) {
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                break;
                
            default:
                break;
        }
    } else {
        [[_provPicker subviews][4] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [self setHidden:NO];
    [bgView setHidden:NO];
    UILabel *lb = (UILabel *)[self viewWithTag:900];
    lb.text = address;
    _addressBlock = addressBlock;
}
/** 确定按钮点击事件*/
- (void)submit:(UIButton *)sender {
    
    UILabel *lb = (UILabel *)[self viewWithTag:900];
    if ([_itemType isKindOfClass:[UITextField class]]) {
        [_itemType setText:lb.text];
        [_itemType endEditing:YES];
    }
    if ([_itemType isKindOfClass:[UIButton class]]) {
        [_itemType setTitle:lb.text forState:UIControlStateNormal];
    }
    [self setHidden:YES];
    [bgView setHidden:YES];
    [self.delegate addressPicker:self getSelectedAddress:[NSString stringWithFormat:@"%@||%@", streetCode, lb.text]];
    if (_addressBlock) {
        _addressBlock([NSString stringWithFormat:@"%@||%@", streetCode, lb.text]);
    }
}
/** 隐藏滚轮*/
- (void)hidePicker {
    
    [self setHidden:YES];
    [bgView setHidden:YES];
}
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
//    [self performSelector:@selector(delayMethod:) withObject:scroll afterDelay:0.1f];
}

- (void)delayMethod:(UIScrollView *)scroll {
    
    if (scroll.tag == 100 || scroll.tag == 101 || scroll.tag == 102 || scroll.tag == 103) {
        CGPoint pt = scroll.contentOffset;
        NSInteger m = (NSInteger)pt.y % (NSInteger)cellHeight;
        if (m > 0 && m <= (cellHeight / 2)) {
            scroll.contentOffset = CGPointMake(pt.x, pt.y - m);
        } else if (m > (cellHeight / 2) && m < cellHeight) {
            scroll.contentOffset = CGPointMake(pt.x, pt.y + cellHeight - m);
        }
        CGPoint point1 = scroll.contentOffset;
        if (point1.y >= 0) {
            NSInteger y = point1.y / cellHeight;
            if ([scroll subviews].count > 0) {
                if ((scroll.tag != 100 || (scroll.tag == 100 && y <= (_provArry.count * 3 / 4))) && y != 0) {
                    [[scroll subviews][y + 4] sendActionsForControlEvents:UIControlEventTouchUpInside];
                } else if (point1.y > cellHeight * 0.5 && point1.y < cellHeight && y == 0) {
                    [[scroll subviews][y + 4] sendActionsForControlEvents:UIControlEventTouchUpInside];
                } else {
                    [[scroll subviews][y + 3] sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}
/** 获取本地储存的数据库*/
- (NSString *)dataPathWithName {
    
    NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"wit_citys" ofType:@"db"];
    return backupDbPath;
}
/** 创建fmdb的对象*/
- (FMDatabase *)db {
    NSString *dataPath = [self dataPathWithName];
    if (!db1) {
        db1 = [FMDatabase databaseWithPath:dataPath];
    }
    return db1;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    fRect = self.frame;
    [bgView setFrame:self.superview.frame];
    switch (_style) {
        case 2:
            kWidth = fRect.size.width / 2;
            break;
        case 3:
            kWidth = fRect.size.width / 3;
            break;
        case 4:
            kWidth = fRect.size.width / 4;
            break;
        default:
            break;
    }
    [detailSC setFrame:CGRectMake(M, M, floor((float)(fRect.size.width - M * 9)), cellHeight)];
    for (NSInteger i = 0; i < [detailSC subviews].count; i++) {
        UILabel *lb = [detailSC subviews][i];
        [lb setFrame:CGRectMake(0, cellHeight * i, floor((float)(fRect.size.width - M * 9)), cellHeight)];
    }
    [_subBTN setFrame:CGRectMake(detailSC.frame.size.width + M * 2, M, ((CGFloat)M * 6), cellHeight)];
    [_maskLB setFrame:CGRectMake(0, M * 18, self.frame.size.width, cellHeight)];
    for (UIScrollView *scroll in [self subviews]) {
        switch (scroll.tag) {
            case 100:
                [_provPicker setFrame:CGRectMake(0, M * 6, kWidth, cellHeight * 7)];
                break;
            case 101:
                [_cityPicker setFrame:CGRectMake(CGRectGetMaxX(_provPicker.frame), M * 6, kWidth, cellHeight * 7)];
                break;
            case 102:
                [_townPicker setFrame:CGRectMake(CGRectGetMaxX(_cityPicker.frame), M * 6, kWidth, cellHeight * 7)];
                break;
            case 103:
                [_streetPicker setFrame:CGRectMake(CGRectGetMaxX(_townPicker.frame), M * 6, kWidth, cellHeight * 7)];
                break;
            default:
                break;
        }
        if (scroll.tag == 100 || scroll.tag == 101 || scroll.tag == 102 || scroll.tag == 103) {
            for (NSInteger i = 0; i < [scroll subviews].count; i++) {
                UIButton *btn = [scroll subviews][i];
                [btn setFrame:CGRectMake(0, cellHeight * i, kWidth, cellHeight)];
            }
        }
    }
    [bgView setFrame:CGRectMake(ksetFrameXOnX, ksetFrameYOnX, CW, CH)];
}

- (UIScrollView *)createScrollWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor tag:(NSInteger)tag superView:(UIView *)superView {
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:frame];
    [scrollV setBackgroundColor:bgColor];
    [scrollV setShowsHorizontalScrollIndicator:NO];
    [scrollV setShowsVerticalScrollIndicator:NO];
    [scrollV setDelegate:self];
    [scrollV setTag:tag];
    [superView addSubview:scrollV];
    
    return scrollV;
}

@end
