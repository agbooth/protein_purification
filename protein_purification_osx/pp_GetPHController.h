//
//  pp_GetPHController.h
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetPHController : NSViewController
{
	NSPanel *thisPanel;
	NSTextField *value;
	NSStepper *stepper;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSImageView *image;
	float pH;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSTextField *value;
@property (assign) IBOutlet NSStepper *stepper;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSImageView *image;
@property (nonatomic) float pH;


- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)stepperDidChange:(id)sender;

- (void)showDialog;
- (float) getpH;

@end
