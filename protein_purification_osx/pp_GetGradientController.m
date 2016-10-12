//
//  pp_GetGradientController.m
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetGradientController.h"
#import "pp_AppDelegate.h"

@interface pp_GetGradientController () {
    
    float start;
    float end;
    
}

@end

@implementation pp_GetGradientController

@synthesize thisPanel;
@synthesize startValue;
@synthesize endValue;
@synthesize startStepper;
@synthesize endStepper;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize image;
@synthesize startLabel;
@synthesize endLabel;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_GetGradientController" owner: self];
    
        
    [self.view.window makeFirstResponder:startStepper];
    
    startLabel.backgroundColor = [NSColor clearColor];
    startLabel.stringValue = NSLocalizedString(@"Start of gradient:",@"");
    
    endLabel.backgroundColor = [NSColor clearColor];
    endLabel.stringValue = NSLocalizedString(@"End of gradient:",@"");
    
    if (app.commands.sepType == Hydrophobic_interaction)
    {
        [self.view.window setTitle:NSLocalizedString(@"Gradient limits (molar)",@"")];
        
        startValue.stringValue = @"2.0";
        startStepper.minValue = 0.0;
        startStepper.maxValue = 3.0;
        startStepper.increment = 0.1;
        startStepper.doubleValue = 2.0;
        
        endValue.stringValue = @"0.0";
        endStepper.minValue = 0.0;
        endStepper.maxValue = 3.0;
        endStepper.increment = 0.1;
        endStepper.doubleValue = 0.0;
    }
    
    if (app.commands.sepType == Ion_exchange)
    {
        if (app.commands.gradientIsSalt)
        {
            [self.view.window setTitle:NSLocalizedString(@"Gradient limits (molar)",@"")];

            startValue.stringValue = @"0.0";
            startStepper.minValue = 0.0;
            startStepper.maxValue = 2.0;
            startStepper.increment = 0.1;
            startStepper.doubleValue = 0.0;
            
            endValue.stringValue = @"0.5";
            endStepper.minValue = 0.0;
            endStepper.maxValue = 2.0;
            endStepper.increment = 0.1;
            endStepper.doubleValue = 0.5;
            
        }
        else
        {
            [self.view.window setTitle:NSLocalizedString(@"Gradient limits (pH)",@"")];

            startValue.stringValue = @"7.0";
            startStepper.minValue = 2.0;
            startStepper.maxValue = 11.0;
            startStepper.increment = 0.1;
            startStepper.doubleValue = 7.0;
            
            endValue.stringValue = @"7.0";
            endStepper.minValue = 2.0;
            endStepper.maxValue = 11.0;
            endStepper.increment = 0.1;
            endStepper.doubleValue = 7.0;
        }
    
    }
    
    [image setImage:[NSApp applicationIconImage]];
    [OKButton setTitle:NSLocalizedString(@"OK",@"")];
    [CancelButton setTitle:NSLocalizedString(@"Cancel",@"")];

    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    start = [startStepper floatValue];
    end = [endStepper floatValue];
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    start = -1;
    end = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}



- (IBAction)startStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:startStepper];
    NSString* startValueString = [NSString stringWithFormat:@"%.1f",[startStepper floatValue]];
    startValue.stringValue = startValueString;
}

- (IBAction)endStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:endStepper];
    NSString* endValueString = [NSString stringWithFormat:@"%.1f",[endStepper floatValue]];
    endValue.stringValue = endValueString;
}

- (float) getStart
{
    return start;
}

- (float) getEnd
{
    return end;
}


@end
