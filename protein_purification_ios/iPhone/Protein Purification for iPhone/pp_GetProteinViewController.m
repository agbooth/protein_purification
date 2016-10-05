//
//  pp_GetProteinViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_GetProteinViewController.h"


@implementation pp_GetProteinViewController

- (void) loadView
{
    self.view = [[pp_GetProteinView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: NSLocalizedString(@"Done",@"")
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(setValueAndGo)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = NSLocalizedString(@"Protein", @"");
}





- (void) setValueAndGo
{
   // [(pp_SplashViewController*)app.detailViewController hideMaster];
    
    
    // Get the enzyme value (i.e. the number of the selected protein).
    pp_ProteinData* proteinData = app.proteinData;
    int enzyme = proteinData.enzyme;
    // Get its data.
    pp_Protein* protein = [proteinData.Proteins objectAtIndex:enzyme];
    
    // Present the stability data.
    NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Stability Data",@""),
                         enzyme,
                         protein.temp,
                         protein.pH1,
                         protein.pH2
                         ];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Stability",@"")
                                                    message:message delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Purify",@"")
                                          otherButtonTitles:NSLocalizedString(@"Cancel",@""),nil];
    [alert show];
    
}

- (void) changeToMainViewController
{
  
    [(pp_SplashViewController*)app.splitViewController.delegate changeToMainViewController];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - AlertView

 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
     if (buttonIndex == 0)
 
     { 
         [self changeToMainViewController]; 
     }
 
 }
@end
