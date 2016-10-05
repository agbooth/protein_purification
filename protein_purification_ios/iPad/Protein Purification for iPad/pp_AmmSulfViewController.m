//
//  pp_AmmSulfViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_AmmSulfViewController.h"


@implementation pp_AmmSulfViewController

- (void) loadView
{   
    self.view = [[pp_AmmSulfView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];

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
    [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];
}


- (void) setValueAndGo
{
   
    [app.commands doAmmoniumSulfate:((pp_AmmSulfView*)self.view).ammsulfFloatValue];
    NSString* message = [app.commands checkASPrecipitate];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ammonium sulfate",@"")
                                                    message:message delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                          otherButtonTitles:
                                            NSLocalizedString(@"Use the precipitated material",@""),
                                            NSLocalizedString(@"Use the soluble material",@"")
                                            ,nil];
    
    [alert show];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [app.commands finishAmmoniumSulfate: buttonIndex];    
}


@end
