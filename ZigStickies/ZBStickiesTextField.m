//
//  ZBStickiesTextField.m
//  BetterStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "ZBStickiesTextField.h"

@implementation ZBStickiesTextField

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (BOOL) becomeFirstResponder
{
    BOOL responderStatus = [super becomeFirstResponder];
    
    NSRange selectionRange = [[self  currentEditor] selectedRange];
    [[self currentEditor] setSelectedRange:NSMakeRange(selectionRange.length, 0)];
    
    return responderStatus;
}

@end
