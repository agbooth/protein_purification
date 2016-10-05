//
//  pp_MainMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_MainMenuViewController.h"
#import "pp_Commands.h"


@interface pp_MainMenuViewController ()

@end

@implementation pp_MainMenuViewController {

pp_HeatViewController* hvc;
pp_AmmSulfViewController* asvc;
pp_GelFiltMenuViewController* gfmvc;
pp_IonExchMenuViewController* iemvc;
pp_HICMenuViewController* himvc;
pp_AffMediaMenuViewController* ammvc;
pp_GetPoolViewController* gpvc;
pp_GelViewController* gelVC;

UIAlertView* alert1;
UIAlertView* alert2;
UIAlertView* alert3;

NSString* filename;
NSString* filepath;
NSString* filedata;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        app.commands.oneDshowing = NO;
        app.commands.twoDshowing = NO;
        
        hvc = nil;
        asvc = nil;
        gfmvc = nil;
        iemvc = nil;
        himvc = nil;
        ammvc = nil;
        gpvc = nil;
        gelVC = nil;

        alert1 = nil;
        alert2 = nil;
        alert3 = nil;
        
        filename = nil;
        filepath = nil;
        filedata = nil;
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
    
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    
    // Unhighlight any highlighted buttons
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}



- (void) saveScheme
{
    NSFileManager* fm = [[NSFileManager alloc] init];
    
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    
    filepath = [docs stringByAppendingPathComponent:[filename stringByAppendingString:@".ppmixture"]];
 
    filedata = [app.proteinData writeMixture:app.account];

    BOOL exists = [fm fileExistsAtPath:filepath];
    
    if (exists)
    {
        alert3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(filename,@"")
                                            message:NSLocalizedString(@"A mixture with this name exists.\nDo you want to replace it?",@"")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"No",@"")
                                  otherButtonTitles:NSLocalizedString(@"Yes",@""),nil];
        [alert3 show];
    }
    else
        [self writeTheFile];
    
}

- (void) writeTheFile
{

    if (! [filedata writeToFile:filepath
                     atomically:NO
                       encoding:NSUTF8StringEncoding
                          error:nil])
    {
        alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(filename,@"")
                                            message:NSLocalizedString(@"Can't store the material.",@"")
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                  otherButtonTitles:nil];
        [alert1 show];
        
    }

}

