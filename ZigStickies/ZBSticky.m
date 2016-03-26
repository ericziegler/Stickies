//
//  ZBSticky.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "ZBSticky.h"
#import "NSColor+Zigabytes.h"

static NSString * ZBStickiesIdentifierKey       =   @"ZBStickiesIdentifierKey";
static NSString * ZBStickiesBackgroundColorKey  =   @"ZBStickiesBackgroundColorKey";
static NSString * ZBStickiesTextKey             =   @"ZBStickiesTextKey";
static NSString * ZBStickiesStrikesKey          =   @"ZBStickiesStrikesKey";

@interface ZBSticky()

@end

@implementation ZBSticky

#pragma mark - Init

+ (instancetype)stickyWithIdentifier:(NSInteger)identifier
{
    ZBSticky *sticky = [[ZBSticky alloc] init];
    sticky.identifier = [NSNumber numberWithInteger:identifier];
    return sticky;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.strikes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSString *colorString = [self.backgroundColor hexString];
    [coder encodeObject:colorString forKey:ZBStickiesBackgroundColorKey];
    [coder encodeObject:self.identifier forKey:ZBStickiesIdentifierKey];
    [coder encodeObject:self.text forKey:ZBStickiesTextKey];
    [coder encodeObject:self.strikes forKey:ZBStickiesStrikesKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSString *colorString = [coder decodeObjectForKey:ZBStickiesBackgroundColorKey];
    self.backgroundColor = [NSColor colorWithHexColorString:colorString];
    self.identifier = [coder decodeObjectForKey:ZBStickiesIdentifierKey];
    self.text = [coder decodeObjectForKey:ZBStickiesTextKey];
    self.strikes = [coder decodeObjectForKey:ZBStickiesStrikesKey];
    return self;
}

@end
