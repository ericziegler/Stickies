//
//  ZBStickyManager.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "ZBStickyManager.h"

static NSString * ZBStickiesCacheKey  =   @"ZBStickiesCacheKey";

@interface ZBStickyManager()

@property (nonatomic, strong) NSMutableDictionary            *stickies;

@end

@implementation ZBStickyManager

+ (instancetype)defaultManager
{
    static ZBStickyManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.stickies = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Managing Sticky Objects

- (ZBSticky *)generateSticky
{
    ZBSticky *sticky = [ZBSticky stickyWithIdentifier:[self generateIdentifier]];
    [self.stickies setObject:sticky forKey:sticky.identifier];
    return sticky;
}

- (BOOL)removeSticky:(ZBSticky *)sticky
{
    BOOL result = NO;
    
    if ([self.stickies objectForKey:sticky.identifier]) {
        [self.stickies removeObjectForKey:sticky.identifier];
        [self saveStickies];
        result = YES;
    }
    
    return result;
}

- (NSInteger)generateIdentifier
{
    NSInteger identifier = arc4random();
    NSArray *existingIdentifiers = [self.stickies allKeys];
    while ([existingIdentifiers containsObject:[NSNumber numberWithInteger:identifier]]) {
        identifier = arc4random();
    }
    return identifier;
}

#pragma mark - Load / Save

- (NSArray *)loadStickies
{
    NSArray *result = nil;
    NSData *stickiesData = [[NSUserDefaults standardUserDefaults] objectForKey:ZBStickiesCacheKey];
    if (stickiesData) {
        result = [NSKeyedUnarchiver unarchiveObjectWithData:stickiesData];
    }
    
    for (ZBSticky *curSticky in result) {
        [self.stickies setObject:curSticky forKey:curSticky.identifier];
    }
    
    return result;
}

- (void)saveStickies
{
    NSData *stickiesData = [NSKeyedArchiver archivedDataWithRootObject:[self.stickies allValues]];
    [[NSUserDefaults standardUserDefaults] setObject:stickiesData forKey:ZBStickiesCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