- (void) abandonScheme
{
    pp_SplashViewController* splashVC = [[pp_SplashViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    UINavigationController* detailNC = (UINavigationController*)[app.splitViewController detailViewController];
    [detailNC setViewControllers:[NSArray arrayWithObject:splashVC] animated:YES];
    [app.splitViewController setDelegate:splashVC];
    
    // If the master view is showing, hide it
    if (app.splitViewController.isShowingMaster)
        [app.splitViewController toggleMasterView:self];
    
    // Change the master View COntroller
    pp_GetMixtureController* gmVC = [[pp_GetMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* masterNC = (UINavigationController*)[app.splitViewController masterViewController];
    [masterNC setViewControllers:[NSArray arrayWithObject:gmVC] animated:YES];
    
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: if (app.commands.oneDshowing  || app.commands.twoDshowing)
                    header = nil;
                else
                    header = NSLocalizedString(@"Separation methods",@"");
                break;
        
        case 1: header = NSLocalizedString(@"Electrophoresis",@"");
                break;
        
        case 2: header = NSLocalizedString(@"Manage scheme",@"");
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
        case 0: if (app.commands.oneDshowing || app.commands.twoDshowing)
            return 0;
            
                return 6;
        
        case 1: return 2;
        
       
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
            switch (indexPath.row)
            {
                case 0: cell.textLabel.text = NSLocalizedString(@"Ammonium sulfate fractionation",@""); break;
                
                case 1: cell.textLabel.text = NSLocalizedString(@"Heat treatment",@"");break;
                
                case 2: cell.textLabel.text = NSLocalizedString(@"Gel filtration",@"");
                    cell.textLabel.alpha = 1.0;
                    cell.userInteractionEnabled = YES;
                    break;
                    
                case 3: cell.textLabel.text = NSLocalizedString(@"Ion exchange chromatography",@"");
                    cell.textLabel.alpha = 1.0;
                    cell.userInteractionEnabled = YES;
                    break;
                    
                case 4: cell.textLabel.text = NSLocalizedString(@"Hydrophobic interaction chromatography",@"");break;
                    
                case 5: cell.textLabel.text = NSLocalizedString(@"Affinity chromatography",@"");break;
            }
            [cell.textLabel sizeToFit];
            break;
            
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            switch (indexPath.row)
            {
                case 0: cell.textLabel.text = NSLocalizedString(@"1-dimensional PAGE",@"");
                        if (app.commands.oneDshowing)  // disable the cell
                        {
                            cell.textLabel.alpha = 0.439216f;
                            cell.userInteractionEnabled = NO;
                            cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        }
                        break;
                    
                case 1: cell.textLabel.text = NSLocalizedString(@"2-dimensional PAGE",@"");
                    
                        if (app.commands.twoDshowing)  // disable the cell
                        {
                            cell.textLabel.alpha = 0.439216f;
                            cell.userInteractionEnabled = NO;
                            cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        }
                        break;
                
            }
            [cell.textLabel sizeToFit];
            break;
            
                
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Abandon scheme and start again",@"");
                    break;
        
            
                case 1:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Store your material",@"");
                    break;
            }
            [cell.textLabel sizeToFit];
            break;
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
            
            switch (indexPath.row)
            {
                    
                case 0:
                    asvc = [[pp_AmmSulfViewController alloc] init];
                    asvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                    [self.navigationController pushViewController: asvc animated:YES];
                    break;
                    
                case 1:
                    hvc = [[pp_HeatViewController alloc] init];
                    hvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                    [self.navigationController pushViewController: hvc animated:YES];
                    break;
                    
                case 2:
                    
                    gfmvc = [[pp_GelFiltMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController: gfmvc animated:YES];

                    break;
                    
                case 3: 
                    
                    iemvc = [[pp_IonExchMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController: iemvc animated:YES];
                    
                    break;
                    
                case 4:
                    
                    himvc = [[pp_HICMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController: himvc animated:YES];

                    break;
                    
                case 5:
                    
                    ammvc = [[pp_AffMediaMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController: ammvc animated:YES];
                    break;
            }
            break;
            
        case 1:
        {
            
            
            switch (indexPath.row)
            {
                    
                case 0:
   
                    app.commands.oneDshowing = YES;
                    app.commands.twoDshowing = NO;
                    break;

                    
                case 1:
                    app.commands.oneDshowing = NO;
                    app.commands.twoDshowing = YES;
                    
                    break;
            }
            
            app.commands.comingFromHelp = NO;  // Needs to be reset as it might have been set during a previous Help
            
            UINavigationController* nav = (UINavigationController*)[app.splitViewController detailViewController];
            
            bool alreadyShowing = [nav.topViewController isKindOfClass:[pp_GelViewController class]];
            
            if (alreadyShowing)
                gelVC = (pp_GelViewController*)nav.topViewController;
            else
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange (0, 3)] withRowAnimation:UITableViewRowAnimationAutomatic];
                gelVC = [[pp_GelViewController alloc] initWithNibName:nil bundle:nil];
                gelVC.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
                [nav pushViewController:gelVC animated:YES];
            }
            
            if (app.commands.oneDshowing) [gelVC changeto1DPage];
            else [gelVC changeto2DPage];
            
            [gelVC hideMasterView];
            
            break;
        }
            
        case 2:
             switch (indexPath.row)
            {
                case 0:
                {
                    alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Abandon scheme",@"")
                                                                message:NSLocalizedString(@"Abandon warning",@"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"No",@"")
                                                      otherButtonTitles:NSLocalizedString(@"Yes",@""),nil];
                    [alert1 show];
                    break;
                }
                case 1:
                {
                    
                    alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please enter a unique name for the stored material.",@"")
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                              otherButtonTitles:NSLocalizedString(@"Cancel",@""),nil];
                    alert2.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [alert2 show];
                    
                    break;
                }
            }
            break;
    }
    
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView == alert1) && (buttonIndex == 1))
    {
        // Abandon scheme
        [self abandonScheme];
    }
    
    if ((alertView == alert2) && (buttonIndex == 0))
    {
        // Save scheme
        UITextField* text = [alert2 textFieldAtIndex:0];
        filename = text.text;
        [self saveScheme];
    }
    
    if ((alertView == alert3) && (buttonIndex == 1))
    {
        [self writeTheFile];
    }
    // Unhighlight the button hightlight
    [self.tableView reloadData];
}

@end
