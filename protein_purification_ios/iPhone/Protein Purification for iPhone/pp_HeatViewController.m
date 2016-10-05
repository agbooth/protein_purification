//
//  pp_HeatViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_HeatViewController.h"


@implementation pp_HeatViewController

- (void) loadView
{
    self.view = [[pp_HeatView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
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
    [app.commands doHeatTreatment:((pp_HeatView*)self.view).heatFloatValue time:((pp_HeatView*)self.view).timeFloatValue];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}




@end
