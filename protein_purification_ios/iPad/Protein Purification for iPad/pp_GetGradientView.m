//
//  pp_GetGradientView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_GetGradientView.h"

@implementation pp_GetGradientView {
    
    CPPickerView *elutionPicker, *startPicker, *endPicker;
    
    UIButton* elutionButton;
    UILabel* elutionHeader;
    UILabel* elutionLabel;
    
    UIButton* gradientButton;
    UILabel* gradientHeader;
    UILabel* startLabel;
    
    UIButton* dividerButton;
    
    UILabel* endLabel;
    
    float start, end, value;
    
}

@synthesize elutionFloatValue;
@synthesize startFloatValue;
@synthesize endFloatValue;

@synthesize elutionpHRequired;
@synthesize sepType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        elutionButton = nil;
        elutionHeader = nil;
        elutionLabel = nil;
        elutionPicker = nil;
        
        gradientButton = nil;
        gradientHeader = nil;
        
        startLabel = nil;
        startPicker = nil;
        
        dividerButton = nil;
        
        endLabel = nil;
        endPicker = nil;
        
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
    float offset;
    
    if (self.elutionpHRequired)
        offset = 120.0;
    else offset = 0.0;
    
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    
    
    if (self.elutionpHRequired)
    {
        // pH or Elution buffer
        [self drawButton:CGRectMake(10, 36, 300, 80)];
        
        if (!elutionHeader)
        {
            elutionHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 21)];
            elutionHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            elutionHeader.text = NSLocalizedString(@"Equilibration",@"").uppercaseString;
            elutionHeader.shadowOffset = CGSizeMake(0.0,0.5);
            elutionHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
            elutionHeader.shadowColor = [UIColor whiteColor];
            
            elutionHeader.backgroundColor = [UIColor clearColor];
            if (self.elutionpHRequired)
                [self addSubview:elutionHeader];
        }
        else
            elutionHeader.frame = CGRectMake(20, 10, 250, 21);
    
        if (!elutionLabel)
        {
            elutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 250, 21)];
            elutionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            elutionLabel.text = NSLocalizedString(@"pH of buffer:",@"");
            elutionLabel.backgroundColor = [UIColor clearColor];
            if (self.elutionpHRequired)
                [self addSubview:elutionLabel];
        }
        else
            elutionLabel.frame = CGRectMake(25, 42, 250, 21);
        
        start = 3.0;
        end = 11.0;
        value = 7.0;
        
        if (!elutionPicker)
        {
            elutionPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
            [self addSubview:elutionPicker];
            elutionPicker.delegate = self;
            elutionPicker.dataSource = self;
            elutionPicker.itemFont = [UIFont boldSystemFontOfSize:14];
            elutionPicker.itemColor = [UIColor blackColor];
            elutionPicker.showGlass = YES;
            elutionPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
            [elutionPicker reloadData];
            [elutionPicker setSelectedItem:40];
        }
        elutionPicker.center = CGPointMake(155,85);
        
        self.elutionFloatValue = 7.0;
 
    }
    // Gradient
    [self drawButton:CGRectMake(10, 36+offset, 300, 160)];
    
    NSString* label;
    
    
    if (app.commands.gradientIsSalt)
    {
        label = NSLocalizedString(@"Gradient limits (molar)",@"");
        if (self.sepType == Hydrophobic_interaction)
        {
            value = 2.0;
        }
        else
        {
            value = 0.0;
        }
    }
    else
    {
        label = NSLocalizedString(@"Gradient limits (pH)",@"");
        value = 7.0;
    }
    
    self.startFloatValue = value;
    
    if (!gradientHeader)
    {
        gradientHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10+offset, 250, 21)];
        gradientHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        gradientHeader.text = label.uppercaseString;
        gradientHeader.shadowOffset = CGSizeMake(0.0,0.5);
        gradientHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        gradientHeader.shadowColor = [UIColor whiteColor];
        gradientHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:gradientHeader];
    }
    else
        gradientHeader.frame = CGRectMake(20, 10+offset, 250, 21);

    
    if (!startLabel)
    {
        startLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 42+offset, 250, 21)];
        startLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        startLabel.text = NSLocalizedString(@"Start of gradient:",@"");
        startLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:startLabel];
    }
    else startLabel.frame  = CGRectMake(25, 42+offset, 250, 21);
    
    if (!startPicker)
    {
        startPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:startPicker];
        startPicker.delegate = self;
        startPicker.dataSource = self;
        startPicker.itemFont = [UIFont boldSystemFontOfSize:14];
        startPicker.itemColor = [UIColor blackColor];
        startPicker.showGlass = YES;
        startPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [startPicker reloadData];
        if (self.sepType == Hydrophobic_interaction)
            [startPicker setSelectedItem:20];
        else if (app.commands.gradientIsSalt)
            [startPicker setSelectedItem:0];
        else
            [startPicker setSelectedItem:40];
    }
    startPicker.center = CGPointMake(155,88+offset);
        
    
    if (!dividerButton)
    {
        dividerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dividerButton.backgroundColor = [UIColor clearColor];
        [self addSubview:dividerButton];
    }
    dividerButton.frame = CGRectMake(10, 116+offset, 300, 1);
    
    if (app.commands.gradientIsSalt)
    {
        if (self.sepType == Hydrophobic_interaction)
        {
            value = 0.0;
        }
        else
        {
            value = 0.5;
        }
    }
    else
    {
        value = 7.0;
    }
    
    self.endFloatValue = value;
    
    if (!endLabel)
    {
        endLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 122+offset, 250, 21)];
        endLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        endLabel.text = NSLocalizedString(@"End of gradient:",@"");
        endLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:endLabel];
    }
    else
        endLabel.frame = CGRectMake(25, 122+offset, 250, 21);
    
   
    if (!endPicker)
    {
        endPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:endPicker];
        endPicker.delegate = self;
        endPicker.dataSource = self;
        endPicker.itemFont = [UIFont boldSystemFontOfSize:14];
        endPicker.itemColor = [UIColor blackColor];
        endPicker.showGlass = YES;
        endPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [endPicker reloadData];
        if (self.sepType == Hydrophobic_interaction)
            [endPicker setSelectedItem:0];
        else if (app.commands.gradientIsSalt)
            [endPicker setSelectedItem:5];
        else
            [endPicker setSelectedItem:40];
    }
    endPicker.center = CGPointMake(155,168+offset);
}

#pragma CPPickerView

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    if (pickerView == elutionPicker) return 81;
    else if (self.sepType == Hydrophobic_interaction) return 51;
    else if (app.commands.gradientIsSalt) return 31;
    else return 81;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    if (pickerView == elutionPicker)
    {
        value = 3.0 + ((float)item/10.0);
    }
    else
    {
        if (app.commands.gradientIsSalt)
            value = (float)item/10.0;
        else
            value = 3.0 + ((float)item/10.0);
    }
    return [NSString stringWithFormat:@"%.1f",value];
}

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if (pickerView == elutionPicker) self.elutionFloatValue = 3.0 + ((float)item/10.0);
    
    if (pickerView == startPicker)
    {
        if (app.commands.gradientIsSalt)
            self.startFloatValue = (float)item/10.0;
        else
            self.startFloatValue = 3.0 + ((float)item/10.0);
    }
    if (pickerView == endPicker)
    {
        if (app.commands.gradientIsSalt)
            self.endFloatValue = (float)item/10.0;
        else
            self.endFloatValue = 3.0 + ((float)item/10.0);
    }
}

@end
