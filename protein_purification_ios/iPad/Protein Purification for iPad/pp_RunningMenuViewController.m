//
//  pp_RunningMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_RunningMenuViewController.h"
#import "pp_Commands.h"

@interface pp_RunningMenuViewController ()

@end

@implementation pp_RunningMenuViewController {

pp_GelFiltMenuViewController* gfmvc;
pp_IonExchMenuViewController* iemvc;
pp_HICMenuViewController* himvc;
pp_AffMediaMenuViewController* ammvc;
pp_GetPoolViewController* gpvc;
pp_GelViewController* gelVC;
pp_GetFractionViewController* gfvc;
pp_GetFractionsViewController* gfsvc;

UIAlertView* alert1;
UIAlertView* alert2;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        gfmvc = nil;
        iemvc = nil;
        himvc = nil;
        ammvc = nil;
        gpvc = nil;
        gelVC = nil;
        gfvc = nil;
        gfsvc = nil;
        alert1 = nil;
        alert2 = nil;
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // switch off the elastic
    [self.tableView setBounces:NO];
    self.tableView.contentMode = UIViewContentModeRedraw;
    
    self.title = NSLocalizedString(@"Methods",@"");

//DEBUGGING ONLY
//--------------------
//app.commands.hasFractions = YES;
//app.commands.pooled = NO;
//--------------------
}

- (void)viewWillAppear:(BOOL)animated
{    

    if (app.commands.hasFractions)
    {
        // Make sure that the pool is not shown if the user cancels pooling.
        app.commands.pooled = NO;
        [((UIViewController*)app.splitViewController.delegate).view setNeedsDisplay];
    }
    [self.tableView reloadData];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    [super viewWillAppear:animated];

}


- (void) abandonScheme
{
    pp_SplashViewController* splashVC = [[pp_SplashViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    UINavigationController* detailNC = [app.splitViewController.viewControllers objectAtIndex:1];
    [detailNC setViewControllers:[NSArray arrayWithObject:splashVC] animated:YES];
    [app.splitViewController setDelegate:splashVC];
    
    // If the master view is showing, hide it
    if (app.splitViewController.isShowingMaster)
        [app.splitViewController toggleMasterView:self];
    
    // Change the master View Controller
    pp_GetMixtureController* gmVC = [[pp_GetMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* masterNC = [app.splitViewController.viewControllers objectAtIndex:0];
    [masterNC setViewControllers:[NSArray arrayWithObject:gmVC] animated:YES];
    
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Electrophoresis",@"");
                break;
        
        case 1:
            if (app.commands.oneDshowing  || app.commands.twoDshowing)
                header = nil;
            else
                header =  NSLocalizedString(@"Manage fractions",@"");
            break;
        
        case 2: header = NSLocalizedString(@"Manage scheme",@"");
            break;
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        
    // Return the number of rows in the section.
    switch (section)
    {
        case 0: return 2;
        
        case 1:
     
            if (app.commands.oneDshowing || app.commands.twoDshowing)
            return 0;

            return 3;
        
        case 2: return 2;
                
        
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //defaults
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.alpha = 1.0;
    cell.userInteractionEnabled = YES;

    switch (indexPath.section)
    {
            
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            switch (indexPath.row)
            {
                case 0:
                    
                    cell.textLabel.text = NSLocalizedString(@"1-dimensional PAGE",@"");
                    break;
                
                case 1:
                    
                    cell.textLabel.text = NSLocalizedString(@"2-dimensional PAGE",@"");
                    break;
                
            }
            
            break;
            
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Assay enzyme activity",@"");
                    cell.accessoryType = UITableViewCellAccessoryNone;
                                        
                    if (app.commands.assayed)  // disable the cell
                    {
                        cell.textLabel.alpha = 0.439216f;
                        cell.userInteractionEnabled = NO;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Dilute fractions x2",@"");
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    if (app.commands.overDiluted)  // disable the cell
                    {
                        cell.textLabel.alpha = 0.439216f;
                        cell.userInteractionEnabled = NO;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                
                case 2: cell.textLabel.text = NSLocalizedString(@"Pool fractions",@"");
                    break;
                
            }
            break;
            
        case 2:
        {
            
            switch (indexPath.row)
            {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Abandon this step and continue",@"");
                    break;
            
                case 1:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Abandon scheme and start again",@"");
                    break;
                
            }
            break;
        }
    }
     
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
            
        case 0:
        {
            
            app.commands.comingFromHelp = NO;  // Needs to be reset as it might have been set during a previous Help
            
            UINavigationController* nav = (UINavigationController*)[app.splitViewController.viewControllers objectAtIndex:1];
            
            bool alreadyShowing = [nav.topViewController isKindOfClass:[pp_GelViewController class]];

            switch (indexPath.row)
            {
                case 0:
                    if (alreadyShowing)
                    {

                        app.commands.oneDshowing = YES;
                        app.commands.twoDshowing = NO;

                        [self.tableView reloadData];        
                        [nav popViewControllerAnimated:YES];
                    }
                    gfsvc = [[pp_GetFractionsViewController alloc] init];
                    gfsvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                    [self.navigationController pushViewController: gfsvc animated:YES];
                    
                    break;
                    
                case 1:
                    
                    if (alreadyShowing)
                    {

                        app.commands.oneDshowing = NO;
                        app.commands.twoDshowing = YES;
                        [gelVC changeto2DPage];
                        
                        [self.tableView reloadData];
                        [nav popViewControllerAnimated:YES];
                    }

                    gfvc = [[pp_GetFractionViewController alloc] init];
                    gfvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                    [self.navigationController pushViewController: gfvc animated:YES];
                
                    break;
                
            }
        
            break;
        }
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    [app.commands doEnzymeAssay];
                    [self.tableView reloadData];
                    // If the master view is showing, hide it in portrait
                    if (app.splitViewController.isShowingMaster  && !app.splitViewController.isLandscape)
                        [app.splitViewController toggleMasterView:self];
                    break;
                    
                case 1:
                    [app.commands doDiluteFractions];
                    [self.tableView reloadData];
                    // If the master view is showing, hide it in portrait
                    if (app.splitViewController.isShowingMaster  && !app.splitViewController.isLandscape)
                        [app.splitViewController toggleMasterView:self];
                    break;
                    
                case 2:
                    gpvc = [[pp_GetPoolViewController alloc] init];
                    gpvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                    [self.navigationController pushViewController: gpvc animated:YES];

                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    // Abandon this step
                    alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Abandon step",@"")
                                                    message:NSLocalizedString(@"Abandon step warning",@"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No",@"")
                                          otherButtonTitles:NSLocalizedString(@"Yes",@""),nil];
                    [alert1 show];
                    break;
               
                case 1:
                    // Abandon scheme
                    alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Abandon scheme",@"")
                                                                message:NSLocalizedString(@"Abandon warning",@"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"No",@"")
                                                      otherButtonTitles:NSLocalizedString(@"Yes",@""),nil];
                    [alert2 show];
                    break;
                    
                            }
            
            break;
    }
    
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.tableView reloadData];
        return;
    }
    if ((alertView == alert1) && (buttonIndex == 1))
    {
        // Abandon step
        app.commands.assayed = NO;
        [app.commands resetRunningMenu];
    }
    
    if ((alertView == alert2) && (buttonIndex == 1))
    {
        // Abandon scheme
        [self abandonScheme];
    }
    
    
    
}

@end
