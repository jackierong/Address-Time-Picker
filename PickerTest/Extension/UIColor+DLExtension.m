//
//  UIColor+DLExtension.m
//  DLKit
//
//  Created by JGW on 16/3/1.
//  Copyright (c) 2015年 JGW. All rights reserved.
//

#import "UIColor+DLExtension.h"

@implementation UIColor (DLExtension)

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    if (![scanner scanString:@"{" intoString:NULL]) return nil;
    const NSUInteger kMaxComponents = 4;
    float c[kMaxComponents];
    NSUInteger i = 0;
    if (![scanner scanFloat:&c[i++]]) return nil;
    while (1) {
        if ([scanner scanString:@"}" intoString:NULL]) break;
        if (i >= kMaxComponents) return nil;
        if ([scanner scanString:@"," intoString:NULL]) {
            if (![scanner scanFloat:&c[i++]]) return nil;
        } else {
            // either we're at the end of there's an unexpected character here
            // both cases are error conditions
            return nil;
        }
    }
    if (![scanner isAtEnd]) return nil;
    UIColor *color;
    switch (i) {
        case 2: // monochrome
            color = [UIColor colorWithWhite:c[0] alpha:c[1]];
            break;
        case 4: // RGB
            color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
            break;
        default:
            color = nil;
    }
    return color;
}

#pragma mark Class methods

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(CGFloat)RAND_MAX / random()
                           green:(CGFloat)RAND_MAX / random()
                            blue:(CGFloat)RAND_MAX / random()
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    //	int r = (hex >> 16) & 0xFF;
    //	int g = (hex >> 8) & 0xFF;
    //	int b = (hex) & 0xFF;
    //
    //	return [UIColor colorWithRed:r / 255.0f
    //						   green:g / 255.0f
    //							blue:b / 255.0f
    //						   alpha:1.0f];
    return [UIColor colorWithRGBHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    //	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    //	unsigned hexNum;
    //	if (![scanner scanHexInt:&hexNum]) return nil;
    //	return [UIColor colorWithRGBHex:hexNum];
    return [UIColor colorWithHexString:stringToConvert alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum alpha:alpha];
}

+ (instancetype)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (instancetype)primaryBackgroundColor
{
    return [UIColor colorWithHue:240.0f / 360.0f saturation:0.24f brightness:0.13f alpha:1.0f];
}

+ (instancetype)secondaryBackgroundColor
{
    return [UIColor colorWithHue:240.0f / 360.0f saturation:0.22f brightness:0.16f alpha:1.0f];
}

+ (instancetype)hotColor
{
    return [UIColor colorWithHue:11.0f / 360.0f saturation:0.80f brightness:0.92f alpha:1.0f];
}

+ (instancetype)warmerColor
{
    return [UIColor colorWithHue:40.0f / 360.0f saturation:1.0f brightness:0.97f alpha:1.0f];
}

+ (instancetype)coolerColor
{
    return [UIColor colorWithHue:194.0f / 360.0f saturation:1.0f brightness:0.93f alpha:1.0f];
}

+ (instancetype)coldColor
{
    return [UIColor colorWithHue:194.0f / 360.0f saturation:0.54f brightness:0.95f alpha:1.0f];
}

- (instancetype)lighterColorByAmount:(CGFloat)amount
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    CGFloat newSaturation = saturation * (1 - amount);
    CGFloat newBrightness = brightness * (1 - amount) + amount;
    
    return [UIColor colorWithHue:hue saturation:newSaturation brightness:newBrightness alpha:alpha];
}


@end
