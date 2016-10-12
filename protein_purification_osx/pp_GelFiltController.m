//
//  pp_GelFiltController.m
//  Protein Purification
//
//  Created by Andrew Booth on 02/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GelFiltController.h"
#import "pp_AppDelegate.h"

@interface pp_GelFiltController () {
    
    NSInteger selection;
    
}

@end

@implementation pp_GelFiltController
@synthesize thisPanel;
@synthesize image;
@synthesize box;
@synthesize radioGroup;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize HelpButton;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_GelFiltController" owner: self];
    
    [self.view.window makeFirstResponder:radioGroup];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [box setBoxType:NSBoxPrimary];
    [box setBorderType:NSGrooveBorder];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)radioGroupChanged:(id)sender
{
    [self.view.window makeFirstResponder:radioGroup];
    [OKButton setEnabled:YES];
}

- (IBAction)OKButtonPressed:(id)sender
{
    selection = [radioGroup selectedRow]+Sephadex_G50;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    selection = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)HelpButtonPressed:(id)sender
{
    [self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"gel_filtration"  inBook:locBookName];
}

- (NSInteger) getSelection
{
    return selection;
}


@end
