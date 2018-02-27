//
//  OOLabel.m
//  PickerTest
//
//  Created by Rong on 2018/2/8.
//  Copyright © 2018年 Rong. All rights reserved.
//
#define ORC_RADIUS 10

#import "OOLabel.h"

@implementation OOLabel
@synthesize title;

-(id)init:(CGPoint) p str:(NSString *) str{
    if([super init] == nil)
        return nil;
    path = [[UIBezierPath alloc] init];
    label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor: [UIColor clearColor]];
    font = [UIFont systemFontOfSize:18.0];
    label.font = font;
    [self setBackgroundColor: [UIColor clearColor]];
    [self setAlpha:0.8];
    [self addSubview: label];
    [self set_point: p];
    [self set_title: str];
    return (self);
}
- (void)reloadData {
    [self setNeedsDisplay];
}

- (void)set_point:(CGPoint)p {
    point = p;
}
- (void)drawRect:(CGRect)rect {
    [[UIColor redColor] setFill];
    [path fill];
}
-(void) set_title:(NSString *)str {
    label.text = str;
    CGSize csize;
    csize.width = 250;
    csize.height = 60;
    size = CGSizeMake(90, 30);
    label.frame = CGRectMake(30, 10, size.width, size.height);
    size.height += 30;
    size.width += 60;
    double x = point.x - size.width;
    double y = point.y - size.height/2;
    origin.x = x;
    origin.y = y;
    self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    [self set_path];
}

- (void)set_path {
    NSLog(@"bounds %@", NSStringFromCGRect(self.bounds));
    NSLog(@"size %@", NSStringFromCGSize(size));
    double h = size.height - ORC_RADIUS;
    CGPoint p = CGPointMake(0, 0);
    NSLog(@"1 start point %@", NSStringFromCGPoint(p));
    
    [path moveToPoint:p];
    p.x += size.width - ORC_RADIUS;
    NSLog(@"2 middle point %@", NSStringFromCGPoint(p));
    
    [path addLineToPoint: p];
    p.y += ORC_RADIUS;
    NSLog(@"3 middle point %@", NSStringFromCGPoint(p));
    p.y += h/2;
    [path addLineToPoint: p];
    p.x += ORC_RADIUS;
    p.y +=8;//指向的长度4
    [path addLineToPoint: p];
    p.x -= ORC_RADIUS;
    p.y +=8;
    [path addLineToPoint: p];
    p.y += h/2;
    [path addLineToPoint: p];
    p.x -= size.width;
    [path addLineToPoint: p];
    p.y -=h;
    [path addLineToPoint: p];
    
    [path closePath];
}

@end
