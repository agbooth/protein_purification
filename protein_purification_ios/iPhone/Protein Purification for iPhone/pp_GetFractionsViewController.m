//
//  pp_GetFractionsViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_GetFractionsViewController.h"


@implementation pp_GetFractionsViewController {

pp_GelViewController* gelVC;
UIBarButtonItem* rightButton;
UILabel* fractionLabel;
UIButton* addButton;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        app.commands.pooled = YES;  // needed if the fraction is to be indicated on the elution view
        gelVC = nil;
        rightButton = nil;
        fractionLabel = nil;
        addButton = nil;
    }
    return self;
}

- (void) loadView
{
    
    self.view = [[pp_GetFractionsView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
       
    
    self.title = NSLocalizedString(@"Fractions", @"");
    
    app.commands.frax = nil;
    app.commands.frax = [[NSMutableArray alloc] init];
    
    fractionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 145, 100, 70)];
    fractionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    fractionLabel.textColor = [UIColor blackColor];
    fractionLabel.backgroundColor = [UIColor clearColor];
    fractionLabel.textAlignment = NSTextAlignmentCenter;
        
    fractionLabel.numberOfLines = 4;
    [self.view addSubview:fractionLabel];
        
    //fractionLabel.text = NSLocalizedString(@"You can select up\nto 15 fractions.",@"");
    
    addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.frame = CGRectMake(38,113,100,30);
    [addButton addTarget:self
                  action:@selector(addButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:addButton];
}
/*
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    for (UIView *v in [self.view subviews]){
        [v removeFromSuperview];
    }
    
}
*/
- (void) addButtonPressed
{
    int fraction = ((pp_GetFractionsView*)self.view).fractionValue;
    
    // Don't allow duplicates
    for (int i=0; i<app.commands.frax.count; i++)
    {
        if (((NSNumber*)[app.commands.frax objectAtIndex:i]).integerValue == fraction)
            return;
    }
    
    [app.commands.frax addObject:[NSNumber numberWithInt:fraction]];
    if (app.commands.frax.count == 1)
    {
         
        fractionLabel.text = NSLocalizedString(@"You have added\none fraction.",@"");
        rightButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done",@"")
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(sortFractionsAndGo)];
         
         self.navigationItem.rightBarButtonItem = rightButton;
    }
    if (app.commands.frax.count > 1)
    {
        fractionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"You have added\n%d fractions.",@""),app.commands.frax.count];
    }
    if (app.commands.frax.count == 15)
    {
        [addButton removeFromSuperview];
    }
}

- (void) sortFractionsAndGo
{
    app.commands.pooled = NO; // must put it back or the gel will show pooled fractions
    
    // Sort the fractions into ascending order
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [app.commands.frax sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];

    app.commands.oneDshowing = YES;
    app.commands.twoDshowing = NO;
    
    
    UINavigationController* nav = (UINavigationController*)[app.splitViewController detailViewController];
    
    bool alreadyShowing = [nav.topViewController isKindOfClass:[pp_GelViewController class]];
    
    if (alreadyShowing)
        gelVC = (pp_GelViewController*)nav.topViewController;
    else
    {
        gelVC = [[pp_GelViewController alloc] initWithNibName:nil bundle:nil];
        gelVC.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        [nav pushViewController:gelVC animated:YES];
    }
    ((pp_GelView*)gelVC.view).twoDGel = NO;
    gelVC.title = NSLocalizedString(@"1D - PAGE",@"");
    
    nav = (UINavigationController*)[app.splitViewController masterViewController];
    [nav popViewControllerAnimated:NO];// Must not be animating when we hide the master view.
    
    [gelVC hideMasterView];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


@end
