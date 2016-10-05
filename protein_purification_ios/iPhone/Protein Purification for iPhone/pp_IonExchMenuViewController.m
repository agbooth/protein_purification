//
//  pp_IonExchMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_IonExchMenuViewController.h"

@interface pp_IonExchMenuViewController ()

@end

@implementation pp_IonExchMenuViewController {

pp_GetGradientViewController* ggvc;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        ggvc = nil;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Media",@"");
    app.commands.gradientIsSalt = YES;  // default to salt
    
    // switch off the elastic
    [self.tableView setBounces:NO];

}



- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) return 0;
    if (section==2) return 20.0;
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1) return 30.0;
    return 40.0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Ion exchange",@""); break;
            
        case 1: header = nil; break;
        
        case 2: header = NSLocalizedString(@"Information",@""); break;
        
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
        case 0: return 4;
        
        case 1: return 1;
            
        case 2: return 1;
        
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Don't reuse cells - you may get one with a segmented control
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
    UITableViewCell   *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   // }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = NSLocalizedString(@"Elute with:",@"");
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    switch (indexPath.section)
    {
            
        case 0:
            
        switch (indexPath.row)
        {
                
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"DEAE-cellulose",@""); break;
                
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"CM-cellulose",@""); break;
                
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Q-Sepharose",@""); break;
                
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"S-Sepharose",@""); break;
                
        }
        break;
            
        case 1:
        {
            
            cell.textLabel.text = NSLocalizedString(@"Elute with:", @"");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
            NSDictionary* attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
            
            NSArray* items = [[NSArray alloc] initWithObjects:NSLocalizedString(@"salt gradient",@""),NSLocalizedString(@"pH gradient",@""), nil];
            
            UISegmentedControl* gradSelector = [[UISegmentedControl alloc] initWithItems:items];
            
            [gradSelector setTitleTextAttributes:attributes forState:UIControlStateNormal];
            gradSelector.segmentedControlStyle = UISegmentedControlStyleBar;
            gradSelector.selectedSegmentIndex = app.commands.gradientIsSalt ? 0 : 1;
            [gradSelector addTarget:self
                                 action:@selector(changeElutionType)
                       forControlEvents:UIControlEventValueChanged];
            
            [gradSelector sizeToFit];
            cell.accessoryView = gradSelector;
        }
        break;
            
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"Ion exchange chromatography",@"");
            break;
        }
    }
    
    
    
    return cell;
    
   
}

- (void) changeElutionType
{
    app.commands.gradientIsSalt = !app.commands.gradientIsSalt;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    if (indexPath.section==0)
    {
        
        
        ggvc = [[pp_GetGradientViewController alloc] init];
        
        // These variables are passed to the GetGradientViewController
        // which will set the corresponding variables in app.commands
        // when the user commits to doing the separation and not before.
        ggvc.sepType = Ion_exchange;
        ggvc.sepMedia = DEAE_cellulose + indexPath.row;
        ggvc.elutionpHRequired = YES;
        ggvc.delegate = (id <SeparationDelegate>) self;

        
        // properties must be set BEFORE the view is manipulated
        ggvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        
        [self.navigationController pushViewController: ggvc animated:YES];
    }
    
    // 1 is a dummy row containing the segmentedViewController
    
    if (indexPath.section==2)
    {
        [app.commands showHelpPage:@"Ion_Exchange"];
    }

    
}

-(void) doSeparation
{
    [app.commands doIonExchange];
}

@end
