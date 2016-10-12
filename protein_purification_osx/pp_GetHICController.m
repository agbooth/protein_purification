//
//  pp_GetHICController.m
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetHICController.h"
#import "pp_AppDelegate.h"

@interface pp_GetHICController ()

@end

@implementation pp_GetHICController
@synthesize thisPanel;
@synthesize image;
@synthesize radioGroup;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize HelpButton;
@synthesize selection;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_GetHICController" owner: self];
    
    [self.view.window makeFirstResponder:radioGroup];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)radioClicked:(id)sender
{
    [self.view.window makeFirstResponder:radioGroup];
    [OKButton setEnabled:YES];
}

- (IBAction)OKButtonClicked:(id)sender
{
    selection = [radioGroup selectedRow]+Phenyl_Sepharose;
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

- (IBAction)HelpButtonClicked:(id)sender
{
    [self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"hic"  inBook:locBookName];
}

- (NSInteger) getSelection
{
    return selection;
}

@end
