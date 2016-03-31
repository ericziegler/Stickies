//
//  ZBStickiesDocument.m
//  ZigStickies
//
//  Created by Eric Ziegler on 3/25/16.
//  Copyright © 2016 Zigabytes. All rights reserved.
//

#import "ZBStickiesDocument.h"
#import "ZBStickiesTextField.h"
#import "ZBStickyManager.h"
#import "AppDelegate.h"

@interface ZBStickiesDocument () <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet ZBStickiesTextField            *stickiesTextField;
@property (nonatomic, weak) IBOutlet NSColorWell                    *colorWell;
@property (nonatomic, strong) ZBSticky                              *sticky;
@property (nonatomic, strong) NSMutableArray                        *strikes;
@property (nonatomic, strong) NSArray                               *colors;

@end

@implementation ZBStickiesDocument

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.strikes = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:ZBStickiesWillTerminateNotification object:nil];
        [self populateColors];
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)controller
{
    controller.window.restorable = NO;
    [super windowControllerDidLoadNib:controller];
    [self populateUI];
}

- (void)populateColors
{
    self.colors = @[[NSColor colorWithCalibratedRed:0.55 green:0.83 blue:0.98 alpha:1.0],
                    [NSColor colorWithCalibratedRed:0.42 green:0.96 blue:0.61 alpha:1.0],
                    [NSColor colorWithCalibratedRed:0.96 green:0.71 blue:0.42 alpha:1.0],
                    [NSColor colorWithCalibratedRed:0.69 green:0.68 blue:0.98 alpha:1.0]];
}

- (void)populateUI
{
    if (self.sticky) {
        self.stickiesTextField.stringValue = self.sticky.text;
        self.colorWell.color = self.sticky.backgroundColor;
        self.strikes = [NSMutableArray arrayWithArray:self.sticky.strikes];
        [self updateTextStrikes];
    } else {
        self.stickiesTextField.stringValue = NSLocalizedString(@"TODO:\n-----\n", @"TODO starting text");
        NSArray *backgroundColors = @[[NSColor colorWithCalibratedRed:0.55 green:0.83 blue:0.98 alpha:1.0],
                                      [NSColor colorWithCalibratedRed:0.42 green:0.96 blue:0.61 alpha:1.0],
                                      [NSColor colorWithCalibratedRed:0.96 green:0.71 blue:0.42 alpha:1.0],
                                      [NSColor colorWithCalibratedRed:0.69 green:0.68 blue:0.98 alpha:1.0]];
        NSInteger colorIndex = arc4random() % backgroundColors.count;
        self.colorWell.color = [backgroundColors objectAtIndex:colorIndex];
    }
}

- (void)shouldCloseWindowController:(NSWindowController *)windowController delegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo
{
    [super shouldCloseWindowController:windowController delegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo:contextInfo];
    [[ZBStickyManager defaultManager] removeSticky:self.sticky];
}

#pragma mark - Stickies

- (void)updateSticky:(ZBSticky *)sticky
{
    self.sticky = sticky;
    [self populateUI];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    if (!self.sticky) {
        self.sticky = [[ZBStickyManager defaultManager] generateSticky];
    }
    self.sticky.backgroundColor = self.colorWell.color;
    self.sticky.text = self.stickiesTextField.stringValue;
    self.sticky.strikes = [NSMutableArray arrayWithArray:self.strikes];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Colors

- (IBAction)colorSelected:(id)sender
{
    NSMenuItem *item = sender;
    self.colorWell.color = [self.colors objectAtIndex:item.tag];
}

#pragma mark - Strikethrough

- (IBAction)performStrikethrough:(id)sender
{
    NSRange strikeRange = [self rangeForStrike];
    NSValue *rangeValue = [NSValue valueWithRange:strikeRange];
    if (![self.strikes containsObject:rangeValue]) {
        [self.strikes addObject:rangeValue];
    }
    [self updateTextStrikes];
}

- (IBAction)removeStrikethrough:(id)sender
{
    NSRange strikeRange = [self rangeForStrike];
    NSValue *rangeValue = [NSValue valueWithRange:strikeRange];
    if ([self.strikes containsObject:rangeValue]) {
        [self.strikes removeObject:rangeValue];
    }
    [self updateTextStrikes];
}

- (void)updateTextStrikes
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.stickiesTextField.stringValue];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName : [NSFont fontWithName:@"CourierNewPS-BoldMT" size:16.0],
                                 NSForegroundColorAttributeName : [NSColor blackColor],
                                 NSBackgroundColorAttributeName : [NSColor clearColor],
                                 NSParagraphStyleAttributeName  : paragraphStyle};
    NSRange fullRange = NSMakeRange(0, self.stickiesTextField.stringValue.length);
    [attributedString addAttributes:attributes range:fullRange];
    for (NSValue *curValue in self.strikes) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:(NSNumber *)kCFBooleanTrue range:curValue.rangeValue];
    }
    self.stickiesTextField.attributedStringValue = attributedString;
}

- (NSInteger)cursorLocation
{
    return [[self.stickiesTextField.window fieldEditor:YES forObject:self.stickiesTextField] selectedRange].location;
}

- (NSRange)rangeForStrike
{
    NSInteger cursorLoc = [self cursorLocation];
    NSString *text = self.stickiesTextField.stringValue;
    NSInteger lineStart = 0;
    NSInteger lineEnd = text.length;
    
    // walk backwards until you find a new line
    for (NSInteger i = cursorLoc - 1; i > 0; i--) {
        NSString *characterGroup = [text substringWithRange:NSMakeRange(i - 1, 2)];
        if ([characterGroup rangeOfString:@"\n"].location != NSNotFound) {
            lineStart = i;
            break;
        }
    }
    // walk forwards until you find a new line
    for (NSInteger i = cursorLoc; i < text.length - 1; i++) {
        NSString *characterGroup = [text substringWithRange:NSMakeRange(i - 1, 2)];
        if ([characterGroup rangeOfString:@"\n"].location != NSNotFound) {
            lineEnd = i;
            break;
        }
    }
    
    return NSMakeRange(lineStart, lineEnd - lineStart);
}

#pragma mark - Document Methods

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName
{
    return @"ZBStickiesDocument";
}

- (NSString *)displayName
{
    return @"ZigStickies";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    
    if (commandSelector == @selector(insertNewline:)) {
        // if return is entered, create a new line
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:)) {
        [textView insertTabIgnoringFieldEditor:self];
        result = YES;
    }
    
    return result;
}

@end
