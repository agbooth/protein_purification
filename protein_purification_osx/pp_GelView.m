//
//  pp_GelView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 14/08/2012.
//
//

#import "pp_GelView.h"
#import "pp_AppDelegate.h"

@implementation pp_GelView {

float xscale;
float yscale;
float xOffset;
float yOffset;
float labelYOffset;
float labelXOffset;

}

enum {
    left,
    centre,
    right
};

@synthesize showBlot;
@synthesize twoDGel;

-(CGColorRef) CIColorToCGColor: (CIColor *) ciColor {
	CGColorSpaceRef colorSpace = [ciColor colorSpace];
	const CGFloat *components = [ciColor components];
	CGColorRef cgColor = CGColorCreate (colorSpace, components);
	CGColorSpaceRelease(colorSpace);
	return cgColor;
}

-(CGColorRef) NSColorToCGColor: (NSColor *) nsColor {
	CIColor *ciColor = [[CIColor alloc] initWithColor: nsColor];
	CGColorRef cgColor = [self CIColorToCGColor: ciColor];
	[ciColor release];
	return cgColor;
}

- (float) Mobility: (float) MW
{
    return 120*(11.5-log(MW));
}

- (float) xscale:(float) x
{
    return (x + xOffset)*xscale;
}

- (float) yscale:(float) y
{
    return (y + yOffset)*yscale;
}

- (void) create_text_in_box:(NSString*) text rect: (CGRect) rect size:(float) size colour: (NSColor*) colour angle: (float) angle italic: (bool) italic alignment: (int) alignment
{
    
    float x,y;
    
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    // Set text rotation
    CGContextSetTextMatrix (con, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.0, -1.0 ), angle));
    
    // CGContextShowTextAtPoint only works with C strings encoded with MacOSRoman, not UTF8 or UTF16
    // so the text has to be transcoded.
    NSData *strData = [text dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
    char string[[strData length] + 1];
    memcpy(string, [strData bytes], [strData length] + 1);
    string[[strData length]] = '\0';
    
    // set the font
    NSFont* font;
    if (italic)
        font = [NSFont fontWithName:@"Helvetica-Oblique" size:size];
    else
        font = [NSFont fontWithName:@"Helvetica" size:size];
    
    const char* fontName = [font.fontName UTF8String];
    
    CGContextSelectFont( con, fontName, size, kCGEncodingMacRoman);
    
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:colour]);
    CGContextSetFillColorWithColor(con, [self NSColorToCGColor:colour]);
    
    // convert the sender rectangle to real coordinates
    CGRect ourRect = CGRectMake([self xscale:rect.origin.x], [self yscale:rect.origin.y], rect.size.width*xscale, rect.size.height*yscale );
    
    // work out the size of the rectangle bounding the text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica" size:size], NSFontAttributeName,
                                [NSParagraphStyle defaultParagraphStyle], NSParagraphStyleAttributeName,
                                nil];
    
    NSSize expectedSize = [text sizeWithAttributes:attributes];
    
    if (angle==0)
    {
        if (alignment==centre) // centered
        {
            x = ourRect.origin.x + ((ourRect.size.width-expectedSize.width)/2.0);
            y = ourRect.origin.y - ((ourRect.size.height-expectedSize.height)/2.0);
        }
        else if (alignment==right) // right-aligned
        {
            x = ourRect.origin.x + (ourRect.size.width-expectedSize.width);
           // y = ourRect.origin.y + (ourRect.size.height-expectedSize.height);
            y = ourRect.origin.y + (expectedSize.height/4.0);
        }
        else
        {
            x = ourRect.origin.x; // default is left-aligned
            y = ourRect.origin.y;
        }
    }
    else if (angle > 0.0) // assuming 90 degree rotation anticlockwise
    {
        y = ourRect.origin.y + ourRect.size.height - ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x + ourRect.size.width;
    }
    else // assuming 90 degree rotation clockwise
    {
        y = ourRect.origin.y + ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x;
    }
    
    CGContextShowTextAtPoint(con, x, y, string, strlen(string));
    
    CGContextRestoreGState(con);
}

