//
//  pp_GetFractionController.h
//  Protein Purification
//
//  Created by Andrew Booth on 05/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetFractionController : NSViewController
{
	NSPanel *thisPanel;
	NSTextField *label;
	NSTextField *value;
	NSStepper *stepper;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSImageView *image;
	NSInteger fraction;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet NSTextField *value;
@property (assign) IBOutlet NSStepper *stepper;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSImageView *image;
@property (nonatomic) NSInteger fraction;

- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;

- (IBAction)stepperDidChange:(id)sender;

- (void)showDialog;
- (NSInteger) getNoOfFractions;

@end
