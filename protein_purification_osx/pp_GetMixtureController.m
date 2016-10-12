//
//  pp_GetMixtureController.m
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_GetMixtureController.h"
#import "pp_AppDelegate.h"

@interface pp_GetMixtureController () {
    
    NSInteger selection;
    
}

@end

@implementation pp_GetMixtureController
@synthesize thisPanel;
@synthesize image;
@synthesize scrollView;
@synthesize tableView;
@synthesize OKButton;
@synthesize CancelButton;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_GetMixtureController" owner: self];
    
    
    [self.view.window makeFirstResponder:scrollView];
        
    [image setImage:[NSApp applicationIconImage]];
    
    // Preselect the first entry
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    
    
    [self.view.window setBackgroundColor:app.bgColor];
    
    [NSApp runModalForWindow: self.view.window];

}

- (IBAction)OKButtonClicked:(id)sender
{
    selection = [tableView selectedRow];
    [self.view.window orderOut:sender];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonClicked:(id)sender
{
    selection = -1;
    [self.view.window orderOut:sender];
    [self.view.window close];
    [NSApp stopModal];
}

- (NSInteger) getSelection
{
    return selection;
}

#pragma NSTableViewDataSource methods

// Provides the NSStrings for the rows
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    switch (rowIndex)
    {
        case 0: return @"Default Mixture";
        case 1: return @"Easy3 Mixture";
        case 2: return @"Example Mixture";
        case 3: return @"Complex Mixture";
        default: return Nil;
    }
    
}

// Number of rows in the NSTable (The number of colums is set when the NSTable is created)ƒ.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return 4;
}

#pragma NSTableViewDelegate method

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    // Don't allow any cells to be editable
    return NO;
}
@end
