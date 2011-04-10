//
//  NSColor+devColor.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//
//  Adds support for a variety of return types to NSColor, as well as calculating new ones. 
//
//


#import <Cocoa/Cocoa.h>


@interface NSColor (NSColor_devColor)
-(NSString *)hexValue;
-(NSString *)rgbValue;
-(NSString *)rgbaValue;
-(NSArray *)shadeArray;
-(NSColor *)complement;
-(NSArray *)twinColorCousinsSeparatedByDegrees:(float)degrees initialOffset:(float)offsetDegrees;


/* Color string identification */
+(BOOL)stringIsUIColorHSB:(NSString *)aString;
+(BOOL)stringIsUIColorRGB:(NSString *)aString;
+(BOOL)stringIsUIColor:(NSString *)aString;


+(BOOL)stringIsNSColorHSB:(NSString *)aString;
+(BOOL)stringIsNSColorRGB:(NSString *)aString;
+(BOOL)stringIsNSColor:(NSString *)aString;

+(BOOL)stringIsHex:(NSString *)aString;
+(BOOL)stringIsRGBA:(NSString *)aString;
+(BOOL)stringIsRGB:(NSString *)aString;


/* Color string => NSColor */
+(NSColor *)colorWithRGBString:(NSString *)aString;
+(NSColor *)colorWithHSBString:(NSString *)aString;
+(NSColor *)colorWithHexString:(NSString *)hexString;
+(NSColor *)colorWithWebRGBString:(NSString *)aString;


/* Random color */
+(NSColor *)randomColor;

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


+(NSColor *)colorWithHexString:(NSString *)hexString {
    
    hexString = [hexString uppercaseString];
    
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    hexString = [hexString stringByReplacingOccurrencesOfString:@";" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    
    if (hexString.length != 6) { 

        if (hexString.length == 3) {
            hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c", [hexString characterAtIndex:0],[hexString characterAtIndex:0], [hexString characterAtIndex:1], [hexString characterAtIndex:1], [hexString characterAtIndex:2], [hexString characterAtIndex:2]]; 
        } else {
        return nil;            
            
        }

        
    }
    
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    unsigned redInt;
    unsigned greenInt;
    unsigned blueInt;
    

    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0, 2)]];
    [scanner scanHexInt:&redInt];

    
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2, 2)]];
    [scanner scanHexInt:&greenInt];

    
    scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4, 2)]];
    [scanner scanHexInt:&blueInt];

    
    float rFloat = redInt / 255.0;
    float gFloat = greenInt / 255.0;
    float bFloat = blueInt / 255.0;
    
    NSColor *color = [NSColor colorWithCalibratedRed:rFloat green:gFloat blue:bFloat alpha:1.0];
    
    return color;
    
}



+(NSColor *)colorWithWebRGBString:(NSString *)aString {

    //    rgba(255, 0, 0, 0.2)
    
    aString = [aString stringByReplacingOccurrencesOfString:@"rgba" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, aString.length)];

    aString = [aString stringByReplacingOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, aString.length)];

    aString = [aString stringByReplacingOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, aString.length)];
    
    aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *a = [aString componentsSeparatedByString:@","];
    
    if (a.count < 3) {
        return nil;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    float rFloat = [[formatter numberFromString:[a objectAtIndex:0]] floatValue] / 255.0;
    float gFloat = [[formatter numberFromString:[a objectAtIndex:1]] floatValue] / 255.0;    
    float bFloat = [[formatter numberFromString:[a objectAtIndex:2]] floatValue] / 255.0;    
    
    NSColor *color = [NSColor colorWithCalibratedRed:rFloat green:gFloat blue:bFloat alpha:1.0];
    
    [formatter release];
    
    return color;

    
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





/* Color String Conversion Methods */

+(NSColor *)colorWithRGBString:(NSString *)aString {
    
    NSScanner *scanner = [NSScanner scannerWithString:aString];
    
    NSString *rString;
    NSString *gString;
    NSString *bString;
    
    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];
    
    [scanner scanUpToString:@" " intoString:&rString];
    
    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];

    [scanner scanUpToString:@" " intoString:&gString];

    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];
    
    [scanner scanUpToString:@" " intoString:&bString];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSColor *color = [NSColor colorWithCalibratedRed:[[formatter numberFromString:rString] floatValue] green:[[formatter numberFromString:gString] floatValue] blue:[[formatter numberFromString:bString] floatValue] alpha:1.0];
    
    [formatter release];
    
    return color;

}

