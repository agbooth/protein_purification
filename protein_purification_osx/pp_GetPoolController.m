//
//  pp_GetPoolController.m
//  Protein Purification
//
//  Created by Andrew Booth on 04/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetPoolController.h"
#import "pp_AppDelegate.h"

@interface pp_GetPoolController () {
    
    NSInteger start;
    NSInteger end;
    
}

@end

@implementation pp_GetPoolController

@synthesize thisPanel;
@synthesize startStepper;
@synthesize endStepper;
@synthesize startValue;
@synthesize endValue;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize startLabel;
@synthesize endLabel;
@synthesize image;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_GetPoolController" owner: self];
    
    [self.thisPanel setTitle:NSLocalizedString(@"Pool fractions",@"")];
    [self.view.window makeFirstResponder:startStepper];
    
    startLabel.stringValue = NSLocalizedString(@"First fraction:",@"");
    endLabel.stringValue = NSLocalizedString(@"Last fraction:",@"");
    
    [OKButton setTitle:NSLocalizedString(@"OK",@"")];
    [CancelButton setTitle:NSLocalizedString(@"Cancel",@"")];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    app.commands.startOfPool = 1;
    app.commands.endOfPool = 125;
    app.commands.pooled = YES;
    [app.window.contentView setNeedsDisplay:YES];
    
    [NSApp runModalForWindow: self.view.window];

}

- (IBAction)OKButtonPressed:(id)sender
{
    app.commands.startOfPool = [startStepper integerValue];
    app.commands.endOfPool = [endStepper integerValue];

    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{

    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
    
    app.commands.pooled = NO;
    [app.window.contentView setNeedsDisplay:YES];
}


- (IBAction)startStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:startStepper];
    app.commands.startOfPool = [startStepper integerValue];
    
    if (app.commands.endOfPool < app.commands.startOfPool)
    {
        app.commands.endOfPool = app.commands.startOfPool;
        [endStepper setIntegerValue:app.commands.endOfPool];
        NSString* endValueString = [NSString stringWithFormat:@"%ld",(long)app.commands.endOfPool];
        endValue.stringValue = endValueString;
    }
    
    NSString* startValueString = [NSString stringWithFormat:@"%ld",(long)app.commands.startOfPool];
    startValue.stringValue = startValueString;
    
    [app.window.contentView setNeedsDisplay:YES];
}

- (IBAction)endStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:endStepper];
    app.commands.endOfPool = [endStepper integerValue];

    if (app.commands.startOfPool > app.commands.endOfPool)
    {
        app.commands.startOfPool = app.commands.endOfPool;
        [startStepper setIntegerValue:app.commands.startOfPool];
        NSString* startValueString = [NSString stringWithFormat:@"%ld",(long)app.commands.startOfPool];
        startValue.stringValue = startValueString;
    }
    
    NSString* endValueString = [NSString stringWithFormat:@"%ld",(long)app.commands.endOfPool];
    endValue.stringValue = endValueString;
    
    [app.window.contentView setNeedsDisplay:YES];
}

@end
