//
//  pp_ASDialogController.m
//  Protein Purification
//
//  Created by Andrew Booth on 27/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_ASDialogController.h"
#import "pp_AppDelegate.h"

@interface pp_ASDialogController () {
    
    float saturation;
    
}

@end

@implementation pp_ASDialogController
@synthesize value;
@synthesize box;
@synthesize stepper;
@synthesize thisPanel;
@synthesize HelpButton;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize image;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_ASDialogController" owner: self];
   
    [self.view.window makeFirstResponder:stepper];
    
    value.backgroundColor = [NSColor clearColor];
    
    [box setBoxType:NSBoxPrimary];
    [box setBorderType:NSGrooveBorder];

    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    saturation = [stepper floatValue];
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    saturation = -1;
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)HelpButtonPressed:(id)sender
{
    [self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"ammonium_sulfate"  inBook:locBookName];
}

- (IBAction)stepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:stepper];
    NSString* valueString = [NSString stringWithFormat:@"%ld",(long)[stepper integerValue]];
    value.stringValue = valueString;
}

- (float) getSaturation
{
    return saturation;
}
@end