+(NSColor *)colorWithHSBString:(NSString *)aString {
    
    NSScanner *scanner = [NSScanner scannerWithString:aString];
    
    NSString *hString;
    NSString *sString;
    NSString *bString;
    
    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];
    
    [scanner scanUpToString:@" " intoString:&hString];
    
    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];
    
    [scanner scanUpToString:@" " intoString:&sString];
    
    [scanner scanUpToString:@":" intoString:nil];
    [scanner setScanLocation:[scanner scanLocation] + 1];
    
    [scanner scanUpToString:@" " intoString:&bString];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSColor *color = [NSColor colorWithCalibratedHue:[[formatter numberFromString:hString] floatValue] saturation:[[formatter numberFromString:sString] floatValue] brightness:[[formatter numberFromString:bString] floatValue] alpha:1.0];
    
    [formatter release];
    
    return color;
    
}





/* Color String ID Methods */

+(BOOL)stringIsNSColor:(NSString *)aString {
    
    //    + (NSColor *)colorWithCalibratedRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
    
    if ([aString rangeOfString:@"[NSColor "].location != NSNotFound) {
        return YES;
    }
    
    return NO;
    
}

+(BOOL)stringIsNSColorRGB:(NSString *)aString {
    //    + (NSColor *)colorWithCalibratedRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
    
    
    if ([aString rangeOfString:@"colorWithCalibratedRed:"].location == NSNotFound) {
        return NO;
        
        if ([aString rangeOfString:@"green:"].location == NSNotFound) {
            return NO;
            
            if ([aString rangeOfString:@"blue:"].location == NSNotFound) {
                return NO;
                
                
            }        
            
            
        }        
        
    }
    
    
    return YES;
}



+(BOOL)stringIsNSColorHSB:(NSString *)aString {
    //+ (NSColor *)colorWithCalibratedHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
    
    
    if ([aString rangeOfString:@"colorWithCalibratedHue:"].location == NSNotFound) {
        return NO;
        
        if ([aString rangeOfString:@"saturation:"].location == NSNotFound) {
            return NO;
            
            if ([aString rangeOfString:@"brightness:"].location == NSNotFound) {
                return NO;
                
                
            }        
            
            
        }        
        
    }
    
    
    return YES;
    
}





+(BOOL)stringIsUIColor:(NSString *)aString {
    if ([aString rangeOfString:@"[UIColor "].location != NSNotFound) {
        return YES;
    }
    
    return NO;
    
}



+(BOOL)stringIsUIColorHSB:(NSString *)aString {
    // + (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
    
    if ([aString rangeOfString:@"colorWithHue:"].location == NSNotFound) {
        return NO;
        
        if ([aString rangeOfString:@"saturation:"].location == NSNotFound) {
            return NO;
            
            if ([aString rangeOfString:@"brightness:"].location == NSNotFound) {
                return NO;
                
                
            }        
            
            
        }        
        
    }
    
    
    return YES;
    
}




+(BOOL)stringIsUIColorRGB:(NSString *)aString {
    
    //        [UIColor colorWithRed:0.524 green:0.756 blue:0.989 alpha:1.00]
    
    if ([aString rangeOfString:@"colorWithRed:"].location == NSNotFound) {
        return NO;
        
        if ([aString rangeOfString:@"green:"].location == NSNotFound) {
            return NO;
            
            if ([aString rangeOfString:@"blue:"].location == NSNotFound) {
                return NO;
                
                
            }        
            
            
        }        
        
    }
    
    
    return YES;
}


+(BOOL)stringIsHex:(NSString *)aString {
    
    NSString *tString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    tString = [tString stringByReplacingOccurrencesOfString:@";" withString:@""];
    tString = [tString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    
    if (tString.length == 6) { // don't worry if there are characters out of range -- we'll clip them to black in the conversion.
        return YES;
        
    }
    
    if (tString.length == 3) {
        return YES;
    }
    
    return NO;
    
}

+(BOOL)stringIsRGBA:(NSString *)aString {
    NSString *tString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (tString.length > 4) {
        if ([[[tString substringToIndex:4] lowercaseString] isEqualToString:@"rgba"]) {
            return YES;
            
        }
    }
    
    return NO;
}


+(BOOL)stringIsRGB:(NSString *)aString {
    NSString *tString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (tString.length > 4) {
        if ([[[tString substringToIndex:3] lowercaseString] isEqualToString:@"rgb"]) {
            
            
            
        }
    }
    
    return NO;
}


+(NSColor *)randomColor {
    float redFloat;
    float greenFloat;
    float blueFloat;
    
    redFloat = (arc4random() % 100) / 100.0;
    greenFloat = (arc4random() % 100) / 100.0;        
    blueFloat = (arc4random() % 100) / 100.0;
    
    NSColor *aColor = [NSColor colorWithCalibratedRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
    
    return aColor;
    
}




@end