//
//  ZBSticky.h
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface ZBSticky : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber          *identifier;
@property (nonatomic, strong) NSColor           *backgroundColor;
@property (nonatomic, strong) NSString          *text;
@property (nonatomic, strong) NSMutableArray    *strikes;

+ (instancetype)stickyWithIdentifier:(NSInteger)identifier;

@end
