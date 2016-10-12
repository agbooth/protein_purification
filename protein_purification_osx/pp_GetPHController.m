//
//  pp_GetPHController.m
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetPHController.h"
#import "pp_AppDelegate.h"

@interface pp_GetPHController () {
    
    float saturation;
    
}

@end

@implementation pp_GetPHController

@synthesize value;
@synthesize stepper;
@synthesize thisPanel;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize image;
@synthesize pH;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_GetPHController" owner: self];
    
    [self.view.window makeFirstResponder:stepper];
    
    value.backgroundColor = [NSColor clearColor];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    pH = [stepper floatValue];
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    pH = -1;
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}



- (IBAction)stepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:stepper];
    NSString* valueString = [NSString stringWithFormat:@"%.1f",[stepper floatValue]];
    value.stringValue = valueString;
}

- (float) getpH
{
    return pH;
}


@end
