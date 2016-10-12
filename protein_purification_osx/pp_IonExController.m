//
//  pp_IonExController.m
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_IonExController.h"
#import "pp_AppDelegate.h"

@interface pp_IonExController () {
    
    NSInteger selection;
    
}

@end

@implementation pp_IonExController
@synthesize thisPanel;
@synthesize image;
@synthesize mediaGroup;
@synthesize elutionGroup;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize HelpButton;
@synthesize mediumSelected;
@synthesize elutionSelected;
@synthesize medium;
@synthesize gradientIsSalt;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_IonExController" owner: self];
    
    [self.view.window makeFirstResponder:mediaGroup];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    mediumSelected = NO;
    elutionSelected = NO;
    gradientIsSalt = NO;
    
    [NSApp runModalForWindow: self.view.window];
}


- (IBAction)mediaGroupChanged:(id)sender
{
    [self.view.window makeFirstResponder:mediaGroup];
    mediumSelected = YES;
    if (mediumSelected && elutionSelected) [OKButton setEnabled:YES];
    medium = [mediaGroup selectedRow] + DEAE_cellulose;
}

- (IBAction)elutionGroupChanged:(id)sender
{
    [self.view.window makeFirstResponder:elutionGroup];
    elutionSelected = YES;
    if (mediumSelected && elutionSelected) [OKButton setEnabled:YES];
    if ([elutionGroup selectedRow] == 1) gradientIsSalt = NO;
    else gradientIsSalt = YES;
}

- (IBAction)OKButtonPressed:(id)sender
{
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    medium = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)HelpButtonPressed:(id)sender
{
    [self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"ion_exchange"  inBook:locBookName];
}

- (NSInteger) getMedium
{
    return medium;
}
@end
