//
//  AppDelegate.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBStickiesDocument.h"
#import "ZBStickyManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [NSApp activateIgnoringOtherApps:YES];
    BOOL reset = NO;
    if (reset) {
        [self TEMPCLEAR];
    } else {
        [self generateStickies];
    }
}

- (void)TEMPCLEAR
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZBStickiesCacheKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZBStickiesWillTerminateNotification object:nil userInfo:nil];
    [[ZBStickyManager defaultManager] saveStickies];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return NO;
}

- (void)generateStickies
{
    NSArray *stickies = [[ZBStickyManager defaultManager] loadStickies];
    if (stickies.count > 0) {
        // open all existing stickies
        for (ZBSticky *curSticky in stickies) {
            ZBStickiesDocument *doc = [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
            [doc updateSticky:curSticky];
        }
    } else {
        // new sticky
        [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
    }
}

@end
