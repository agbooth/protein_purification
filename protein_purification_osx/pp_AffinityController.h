//
//  pp_AffinityController.h
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_AffinityController : NSViewController
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSTextField *ligandLabel;
	NSTextField *elutionLabel;
	NSMatrix *ligandGroup;
	NSMatrix *elutionGroup;
	NSButtonCell *monoclonalA_;
	NSButtonCell *monoclonalB_;
	NSButtonCell *monoclonalC_;
	NSButtonCell *polyclonal_;
	NSButtonCell *immob_inhibitor_;
	NSButtonCell *nickel_;
	NSButtonCell *Tris_;
	NSButtonCell *glycine_;
	NSButtonCell *inhibitor_;
	NSButtonCell *imidazole_;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
	
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextField *ligandLabel;
@property (assign) IBOutlet NSTextField *elutionLabel;
@property (assign) IBOutlet NSMatrix *ligandGroup;
@property (assign) IBOutlet NSMatrix *elutionGroup;
@property (assign) IBOutlet NSButtonCell *monoclonalA_;
@property (assign) IBOutlet NSButtonCell *monoclonalB_;
@property (assign) IBOutlet NSButtonCell *monoclonalC_;
@property (assign) IBOutlet NSButtonCell *polyclonal_;
@property (assign) IBOutlet NSButtonCell *immob_inhibitor_;
@property (assign) IBOutlet NSButtonCell *nickel_;
@property (assign) IBOutlet NSButtonCell *Tris_;
@property (assign) IBOutlet NSButtonCell *glycine_;
@property (assign) IBOutlet NSButtonCell *inhibitor_;
@property (assign) IBOutlet NSButtonCell *imidazole_;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;

- (IBAction)CancelButtonClicked:(id)sender;
- (IBAction)HelpButtonClicked:(id)sender;
- (IBAction)OKButtonClicked:(id)sender;
- (IBAction)ligandGroupClicked:(id)sender;
- (IBAction)elutionGroupClicked:(id)sender;

- (void) showDialog;
- (NSInteger) getLigand;
- (NSInteger) getElution;

@end
