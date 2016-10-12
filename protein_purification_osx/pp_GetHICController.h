//
//  pp_GetHICController.h
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetHICController : NSViewController
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSMatrix *radioGroup;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSMatrix *radioGroup;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;

@property (nonatomic) int selection;

- (IBAction)OKButtonClicked:(id)sender;
- (IBAction)CancelButtonClicked:(id)sender;
- (IBAction)HelpButtonClicked:(id)sender;


- (IBAction)radioClicked:(id)sender;

- (void) showDialog;

- (NSInteger) getSelection;
@end
