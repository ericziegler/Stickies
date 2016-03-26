//
//  NSColor+Zigabytes.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "NSColor+Zigabytes.h"

@implementation NSColor (Zigabytes)

+ (NSColor *)colorWithHexColorString:(NSString *)inColorString
{
    NSColor *result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (NSString *)hexString
{
    return [NSString stringWithFormat:@"%02X%02X%02X",
                           (int) (self.redComponent * 0xFF), (int) (self.greenComponent * 0xFF),
                           (int) (self.blueComponent * 0xFF)];
}

@end
