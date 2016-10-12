//
//  pp_ASChoiceController.m
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_ASChoiceController.h"
#import "pp_AppDelegate.h"

@interface pp_ASChoiceController () {
    
    NSInteger selection;
    
}

@end

@implementation pp_ASChoiceController
@synthesize thisPanel;
@synthesize image;
@synthesize label;
@synthesize radioGroup;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize enz_prec;
@synthesize prot_prec;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_ASChoiceController" owner: self];
    
    [self.view.window makeFirstResponder:radioGroup];
    
    label.backgroundColor = [NSColor clearColor];
    label.stringValue = [NSString stringWithFormat:NSLocalizedString(@"AS Precipitation Question", @""), enz_prec, prot_prec];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}


- (IBAction)OKButtonClicked:(id)sender
{
    selection = [radioGroup selectedRow];
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonClicked:(id)sender
{
    selection = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)radioClicked:(id)sender
{
    [self.view.window makeFirstResponder:radioGroup];
    [OKButton setEnabled:YES];
}

- (NSInteger) getSelection
{
    return selection;
}
@end
