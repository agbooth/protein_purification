//
//  pp_GetMixtureController.h
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetMixtureController : NSViewController <NSTableViewDataSource,NSTableViewDelegate>
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSScrollView *scrollView;
	NSTableView *tableView;
	NSButton *OKButton;
	NSButton *CancelButton;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;

- (IBAction)OKButtonClicked:(id)sender;
- (IBAction)CancelButtonClicked:(id)sender;

- (void) showDialog;
- (NSInteger) getSelection;
@end
