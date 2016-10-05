//
//  pp_GetFractionView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_GetFractionView.h"

@implementation pp_GetFractionView {
    
    UIButton* fractionButton;
    UILabel* fractionHeader;
    UILabel *fractionLabel;
    UIPickerView* fractionPicker;
    
    UILabel* help2DHeader;
    UIButton* help2DButton;
    
}

@synthesize fractionValue;
@synthesize noOfProteins;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fractionButton = nil;
        fractionHeader = nil;
        fractionLabel = nil;
        fractionPicker = nil;
        help2DHeader = nil;
        help2DButton = nil;
    }
    return self;
}

- (void) drawButton:(CGRect) rect
{
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextSetStrokeColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-20.0,rect.origin.y,1000.0,rect.size.height+2.0) cornerRadius:10.0];
    [path fill];
    CGContextRestoreGState(con);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
/*
    // pH or Elution buffer
    if (!fractionButton)
    {
        fractionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        fractionButton.backgroundColor = [UIColor clearColor];
        [fractionButton setEnabled:NO];
        [self addSubview:fractionButton];

    }
    fractionButton.frame = CGRectMake(10, 36, 300, 208);
 */
    [self drawButton:CGRectMake(10, 36, 300, 208)];
        
    if (!fractionHeader)
    {
        fractionHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 21)];
        fractionHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        fractionHeader.text = NSLocalizedString(@"2D - PAGE",@"").uppercaseString;
        fractionHeader.shadowOffset = CGSizeMake(0.0,0.5);
        fractionHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        fractionHeader.shadowColor = [UIColor whiteColor];
        
        fractionHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:fractionHeader];
    }
    else
        fractionHeader.frame = CGRectMake(20, 10, 250, 21);
    
    
    if (!fractionLabel)
    {
        fractionLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 102, 150, 70)];
        fractionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        fractionLabel.textColor = [UIColor blackColor];
        fractionLabel.backgroundColor = [UIColor clearColor];
        fractionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Select fraction to examine",@""),self.noOfProteins];
        fractionLabel.numberOfLines = 4;
        fractionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fractionLabel];
    }
    else
        fractionLabel.frame = CGRectMake(42, 102, 150, 70);
    
    if (!fractionPicker)
    {
        fractionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(220, 50, 75, 180)];
        fractionPicker.dataSource = self;
        fractionPicker.delegate = self;
        fractionPicker.showsSelectionIndicator = YES;
        [fractionPicker selectRow:59 inComponent:0 animated:NO];
        [self addSubview:fractionPicker];
    }
    else
        fractionPicker.frame = CGRectMake(220, 50, 75, 180);
    
    if (!help2DHeader)
    {
        help2DHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 278, 250, 21)];
        help2DHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        help2DHeader.text = NSLocalizedString(@"Information",@"").uppercaseString;
        help2DHeader.shadowOffset = CGSizeMake(0.0,0.5);
        help2DHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        help2DHeader.shadowColor = [UIColor whiteColor];
        
        help2DHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:help2DHeader];
    }
    else
        help2DHeader.frame = CGRectMake(20, 278, 250, 21);
    
    [self drawButton:CGRectMake(10, 310, 300, 45)];
    
    if (!help2DButton)
    {
        help2DButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        help2DButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [help2DButton setTitle:NSLocalizedString(@"2D - PAGE",@"") forState:UIControlStateNormal];
        [help2DButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [help2DButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [help2DButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [help2DButton setTitleEdgeInsets:UIEdgeInsetsMake (0.0,15.0,0.0,0.0)];
        [help2DButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    help2DButton.frame = CGRectMake(10, 310, 300, 45);
    
    
    [self addSubview:help2DButton];
    
    app.commands.startOfPool = app.commands.endOfPool = self.fractionValue = 60;
    [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];

        
}

#pragma UIButton

- (void) helpButtonPressed
{
    [app.commands showHelpPage:@"2D"];
}


#pragma mark - Picker View

/* Defines the total number of Components (like groups in a UITableView) in a UIPickerView */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
     return 1;
 }

/* What to do when a row from a UIPickerView is selected. This will trigger each time the UIPickerViewis scrolled, so only lightweight stuff. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
 {
     self.fractionValue = row+1;
     app.commands.startOfPool = app.commands.endOfPool = self.fractionValue;
     [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];
 }
 
 
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
 {
     return 125;
 }
 
 
 // Using a label rather than a string - it looks nicer.
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
 {
     view = nil;
 
     UILabel *label = [[UILabel alloc] init];
     label.textColor = [UIColor blackColor];
     label.backgroundColor = [UIColor clearColor];
     label.text = [NSString stringWithFormat:@"%d",row+1];
     [label sizeToFit];
     return label;
 }
@end
