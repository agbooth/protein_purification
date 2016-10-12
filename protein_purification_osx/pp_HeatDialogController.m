//
//  pp_HeatDialogController.m
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_HeatDialogController.h"
#import "pp_AppDelegate.h"

@interface pp_HeatDialogController ()

@end

@implementation pp_HeatDialogController
@synthesize thisPanel;
@synthesize tempStepper;
@synthesize timeStepper;
@synthesize tempValue;
@synthesize timeValue;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize HelpButton;
@synthesize tempBox;
@synthesize timeBox;
@synthesize image;

float heatTemp;
float heatTime;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_HeatDialogController" owner: self];
    
    [self.view.window makeFirstResponder:tempStepper];
    
    tempValue.backgroundColor = [NSColor clearColor];
    timeValue.backgroundColor = [NSColor clearColor];
    
    [tempBox setBoxType:NSBoxPrimary];
    [tempBox setBorderType:NSGrooveBorder];
    [timeBox setBoxType:NSBoxPrimary];
    [timeBox setBorderType:NSGrooveBorder];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    heatTemp = [tempStepper floatValue];
    heatTime = [timeStepper floatValue];
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    heatTemp = -1;
    heatTime = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)HelpButtonPressed:(id)sender
{
    [self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"heat_treatment"  inBook:locBookName];
}

- (IBAction)tempStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:tempStepper];
    NSString* tempValueString = [NSString stringWithFormat:@"%ld",(long)[tempStepper integerValue]];
    tempValue.stringValue = tempValueString;
}

- (IBAction)timeStepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:timeStepper];
    NSString* timeValueString = [NSString stringWithFormat:@"%ld",(long)[timeStepper integerValue]];
    timeValue.stringValue = timeValueString;
}

- (float) getTemp
{
    return heatTemp;
}

- (float) getTime
{
    return heatTime;
}

@end