- (void) create_line:(float) X1 Y1:(float) Y1 X2:(float) X2 Y2:(float) Y2 strokeColour: (NSColor*) strokeColour
{
    float x1 = [self xscale:X1];
    float y1 = [self yscale:Y1];
    float x2 = [self xscale:X2];
    float y2 = [self yscale:Y2];
    
    
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextMoveToPoint(con, x1, y1);
    CGContextAddLineToPoint(con, x2, y2);
    
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:strokeColour]);
    
    CGContextSetLineWidth(con, 1.0);
    CGContextStrokePath(con);
    
    CGContextRestoreGState(con);
    
}

- (void) create_rhombus:(float) X1 Y1:(float) Y1 X2:(float) X2 Y2:(float) Y2 X3:(float) X3 Y3:(float) Y3 X4:(float) X4 Y4:(float) Y4 fillColour: (NSColor*) fillColour strokeColour: (NSColor*) strokeColour
{
    float x1 = [self xscale:X1];
    float y1 = [self yscale:Y1];
    float x2 = [self xscale:X2];
    float y2 = [self yscale:Y2];
    float x3 = [self xscale:X3];
    float y3 = [self yscale:Y3];
    float x4 = [self xscale:X4];
    float y4 = [self yscale:Y4];
    
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextMoveToPoint(con, x1, y1);
    CGContextAddLineToPoint(con, x2, y2);
    CGContextAddLineToPoint(con, x3, y3);
    CGContextAddLineToPoint(con, x4, y4);
    CGContextClosePath(con);

    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:strokeColour]);
    CGContextSetFillColorWithColor(con, [self NSColorToCGColor:fillColour]);
    
    CGContextSetLineWidth(con, 1.0);
    CGContextFillPath(con);
    CGContextStrokePath(con);
    
    CGContextRestoreGState(con);
}

- (void) create_polygon:(NSMutableArray* )coords colour:(NSColor*) colour
{
    
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:colour]);
    CGContextSetFillColorWithColor(con, [self NSColorToCGColor:colour]);
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    NSValue* val = [coords objectAtIndex:0];
    NSPoint p = [val pointValue];
    p.x = [self xscale:p.x];
    p.y = [self yscale:p.y];
    
    [path moveToPoint:p];
    for (int i = 1; i<coords.count; i++)
    {
        NSValue* val = [coords objectAtIndex:i];
        NSPoint p = [val pointValue];
        p.x = [self xscale:p.x];
        p.y = [self yscale:p.y];
        [path lineToPoint:p];
    }
    [path closePath];
    [path stroke];
    [path fill];
    
    CGContextRestoreGState(con);
}

- (void) Band: (int) no  MW: (float) MW intensity: (float) intensity
{
    
    if ((MW > 80000.0) || (MW < 5000.0)) return;
    
    NSColor*  colour;
    if (self.showBlot) colour = [NSColor blackColor];
    else colour = [NSColor blueColor];
    
    float ypos = [self Mobility:MW];
    float xpos = 4.0+(30.0*no);
    
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    
    if (intensity < 0.001) return;
    
    if ((intensity >= 0.001) && (intensity < 0.05))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos)]];

    }
    
    if ((intensity >= 0.05) && (intensity < 0.2))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos+2.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos+2.0)]];
        
    }
    
    if ((intensity >= 0.2) && (intensity < 0.5))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos+3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos+3.0)]];
        
    }
    
    if (intensity >= 0.5)
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+24.0, ypos+4.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos, ypos+4.0)]];
        
    }
    
    [self create_polygon:coords colour:colour];
}


- (void) Spot:(float) isopoint MW:(float) MW intensity:(float) intensity
{
    
    if ((MW > 80000.0) || (MW < 5000.0)) return;
    if ((isopoint < 4.3) || (isopoint > 8.7)) return;
    
    NSColor* colour;
    
    if (self.showBlot)
        colour = [NSColor blackColor];
    else
        colour = [NSColor blueColor];
    
    float ypos = [self Mobility:MW];
    float xpos = (isopoint-4.0)*100.0;
    
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    
    if (intensity <= 0.0005) return;
    
    if ((intensity > 0.0005) && (intensity < 0.001))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0,ypos)]];
    }
    
    if ((intensity >= 0.001) && (intensity < 0.01))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-5.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-3.0,ypos-1.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+3.0,ypos-1.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+5.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+3.0,ypos+2.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-3.0,ypos+2.0)]];
    }
    
    if ((intensity >= 0.01) && (intensity < 0.1))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-5.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-3.0,ypos-1.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+3.0,ypos-1.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+5.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+3.0,ypos+3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-3.0,ypos+3.0)]];
    }
    
    if ((intensity >= 0.1) && (intensity < 0.2))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-6.0,ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+6.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0, ypos+3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+2.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-2.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0, ypos+3.0)]];
    }
        
    if ((intensity >= 0.2) && (intensity < 0.5))
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-8.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-6.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+6.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+8.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+6.0, ypos+3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+2.0, ypos+9.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-2.0, ypos+9.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-6.0, ypos+3.0)]];
    }
        
    if (intensity >= 0.5)
    {
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-10.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-8.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0, ypos-6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0, ypos-6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+8.0, ypos-3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+10.0, ypos)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+10.0, ypos+3.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+8.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+6.0, ypos+9.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+4.0, ypos+12.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos+2.0, ypos+15.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-2.0, ypos+15.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-4.0, ypos+12.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-6.0, ypos+9.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-8.0, ypos+6.0)]];
        [coords addObject:[NSValue valueWithPoint:NSMakePoint(xpos-10.0, ypos+3.0)]];
    }
    
    [self create_polygon:coords colour:colour];
    
}

