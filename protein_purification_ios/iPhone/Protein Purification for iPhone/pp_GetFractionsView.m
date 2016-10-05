//
//  pp_GetFractionsView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_GetFractionsView.h"

@implementation pp_GetFractionsView {
    
    UIButton* fractionButton;
    UILabel* fractionHeader;
    UILabel* fractionNote;
    UIPickerView* fractionPicker;
    
    UILabel* help1DHeader;
    UIButton* help1DButton;
    
}

@synthesize fractionValue;
@synthesize noOfProteins;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fractionButton = nil;
        fractionHeader = nil;
        fractionNote = nil;
        fractionPicker = nil;
        help1DHeader = nil;
        help1DButton = nil;
    }
    return self;
}

- (void) drawRoundRect
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextSetStrokeColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 36, 220, 180) cornerRadius:10.0];
    [path fill];
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 36, 220, 180) cornerRadius:10.0];
    [path fill];
    [path stroke];
    CGContextRestoreGState(con);
    
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

    [self drawButton:CGRectMake(10, 36, 220, 180)];
        
    if (!fractionHeader)
    {
        fractionHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 21)];
        fractionHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        fractionHeader.text = NSLocalizedString(@"1D - PAGE",@"").uppercaseString;
        fractionHeader.shadowOffset = CGSizeMake(0.0,0.5);
        fractionHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        fractionHeader.shadowColor = [UIColor whiteColor];
        fractionHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:fractionHeader];
    }
    else
        fractionHeader.frame = CGRectMake(20, 10, 200, 21);
    
 
    if (!fractionNote)
    {
        fractionNote = [[UILabel alloc] initWithFrame:CGRectMake(28, 45, 120, 70)];
        fractionNote.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        fractionNote.text = NSLocalizedString(@"You can select up\nto 15 fractions.",@"");
        fractionNote.textColor = [UIColor blackColor];
        fractionNote.backgroundColor = [UIColor clearColor];
        fractionNote.numberOfLines = 4;
        fractionNote.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fractionNote];
    }
    else
        fractionNote.frame = CGRectMake(28, 45, 120, 70);
    
    if (!fractionPicker)
    {
        fractionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(160, 45, 60, 162)];
        fractionPicker.dataSource = self;
        fractionPicker.delegate = self;
        fractionPicker.showsSelectionIndicator = YES;
        [fractionPicker selectRow:59 inComponent:0 animated:NO];
        [self addSubview:fractionPicker];
    }
    else
        fractionPicker.frame = CGRectMake(160, 45, 60, 162);
    
    [self drawButton:CGRectMake(10, 230, 220, 30)];
    if (!help1DButton)
    {
        help1DButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        help1DButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [help1DButton setTitle:NSLocalizedString(@"1D - PAGE",@"").uppercaseString forState:UIControlStateNormal];
        [help1DButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [help1DButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [help1DButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [help1DButton setTitleEdgeInsets:UIEdgeInsetsMake (0.0,15.0,0.0,0.0)];
        [help1DButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    help1DButton.frame = CGRectMake(10, 230, 220, 30);
    
    
    [self addSubview:help1DButton];

    
    app.commands.startOfPool = app.commands.endOfPool = self.fractionValue = 60;
    [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];

        
}

#pragma UIButton

- (void) helpButtonPressed
{
    [app.commands showHelpPage:@"SDS"];
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
