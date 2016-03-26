//
//  ZBStickiesDocument.h
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZBSticky.h"

@interface ZBStickiesDocument : NSDocument

- (void)updateSticky:(ZBSticky *)sticky;

@end

