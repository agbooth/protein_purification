//
//  pp_GelFiltMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_GelFiltMenuViewController.h"

@interface pp_GelFiltMenuViewController ()

@end

@implementation pp_GelFiltMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Media",@"");

    // switch off the elastic
    [self.tableView setBounces:NO];

}


- (void) viewWillAppear:(BOOL)animated
{
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    [super viewWillAppear:animated];
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
        case 0: header = NSLocalizedString(@"Gel filtration",@""); break;
        
        case 1: header = NSLocalizedString(@"Information",@""); break;
        
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0: return 9;
        
        case 1: return 1;
        
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
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section)
    {
            
        case 0:
            
        switch (indexPath.row)
        {
                
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Sephadex G-50",@""); break;
                
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Sephadex G-100",@""); break;
                
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Sephacryl S-200 HR",@""); break;
                
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"Ultrogel AcA 54",@""); break;
                
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"Ultrogel AcA 44",@""); break;
                
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"Ultrogel AcA 34",@""); break;
            
                case 6:
                    cell.textLabel.text = NSLocalizedString(@"Bio-Gel P-60",@""); break;
                
                case 7:
                    cell.textLabel.text = NSLocalizedString(@"Bio-Gel P-150",@""); break;
                
                case 8:
                    cell.textLabel.text = NSLocalizedString(@"Bio-Gel P-300",@""); break;

                
        }
        break;
            
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Gel filtration",@""); break;
            break;
            
    }
    
    
    
    return cell;
    
   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        app.commands.sepType = Gel_filtration;
        app.commands.sepMedia = Sephadex_G50 + indexPath.row;
    
        // Do the separation
        [app.commands doGelFiltration];
        
        [app.commands hideMasterView];
    }
    if (indexPath.section == 1)
    {
        [app.commands showHelpPage:@"Gel_filtration"];
    }
}

@end
