//
//  ZBStickyManager.h
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBSticky.h"

@interface ZBStickyManager : NSObject

+ (instancetype)defaultManager;
- (ZBSticky *)generateSticky;
- (BOOL)removeSticky:(ZBSticky *)sticky;
- (NSArray *)loadStickies;
- (void)saveStickies;

@end
