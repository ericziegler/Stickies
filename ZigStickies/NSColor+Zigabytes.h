//
//  NSColor+Zigabytes.h
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Zigabytes)

+ (NSColor *)colorWithHexColorString:(NSString *)inColorString;
- (NSString *)hexString;

@end
