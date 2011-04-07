//
//  NSColor+hex.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//
//  Adds support for a variety of return types to NSColor, as well as calculating new ones. 
//  I really should rename this category to reflect recent improvements, but I've been too lazy.
//
//


#import <Cocoa/Cocoa.h>


@interface NSColor (NSColor_hex)
-(NSString *)hexValue;
-(NSString *)rgbValue;
-(NSString *)rgbaValue;

-(NSArray *)shadeArray;

-(NSColor *)complement;

-(NSArray *)twinColorCousinsSeparatedByDegrees:(float)degrees initialOffset:(float)offsetDegrees;
@end



@implementation NSColor (NSColor_hex)

-(NSString *)rgbaValue {
    
//    rgba(255, 0, 0, 0.2)
    
	float redFloat = self.redComponent * 25500;
	float greenFloat = self.greenComponent * 25500;
	float blueFloat = self.blueComponent * 25500;

	int redInt = redFloat / 100;
	int greenInt = greenFloat / 100;
	int blueInt = blueFloat / 100;

    NSString *rgbaString = [NSString stringWithFormat:@"rgba(%d, %d, %d, 1.0)", redInt, greenInt, blueInt];
    
    return rgbaString;
    
}


-(NSString *)rgbValue {
    
    //    rgba(255, 0, 0, 0.2)
    
	float redFloat = self.redComponent * 25500;
	float greenFloat = self.greenComponent * 25500;
	float blueFloat = self.blueComponent * 25500;
    
	int redInt = redFloat / 100;
	int greenInt = greenFloat / 100;
	int blueInt = blueFloat / 100;
    
    NSString *rgbString = [NSString stringWithFormat:@"rgb(%d, %d, %d)", redInt, greenInt, blueInt];
    
    return rgbString;
    
}


-(NSString *)hexValue {
	
	float redFloat = self.redComponent * 25500;
	float greenFloat = self.greenComponent * 25500;
	float blueFloat = self.blueComponent * 25500;
	
	int redInt = redFloat / 100;
	int greenInt = greenFloat / 100;
	int blueInt = blueFloat / 100;
	
	NSString *hexKey = @"0123456789ABCDEF";
	
	int red1 = redInt / 16;
	int red2 = redInt % 16;
	
	int green1 = greenInt / 16;
	int green2 = greenInt % 16;
	
	int blue1 = blueInt / 16;
	int blue2 = blueInt % 16;
	
	
	NSString *hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c", [hexKey characterAtIndex:red1], [hexKey characterAtIndex:red2], [hexKey characterAtIndex:green1], [hexKey characterAtIndex:green2], [hexKey characterAtIndex:blue1], [hexKey characterAtIndex:blue2]];
	
return hexString;
}


/*
 Thanks to: http://stackoverflow.com/questions/2144979/is-there-a-conventional-method-for-inverting-nscolor-values/2145080#2145080

 This site: http://www.december.com/html/spec/colorshadesuse.html 
 was also very helpful in helping me to understand how different complementary schemes fit together.
 
 */

-(NSColor *)complement {
    return [NSColor colorWithCalibratedRed:(1.0 - [self redComponent])
                                     green:(1.0 - [self greenComponent])
                                      blue:(1.0 - [self blueComponent])
                                     alpha:[self alphaComponent]];
    
}

/*
 Returns an array of 10 shades of the same hue and saturation.
 */
-(NSArray *)shadeArray {
    
    NSMutableArray *a = [NSMutableArray array];
    float b = 0.0;
    for (int i = 0; i < 10; i++) {
        
        b += 0.1;
        
        NSColor *aColor = [NSColor colorWithCalibratedHue:self.hueComponent saturation:self.saturationComponent brightness:b alpha:1.0];

        

        [a addObject:aColor];
        
        
    }
    
    return [NSArray arrayWithArray:a];
    
}

/*
    Returns an array of two color objects. Twins!
 */

-(NSArray *)twinColorCousinsSeparatedByDegrees:(float)degrees initialOffset:(float)offsetDegrees {
    
    // normalize the 'color' at 1.0 brightness.
    // I made a conscious choice NOT to use the color's brightness value here. If this upsets you, set normalizedColor to self.

//    NSColor *normalizedColor = [NSColor colorWithCalibratedHue:self.hueComponent saturation:self.saturationComponent brightness:1.0 alpha:1.0];

    NSColor *normalizedColor = self;
    
    float decimalOffset = offsetDegrees / 360.0;
    
    float startingDegrees = normalizedColor.hueComponent + decimalOffset;
    
    while (startingDegrees > 1.0) {
        startingDegrees -= 1.0;
    }
    
    float twinIncrement = degrees / 360.0;
    
    float firstHue = startingDegrees + twinIncrement;
    float secondHue = startingDegrees - twinIncrement;
    
    while (firstHue > 1.0) {
        firstHue -= 1.0;
    }

    while (secondHue > 1.0) {
        secondHue -= 1.0;
    }
    
    float brightness;
    brightness = 1.0;
    
    NSColor *firstColor = [NSColor colorWithCalibratedHue:firstHue saturation:normalizedColor.saturationComponent brightness:brightness alpha:1.0];

    NSColor *secondColor = [NSColor colorWithCalibratedHue:secondHue saturation:normalizedColor.saturationComponent brightness:brightness alpha:1.0];
    
    return [NSArray arrayWithObjects:firstColor, secondColor, nil];


}



@end