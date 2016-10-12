//
//  pp_AffinityController.m
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import "pp_AffinityController.h"
#import "pp_AppDelegate.h"

@interface pp_AffinityController ()

@end

@implementation pp_AffinityController
@synthesize thisPanel;
@synthesize image;
@synthesize ligandLabel;
@synthesize elutionLabel;
@synthesize ligandGroup;
@synthesize elutionGroup;
@synthesize monoclonalA_;
@synthesize monoclonalB_;
@synthesize monoclonalC_;
@synthesize polyclonal_;
@synthesize immob_inhibitor_;
@synthesize nickel_;
@synthesize Tris_;
@synthesize glycine_;
@synthesize inhibitor_;
@synthesize imidazole_;
@synthesize OKButton;
@synthesize CancelButton;
@synthesize HelpButton;

NSInteger ligand;
NSInteger elution;
Boolean ligandSelected;
Boolean elutionSelected;

- (void) showDialog
{
    [NSBundle loadNibNamed: @"pp_AffinityController" owner: self];
    
    [self.view.window makeFirstResponder:ligandGroup];
    
    [image setImage:[NSApp applicationIconImage]];
    
    [self.view.window setBackgroundColor:app.bgColor];
    [self.thisPanel setTitle:NSLocalizedString(@"Affinity chromatography",@"")];
    
    ligandLabel.stringValue = NSLocalizedString(@"Ligand:",@"");
    elutionLabel.stringValue = NSLocalizedString(@"Elute with:",@"");
    
    monoclonalA_.title = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01A",@""), app.proteinData.enzyme];
    monoclonalB_.title = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01B",@""), app.proteinData.enzyme];
    monoclonalC_.title = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01C",@""), app.proteinData.enzyme];
    polyclonal_.title = NSLocalizedString(@"immobilized polyclonal IgG",@"");
    immob_inhibitor_.title = NSLocalizedString(@"immobilized competitive inhibitor",@"");
    nickel_.title = NSLocalizedString(@"Ni-NTA agarose",@"");
    Tris_.title = NSLocalizedString(@"2mM-Tris/HCl pH 7.4",@"");
    glycine_.title = NSLocalizedString(@"0.2M-glycine/HCl pH 2.3",@"");
    inhibitor_.title = NSLocalizedString(@"5mM-competitive inhibitor",@"");
    imidazole_.title = NSLocalizedString(@"150mM-imidazole, 300mM-NaCl pH 7.0",@"");
    
    [OKButton setTitle:NSLocalizedString(@"OK",@"")];
    [CancelButton setTitle:NSLocalizedString(@"Cancel",@"")];
    

    
    ligandSelected = NO;
    elutionSelected = NO;
    
    [NSApp runModalForWindow: self.view.window];
}


- (IBAction)ligandGroupClicked:(id)sender
{
    ligandSelected = YES;
    if (ligandSelected && elutionSelected) [OKButton setEnabled:YES];
    ligand = [ligandGroup selectedRow] + AntibodyA;
}

- (IBAction)elutionGroupClicked:(id)sender
{
    elutionSelected = YES;
    if (ligandSelected && elutionSelected) [OKButton setEnabled:YES];
    elution = [elutionGroup selectedRow] + Tris;
}

- (IBAction)OKButtonClicked:(id)sender
{
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)CancelButtonClicked:(id)sender
{
    ligand = -1;
    [self.view.window orderOut:nil];
    [self.view.window close];
    [NSApp stopModal];
}

- (IBAction)HelpButtonClicked:(id)sender
{
	[self.view.window makeFirstResponder:HelpButton];
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"affinity"  inBook:locBookName];
}

- (NSInteger) getLigand
{
    return ligand;
}

- (NSInteger) getElution
{
    return elution;
}

@end
