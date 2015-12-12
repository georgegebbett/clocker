//
//  CLRatingCellView.m
//  Clocker
//
//  Created by Abhishek Banthia on 12/11/15.
//
//

#import "CLRatingCellView.h"
#import "iRate.h"
#import <QuartzCore/QuartzCore.h>
#import "PanelController.h"

@implementation CLRatingCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)actionOnNegativeFeedback:(id)sender
{
    NSButton *leftButton = (NSButton *)sender;
    
    if ([leftButton.title isEqualToString:@"Not Really"]) {
         [self setAnimatedStringValue:@"Mind giving us some feedback?" andTextField:self.leftField];
    }
    else
    {
        //Make the row disappear and call remind later
        PanelController *panelRef = [[[NSApplication sharedApplication] mainWindow] windowController];
        panelRef.showReviewCell = NO;
        [panelRef updateDefaultPreferences];
        [panelRef closePanel];
        [[iRate sharedInstance] remindLater];
    }
}

- (IBAction)actionOnPositiveFeedback:(id)sender
{
    NSButton *rightButton = (NSButton *)sender;
    
    if ([rightButton.title isEqualToString:@"Yes!"]) {
        [self setAnimatedStringValue:@"Rate us on the App Store, then?" andTextField:self.leftField];
    }
    else
    {
        //Make the row disappear and call rate
        
        [[iRate sharedInstance] rate];
        PanelController *panelRef = [[[NSApplication sharedApplication] mainWindow] windowController];
        panelRef.showReviewCell = NO;
        [panelRef updateDefaultPreferences];
    }
}

- (void) setAnimatedStringValue:(NSString *)aString andTextField:(NSTextField *)textfield
{
    if ([[textfield stringValue] isEqual: aString])
    {
        return;
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration: 1.0];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [self.imageView.animator setAlphaValue:0.0];
        [self.leftButton.animator setAlphaValue:0.0];
        [self.rightButton.animator setAlphaValue:0.0];
        [textfield.animator setAlphaValue: 0.0];
    }
                        completionHandler:^{
                            [textfield setStringValue: aString];
                            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                                [context setDuration: 1.0];
                                [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
                                [self.imageView.animator setAlphaValue: 1.0];
                                [textfield.animator setAlphaValue: 1.0];
                                [self.leftButton.animator setAlphaValue:1.0];
                                [self.rightButton.animator setAlphaValue:1.0];
                                if ([self.leftButton.title isEqualToString:@"Not Really"]) {
                                    [self.leftButton.animator setTitle:@"No, thanks"];
                                }
                                if ([self.rightButton.title isEqualToString:@"Yes!"]) {
                                    [self.rightButton.animator setTitle:@"Ok, sure"];
                                }

                            } completionHandler: ^{
                                                            }];
                        }];
}


@end
