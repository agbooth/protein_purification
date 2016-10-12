//
//  pp_GetFractionsController.m
//  Protein Purification
//
//  Created by Andrew Booth on 05/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetFractionsController.h"
#import "pp_AppDelegate.h"

@interface pp_GetFractionsController ()

@end

@implementation pp_GetFractionsController
@synthesize label;
@synthesize message;
@synthesize value;
@synthesize stepper;
@synthesize thisPanel;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize AddButton;
@synthesize image;
@synthesize fraction;

- (void)showDialog
{
    [NSBundle loadNibNamed: @"pp_GetFractionsController" owner: self];
    
    [self.view.window makeFirstResponder:stepper];
    
    [thisPanel setTitle:NSLocalizedString(@"1D - PAGE",@"")];
    
    label.stringValue = NSLocalizedString(@"You can select up to 15 fractions.",@"");
    message.stringValue = @"";
    
    [OKButton setTitle:NSLocalizedString(@"OK",@"")];
    [OKButton setEnabled:NO];
    [CancelButton setTitle:NSLocalizedString(@"Cancel",@"")];
    [AddButton setTitle:NSLocalizedString(@"Add",@"")];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [app.commands.frax removeAllObjects];
    
    app.commands.noOfFractions = 0;
    fraction = 60;
    app.commands.startOfPool = 60;
    app.commands.endOfPool = 60;
    app.commands.pooled = YES;
    
    [app.window.contentView setNeedsDisplay:YES];
    
    [NSApp runModalForWindow: self.view.window];
}

- (IBAction)OKButtonPressed:(id)sender
{
    fraction = (int)app.commands.frax.count;
    
    // Sort the fractions into ascending order
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [app.commands.frax sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];

    
    [self.view.window orderOut:nil];
    [self.view.window close];
    
    app.commands.pooled = NO;
    [app.window.contentView setNeedsDisplay:YES];    
    [NSApp stopModal];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    fraction = -1;
    
    [self.view.window orderOut:nil];
    [self.view.window close];
    
    app.commands.pooled = NO;
    [app.window.contentView setNeedsDisplay:YES];
    
    [NSApp stopModal];
}

- (IBAction)AddButtonPressed:(id)sender
{
    [app.commands.frax addObject:[NSNumber numberWithInteger:fraction]];
    
    if (app.commands.frax.count == 1)
    {
        
        message.stringValue = NSLocalizedString(@"You have added one fraction.",@"");
        [OKButton setEnabled:YES];

    }
    if (app.commands.frax.count > 1)
    {
        message.stringValue = [NSString stringWithFormat:NSLocalizedString(@"You have added %d fractions.",@""),app.commands.frax.count];
    }

    [AddButton setEnabled:NO];
  
}

- (IBAction)stepperDidChange:(id)sender
{
    [self.view.window makeFirstResponder:stepper];
    fraction = [stepper integerValue];
    NSString* valueString = [NSString stringWithFormat:@"%ld",fraction];
    value.stringValue = valueString;
    app.commands.startOfPool = fraction;
    app.commands.endOfPool = fraction;
    
    if (app.commands.frax.count < 15)
        [AddButton setEnabled:YES];
    // Don't allow duplicates
    for (int i=0; i<app.commands.frax.count; i++)
    {
        if ((long)((NSNumber*)[app.commands.frax objectAtIndex:i]).integerValue == fraction)
        {
            // The fraction has already been added - disable the Add button.
            [AddButton setEnabled:NO];
        }
    }
        
    [app.window.contentView setNeedsDisplay:YES];}

- (NSInteger) getNoOfFractions
{
    return fraction;
}

@end
