//
//  pp_AmmSulfView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_AmmSulfView.h"

@implementation pp_AmmSulfView {
    
    CPPickerView *ammsulfPicker;
    
    UILabel* ammsulfHeader;
    UILabel* ammsulfLabel;
    UILabel* helpHeader;
    UIButton* helpButton;
    
}

@synthesize ammsulfFloatValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ammsulfPicker = nil;
        ammsulfHeader = nil;
        ammsulfLabel = nil;
        
        helpHeader = nil;
        helpButton = nil;
        
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
    
    [self drawButton:CGRectMake(10, 36, 220, 80)];
        
    if (!ammsulfHeader)
    {
            ammsulfHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 21)];
            ammsulfHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            ammsulfHeader.text = [NSLocalizedString(@"Ammonium sulfate",@"") uppercaseString];
            ammsulfHeader.shadowOffset = CGSizeMake(0.0,0.5);
            ammsulfHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
            ammsulfHeader.shadowColor = [UIColor whiteColor];
            ammsulfHeader.backgroundColor = [UIColor clearColor];
            [self addSubview:ammsulfHeader];
    }
    else
        ammsulfHeader.frame = CGRectMake(20, 10, 200, 21);
        
    if (!ammsulfLabel)
    {
            ammsulfLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 200, 21)];
            ammsulfLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            ammsulfLabel.text = NSLocalizedString(@"Percentage saturation:",@"");
            ammsulfLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:ammsulfLabel];
    }
    else
        ammsulfLabel.frame = CGRectMake(25, 42, 200, 21);
     
    if (!ammsulfPicker)
    {
        ammsulfPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:ammsulfPicker];
        ammsulfPicker.delegate = self;
        ammsulfPicker.dataSource = self;
        ammsulfPicker.itemFont = [UIFont boldSystemFontOfSize:14];
        ammsulfPicker.itemColor = [UIColor blackColor];
        ammsulfPicker.showGlass = YES;
        ammsulfPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [ammsulfPicker reloadData];
        [ammsulfPicker setSelectedItem:50];
    }
    ammsulfPicker.center = CGPointMake(155,85);
    
    self.ammsulfFloatValue = 50.0;
    
    if (!helpHeader)
    {
        helpHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 148, 200, 21)];
        helpHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        helpHeader.text = [NSLocalizedString(@"Information",@"") uppercaseString];
        helpHeader.shadowOffset = CGSizeMake(0.0,0.5);
        helpHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        helpHeader.shadowColor = [UIColor whiteColor];
        helpHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:helpHeader];
    }
    else
        helpHeader.frame = CGRectMake(20, 148, 200, 21);
    
    [self drawButton:CGRectMake(10, 180, 220, 45)];
    
    if (!helpButton)
    {
        helpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        helpButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [helpButton setTitle:NSLocalizedString(@"Ammonium sulfate fractionation",@"") forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [helpButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [helpButton setTitleEdgeInsets:UIEdgeInsetsMake (0.0,15.0,0.0,0.0)];
        [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    helpButton.frame = CGRectMake(10, 180, 220, 45);

    
    [self addSubview:helpButton];
}

#pragma UIButton

- (void) helpButtonPressed
{
    [app.commands showHelpPage:@"Ammonium_sulfate"];
}

#pragma CPPickerView

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 101;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%d",item];
}

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    self.ammsulfFloatValue = (float)item;
}

@end
