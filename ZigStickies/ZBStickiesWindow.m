//
//  ZBStickiesWindow.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "ZBStickiesWindow.h"

@implementation ZBStickiesWindow

+ (NSButton *)standardWindowButton:(NSWindowButton)windowButtonKind forStyleMask:(NSUInteger)windowStyle
{
    if (windowButtonKind == NSWindowDocumentVersionsButton) {
        return nil;
    }
    return [super standardWindowButton:windowButtonKind forStyleMask:windowStyle];
}

@end
