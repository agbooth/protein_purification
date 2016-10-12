//
//  pp_GetFractionController.m
//  Protein Purification
//
//  Created by Andrew Booth on 05/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetFractionController.h"
#import "pp_AppDelegate.h"

@interface pp_GetFractionController ()

@end

@implementation pp_GetFractionController
@synthesize label;
@synthesize value;
@synthesize stepper;
@synthesize thisPanel;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize image;
@synthesize fraction;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_GetFractionController" owner: self];
    
    [self.view.window makeFirstResponder:stepper];
    
    [thisPanel setTitle:NSLocalizedString(@"2D - PAGE",@"")];
    
    label.stringValue = NSLocalizedString(@"Select the fraction to examine.",@"");
    
    [OKButton setTitle:NSLocalizedString(@"OK",@"")];
    [CancelButton setTitle:NSLocalizedString(@"Cancel",@"")];

    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [app.commands.frax addObject:[NSNumber numberWithInt:60]];
    app.commands.noOfFractions = 1;
    app.commands.startOfPool = 60;
    app.commands.endOfPool = 60;
    app.commands.pooled = YES;
    
    [app.window.contentView setNeedsDisplay:YES];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    fraction = [stepper integerValue];
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    
    app.commands.pooled = NO;
    [app.window.contentView setNeedsDisplay:YES];    
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    fraction = -1;
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    
    app.commands.pooled = NO;
    [app.window.contentView setNeedsDisplay:YES];
    
    [NSApp stopModal];
}


- (IBAction)stepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:stepper];
    fraction = [stepper integerValue];
    NSString* valueString = [NSString stringWithFormat:@"%ld",(long)fraction];
    value.stringValue = valueString;
    app.commands.startOfPool = fraction;
    app.commands.endOfPool = fraction;
    [app.commands.frax replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:(int)fraction]];
    [app.window.contentView setNeedsDisplay:YES];
}

- (NSInteger) getNoOfFractions
{
    return fraction;
}
@end
