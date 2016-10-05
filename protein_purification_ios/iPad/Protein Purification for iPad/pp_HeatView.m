//
//  pp_HeatView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_HeatView.h"

@implementation pp_HeatView {
    
    CPPickerView *heatPicker;
    CPPickerView *timePicker;
    
    UILabel* heatHeader;
    UILabel* heatLabel;
    
    UIButton* dividerButton;
    
    UILabel* timeLabel;
    
    UILabel* helpHeader;
    UIButton* helpButton;
    
}

@synthesize heatFloatValue;
@synthesize timeFloatValue;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        heatPicker = nil;
        heatHeader = nil;
        heatLabel = nil;
        
        dividerButton = nil;
        
        timePicker = nil;
        timeLabel = nil;
        
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
    
    [self drawButton:CGRectMake(10, 36, 300, 160)];
        
    if (!heatHeader)
    {
            heatHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 21)];
            heatHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            heatHeader.text = NSLocalizedString(@"Heat treatment",@"").uppercaseString;
            heatHeader.shadowOffset = CGSizeMake(0.0,0.5);
            heatHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
            heatHeader.shadowColor = [UIColor whiteColor];
            heatHeader.backgroundColor = [UIColor clearColor];
            [self addSubview:heatHeader];
    }
    else
        heatHeader.frame = CGRectMake(20, 10, 250, 21);
        
    if (!heatLabel)
    {
            heatLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 250, 21)];
            heatLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            heatLabel.text = NSLocalizedString(@"What temperature (°C)?",@"");
            heatLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:heatLabel];
    }
    else
        heatLabel.frame = CGRectMake(25, 42, 250, 21);
        
    
    if (!heatPicker)
    {
        heatPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:heatPicker];
        heatPicker.delegate = self;
        heatPicker.dataSource = self;
        heatPicker.itemFont = [UIFont boldSystemFontOfSize:14];
        heatPicker.itemColor = [UIColor blackColor];
        heatPicker.showGlass = YES;
        heatPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [heatPicker reloadData];
        [heatPicker setSelectedItem:30];
    }
    heatPicker.center = CGPointMake(155,85);

    self.heatFloatValue = 30.0;
    
    if (!dividerButton)
    {
        dividerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dividerButton.backgroundColor = [UIColor clearColor];
        [self addSubview:dividerButton];
    }
    dividerButton.frame = CGRectMake(11, 116, 298, 2);
    
    if (!timeLabel)
    {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 122, 250, 21)];
        timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        timeLabel.text = NSLocalizedString(@"For how long (minutes)?",@"");
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
    }
    else
        timeLabel.frame = CGRectMake(25, 122, 250, 21);
    
    if (!timePicker)
    {
        timePicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:timePicker];
        timePicker.delegate = self;
        timePicker.dataSource = self;
        timePicker.itemFont = [UIFont boldSystemFontOfSize:14];
        timePicker.itemColor = [UIColor blackColor];
        timePicker.showGlass = YES;
        timePicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [timePicker reloadData];
        [timePicker setSelectedItem:10];
    }
    timePicker.center = CGPointMake(155,165);
    
    self.timeFloatValue = 10.0;
    
    if (!helpHeader)
    {
        helpHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 228, 250, 21)];
        helpHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        helpHeader.text = NSLocalizedString(@"Information",@"").uppercaseString;
        helpHeader.shadowOffset = CGSizeMake(0.0,0.5);
        helpHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        helpHeader.shadowColor = [UIColor whiteColor];
        
        helpHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:helpHeader];
    }
    else
        helpHeader.frame = CGRectMake(20, 228, 250, 21);
    
    [self drawButton:CGRectMake(10, 260, 300, 45)];
    if (!helpButton)
    {
        helpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        helpButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [helpButton setTitle:NSLocalizedString(@"Heat treatment",@"") forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [helpButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [helpButton setTitleEdgeInsets:UIEdgeInsetsMake (0.0,15.0,0.0,0.0)];
        [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    helpButton.frame = CGRectMake(10, 260, 300, 45);

    
    [self addSubview:helpButton];
}

#pragma UIButton

- (void) helpButtonPressed
{
    [app.commands showHelpPage:@"Heat_treatment"];
}

#pragma CPPickerView

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    if (pickerView == heatPicker)return 101;
    else return 121;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%d",item];
}

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if (pickerView == heatPicker)
        self.heatFloatValue = (float)item;
    else
        self.timeFloatValue = (float)item;
}


@end
