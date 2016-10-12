//
//  pp_ASChoiceController.h
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_ASChoiceController : NSViewController
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSTextField *label;
	NSMatrix *radioGroup;
	NSButton *OKButton;
	NSButton *CancelButton;
	
	float enz_prec;
	float prot_prec;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet NSMatrix *radioGroup;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;

@property (nonatomic) float enz_prec;
@property (nonatomic) float prot_prec;

- (IBAction)OKButtonClicked:(id)sender;
- (IBAction)CancelButtonClicked:(id)sender;


- (IBAction)radioClicked:(id)sender;

- (void) showDialog;

- (NSInteger) getSelection;

@end
