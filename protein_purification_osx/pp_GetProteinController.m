//
//  pp_GetProteinController.m
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetProteinController.h"
#import "pp_AppDelegate.h"

@interface pp_GetProteinController () {
    
    NSInteger selection;
    
}

@end

@implementation pp_GetProteinController

@synthesize thisPanel;
@synthesize image;
@synthesize message;
@synthesize combo;
@synthesize OKButton;
@synthesize CancelButton;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_GetProteinController" owner: self];
    
    [self.view.window makeFirstResponder:combo];
    
    message.stringValue = [NSString stringWithFormat:NSLocalizedString(@"This mixture contains...", @""), app.proteinData.noOfProteins];
    
    [image setImage:[NSApp applicationIconImage]];
    
    for (int i = 1; i <= app.proteinData.noOfProteins; i++)
    {
        [combo addItemWithObjectValue:[NSString stringWithFormat:@"%d",i]];
    }
    [combo selectItemAtIndex:0];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    selection = [combo indexOfSelectedItem] + 1;
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

- (NSInteger) getSelection
{
    return selection;
}

#pragma NSControlTextEditingDelegate method
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    return NO;
}
@end
