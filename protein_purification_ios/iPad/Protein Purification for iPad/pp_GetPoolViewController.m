//
//  pp_GetPoolViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_GetPoolViewController.h"

@implementation pp_GetPoolViewController

- (id)init
{
    self = [super init];
    if (self) {
        app.commands.pooled = YES;
        app.commands.startOfPool = 1;
        app.commands.endOfPool = 125;
    }
    return self;
}

- (void) loadView
{
    self.view = [[pp_GetPoolView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
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
   
    [app.commands doPoolFractions];
       
}

- (void) changeToMainViewController
{
  
    [(pp_SplashViewController*)app.splitViewController.delegate changeToMainViewController];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}




@end