- (void) Markers
{
    float width;
    if (self.twoDGel)
        width = 500;
    else
        width = 30.0 +(30.0*MAX(1,app.commands.frax.count));
    float x = 0;
    float y = 0;
    
 //   UIColor* colour = [UIColor colorWithRed:0.7734375 green:0.7734375 blue:0.7734375 alpha:1.0];

    NSColor* colour = [NSColor colorWithCalibratedRed:0.8125 green:0.8125 blue:0.875 alpha:1.0];
    
    if (self.showBlot)
    {
        NSColor* colour = [NSColor whiteColor];
        
        // draw the blot
        [self create_rhombus:x
                          Y1:y
                          X2:x+width
                          Y2:y
                          X3:x+width
                          Y3:y+360.0
                          X4:x
                          Y4:y+360.0
                  fillColour:colour
                strokeColour:[NSColor blackColor]];
        
        // right side
        colour = [NSColor colorWithCalibratedRed:0.49609375 green:0.49609375 blue:0.49609375 alpha:1.0];
        [self create_rhombus:x+width
                          Y1:y
                          X2:x+width+1.0
                          Y2:y+2.0
                          X3:x+width+1.0
                          Y3:y+361.0
                          X4:x+width
                          Y4:y+360.0
                  fillColour:colour
                strokeColour:[NSColor blackColor]];
        
        [self create_rhombus:x
                          Y1:y+360.0
                          X2:x+4.0
                          Y2:y+361.0
                          X3:x+width+1.0
                          Y3:y+361.0
                          X4:x+width
                          Y4:y+360.0
                  fillColour:colour
                strokeColour:[NSColor blackColor]];
        // highlights left and top
        [self create_line:x
                       Y1:y+360.0
                       X2:x
                       Y2:y
             strokeColour:[NSColor lightGrayColor]];
        
        [self create_line:x
                       Y1:y
                       X2:x+width
                       Y2:y
             strokeColour:[NSColor lightGrayColor]];
       

    }
    else
    {
        // draw the gel
        [self create_rhombus:x
                      Y1:y
                      X2:x+width
                      Y2:y
                      X3:x+width
                      Y3:y+360.0
                      X4:x
                      Y4:y+360.0
              fillColour:colour
            strokeColour:[NSColor blackColor]];
        // right side
        colour = [NSColor colorWithCalibratedRed:0.49609375 green:0.49609375 blue:0.49609375 alpha:1.0];
        [self create_rhombus:x+width
                      Y1:y
                      X2:x+width+4.0
                      Y2:y+2.0
                      X3:x+width+4.0
                      Y3:y+362.0
                      X4:x+width
                      Y4:y+360.0
              fillColour:colour
            strokeColour:[NSColor blackColor]];
    
        [self create_rhombus:x
                      Y1:y+360.0
                      X2:x+4.0
                      Y2:y+362.0
                      X3:x+width+4.0
                      Y3:y+362.0
                      X4:x+width
                      Y4:y+360.0
              fillColour:colour
            strokeColour:[NSColor blackColor]];
        // highlights left and top
        [self create_line:x
                   Y1:y+360.0
                   X2:x
                   Y2:y
         strokeColour:[NSColor lightGrayColor]];
     
        [self create_line:x
                   Y1:y+1
                   X2:x+width
                   Y2:y+1
         strokeColour:[NSColor lightGrayColor]];
 
    }
    
    if (self.twoDGel)
    {
        // top labels
        for ( int i = 4; i <= 9; i++ )
        {
            int j = x+100*(i-4);
        
            [self create_text_in_box:[NSString stringWithFormat:@"%d",i]
                            rect:CGRectMake((float)j,(float)y-17.0,1.0,1.0)
                            size:14.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:centre];
        
            [self create_line: j
                       Y1:y-8
                       X2:j
                       Y2:y-3
             strokeColour:[NSColor blackColor]];
        }
    
        [self create_text_in_box:@"pH"
                        rect:CGRectMake(0,-30.0,width,10.0)
                        size:16.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:centre];
    }
    else
    if (!self.showBlot)
    {
        [self Band:0 MW:8E4 intensity:0.01];
        [self Band:0 MW:6.8E4 intensity:0.01];
        [self Band:0 MW:5E4 intensity:0.01];
        [self Band:0 MW:4.5E4 intensity:0.01];
        [self Band:0 MW:3.6E4 intensity:0.01];
        [self Band:0 MW:2.5E4 intensity:0.01];
        [self Band:0 MW:1.4E4 intensity:0.01];
        [self Band:0 MW:9E3 intensity:0.01];
        [self Band:0 MW:6E3 intensity:0.01];
    }
    // side Labels
    
    
    
    [self create_line:x-12
                   Y1:y+[self Mobility:8E4]
                   X2:x-3
                   Y2:y+[self Mobility:8E4]
                   strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"80K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:8E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:6E4]
                   X2:x-3
                   Y2:y+[self Mobility:6E4]
         strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"60K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:6E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:5E4]
                   X2:x-3
                   Y2:y+[self Mobility:5E4]
         strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"50K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:5E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:4E4]
                   X2:x-3
                   Y2:y+[self Mobility:4E4]
         strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"40K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:4E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:3E4]
                   X2:x-3
                   Y2:y+[self Mobility:3E4]
         strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"30K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:3E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:2E4]
                   X2:x-3
                   Y2:y+[self Mobility:2E4]
         strokeColour:[NSColor blackColor]];
     
     [self create_text_in_box:@"20K"
                         rect:CGRectMake((float)x-16.0,y+[self Mobility:2E4],1.0,1.0)
                         size:14.0
                       colour:[NSColor blackColor]
                        angle:0.0
                       italic:NO
                    alignment:right];
     
             [self create_line:x-12
                   Y1:y+[self Mobility:1E4]
                   X2:x-3
                   Y2:y+[self Mobility:1E4]
         strokeColour:[NSColor blackColor]];
    
    [self create_text_in_box:@"10K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:1E4],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_line:x-12
                   Y1:y+[self Mobility:5E3]
                   X2:x-3
                   Y2:y+[self Mobility:5E3]
         strokeColour:[NSColor blackColor]];
        
    [self create_text_in_box:@"5K"
                        rect:CGRectMake((float)x-16.0,y+[self Mobility:5E3],1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
     
    [self create_text_in_box:@"M"
                        rect:CGRectMake((float)x-60.0+labelXOffset,y+[self Mobility:2E4],1.0,1.0)
                        size:20.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    [self create_text_in_box:@"r"
                        rect:CGRectMake((float)x-57.0+labelXOffset,y+[self Mobility:2E4]+5.0,1.0,1.0)
                        size:14.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:YES
                   alignment:right];
    
    NSString* label = @"Wibble";
    int fraction;
    
    if (self.twoDGel)
    {
        if (self.showBlot)
            label = [NSString stringWithFormat:NSLocalizedString(@"Using antibody to protein %d",@""),app.proteinData.enzyme];
        else
        {
            if (app.commands.pooled)
            {
                if (app.proteinData.step == 0)
                    label = NSLocalizedString(@"2D - PAGE of initial mixture",@"");
                else
                    label = NSLocalizedString(@"2D - PAGE of pooled fractions",@"");
            }
            else
            {
                fraction = (int)[[app.commands.frax objectAtIndex:0] integerValue];
                label = [NSString stringWithFormat:NSLocalizedString(@"2D - PAGE of fraction %d",@""),fraction];
            }
        }
    
        [self create_text_in_box:label
                        rect:CGRectMake(0,400,width,15.0)
                        size:20.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:YES
                   alignment:centre];
    }
    else
    {
        if (self.showBlot)
            label = [NSString stringWithFormat:NSLocalizedString(@"Using antibody to protein %d",@""),app.proteinData.enzyme];
        else
        {
            if (app.commands.pooled)
            {
                if (app.proteinData.step == 0)
                    label = NSLocalizedString(@"Initial mixture",@"");
                else
                    label = NSLocalizedString(@"Pooled fractions",@"");
            }
            else
            {
                if (app.commands.frax.count == 1)
                {
                    fraction = (int)[[app.commands.frax objectAtIndex:0] integerValue];
                    label = NSLocalizedString(@"Selected fraction",@"");
                }
                else
                    label = NSLocalizedString(@"Selected fractions",@"");  
            }
        }
        
        [self create_text_in_box:label
                            rect:CGRectMake(0,400,width,15.0)
                            size:20.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:YES
                       alignment:left];
    }

}

- (void) showBands
{
    float sensitivityCutoff = 1.5;  // Decrease this to make staining more sensitive
    
    int firstprotein;
    int lastprotein;
    
    float amount;
    float total;
    
    float aggregate[app.proteinData.noOfProteins+1];
    aggregate[0] = 0.0;
    
    for ( int i=1; i<=app.proteinData.noOfProteins; i++)
         aggregate[i] = ([app.proteinData GetNoOfSub1OfProtein:i]*[app.proteinData GetSubunit1OfProtein:i]
                        +[app.proteinData GetNoOfSub2OfProtein:i]*[app.proteinData GetSubunit2OfProtein:i]
                        +[app.proteinData GetNoOfSub3OfProtein:i]*[app.proteinData GetSubunit3OfProtein:i]);

    
    if (self.showBlot)
    {
        
        firstprotein = app.proteinData.enzyme;
        lastprotein = firstprotein+1;
    }
    else
    {
        firstprotein = 1;
        lastprotein = app.proteinData.noOfProteins+1;
    }
    
    int noOfFractions = MAX((int)(app.commands.frax.count), 1);
    
    if (noOfFractions > 1)
    {
        // draw fractions title
        [self create_text_in_box:NSLocalizedString(@"Fractions",@"")
                            rect:CGRectMake(15.0, -30.0, 30.0*noOfFractions,10.0)
                            size:16.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:centre];
    }
    
    for (int j=0; j<noOfFractions; j++)
    {
        
        
        if (!app.commands.pooled)
        {
            // draw fraction numbers
            float xpos = 15+(30*(j+1));
            [self create_text_in_box:[NSString stringWithFormat:@"%ld",((NSNumber*)[app.commands.frax objectAtIndex:j]).integerValue]
                                rect:CGRectMake(xpos, -8.0, 1.0,10.0)
                                size:14.0
                              colour:[NSColor blackColor]
                              angle:0.0
                              italic:NO
                           alignment:centre];
        }
        
        for (int i=firstprotein; i<lastprotein; i++)
        {
            if (app.commands.pooled)
            {   // show the total mixture
                amount = [app.proteinData GetCurrentAmountOfProtein:i];
                total = [app.proteinData GetCurrentAmountOfProtein:0];
            }
            else
            {   // show what is in the selected fraction
                int fraction = (int)[[app.commands.frax objectAtIndex:j] integerValue];
                
                amount = [app.separation GetPlotElement:2*fraction protein:i] +
                [app.separation GetPlotElement:2*fraction-1 protein:i];
                
                total =  [app.separation GetPlotElement:2*fraction protein:0] +
                [app.separation GetPlotElement:2*fraction-1 protein:0];
                
            }
            if (amount > sensitivityCutoff)
            {
            
                if ([app.proteinData GetSubunit1OfProtein:i] > 0.0)
                    [self Band:j+1
                            MW:[app.proteinData GetSubunit1OfProtein:i]
                     intensity:amount/total*[app.proteinData GetSubunit1OfProtein:i]*[app.proteinData GetNoOfSub1OfProtein:i]/aggregate[i]];
                
                if (([app.proteinData GetSubunit2OfProtein:i] > 0.0) && !self.showBlot)
                    [self Band:j+1
                            MW:[app.proteinData GetSubunit2OfProtein:i]
                     intensity:amount/total*[app.proteinData GetSubunit2OfProtein:i]*[app.proteinData GetNoOfSub2OfProtein:i]/aggregate[i]];
                
                if (([app.proteinData GetSubunit3OfProtein:i] > 0.0) && !self.showBlot)
                    [self Band:j+1
                            MW:[app.proteinData GetSubunit3OfProtein:i]
                     intensity:amount/total*[app.proteinData GetSubunit3OfProtein:i]*[app.proteinData GetNoOfSub3OfProtein:i]/aggregate[i]];
                     
            }
        }
    }
}




- (void) showSpots
{
    float sensitivityCutoff = 1.5;  // Decrease this to make staining more sensitive
    
    float aggregate[app.proteinData.noOfProteins+1];
    aggregate[0] = 0.0;

    for ( int i=1; i<=app.proteinData.noOfProteins; i++)
    {
        // This is not the blot spot you are looking for. Move on.
        if (self.showBlot && (i != app.proteinData.enzyme)) continue;
        
        aggregate[i] = ([app.proteinData GetNoOfSub1OfProtein:i]*[app.proteinData GetSubunit1OfProtein:i]
                        +[app.proteinData GetNoOfSub2OfProtein:i]*[app.proteinData GetSubunit2OfProtein:i]
                        +[app.proteinData GetNoOfSub3OfProtein:i]*[app.proteinData GetSubunit3OfProtein:i]);
    
        float amount;
        float total;
        if (app.commands.pooled)  // show the total mixture
        {
            amount = [app.proteinData GetCurrentAmountOfProtein:i];
            total =  [app.proteinData GetCurrentAmountOfProtein:0];
        }
        else // show what is in the selected fraction
        {
            int fraction = (int)[[app.commands.frax objectAtIndex:0] integerValue];
            
            amount = [app.separation GetPlotElement:2*fraction protein:i] +
                     [app.separation GetPlotElement:2*fraction-1 protein:i];
            
            total =  [app.separation GetPlotElement:2*fraction protein:0] +
                     [app.separation GetPlotElement:2*fraction-1 protein:0];

        }
        
        // Note - changed from testing amount > 0 to amount > 1.5
        // Needed because of change to SetPlotArray from int to float.
        if ((amount > sensitivityCutoff) &&
            ([app.proteinData GetIsoPointOfProtein:i] <= 8.90) &&
            ([app.proteinData GetIsoPointOfProtein:i] >= 4.10))
        {
            if ([app.proteinData GetSubunit1OfProtein:i] > 0.0)
                [self Spot:[app.proteinData GetIsoPointOfProtein:i]
                        MW:[app.proteinData GetSubunit1OfProtein:i]
                 intensity:amount/total*[app.proteinData GetSubunit1OfProtein:i]*[app.proteinData GetNoOfSub1OfProtein:i]/aggregate[i]];
            
            if (([app.proteinData GetSubunit2OfProtein:i] > 0.0) && !self.showBlot)
                [self Spot:[app.proteinData GetIsoPointOfProtein:i]
                        MW:[app.proteinData GetSubunit2OfProtein:i]
                 intensity:amount/total*[app.proteinData GetSubunit2OfProtein:i]*[app.proteinData GetNoOfSub2OfProtein:i]/aggregate[i]];
            
            if (([app.proteinData GetSubunit3OfProtein:i] > 0.0) && !self.showBlot)
                [self Spot:[app.proteinData GetIsoPointOfProtein:i]
                        MW:[app.proteinData GetSubunit3OfProtein:i]
                 intensity:amount/total*[app.proteinData GetSubunit3OfProtein:i]*[app.proteinData GetNoOfSub3OfProtein:i]/aggregate[i]];
        }
    }
}

- (void) Run1DGel
{
    [self Markers];
    [self showBands];
}

- (void) Run2DGel
{
    [self Markers];
    [self showSpots];
}


- (void)drawRect:(NSRect)rect
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:self.bounds];
    [app.bgColor setFill];
    [path fill];
    
    labelXOffset = 0.0;
    
    float xsize = self.frame.size.width;
    float ysize = self.frame.size.height;
    
    xscale = xsize/640.0;
    yscale = ysize/480.0;
 
    xOffset = 80.0;
    yOffset = 65.0;
    labelYOffset = 0;
    
    self.twoDGel = app.commands.twoDGel;
    self.showBlot = app.commands.showBlot;
    
    if (self.twoDGel)
        [self Run2DGel];
    else
        [self Run1DGel];

}
@end
