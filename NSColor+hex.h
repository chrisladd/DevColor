//
//  NSColor+hex.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (NSColor_hex)
-(NSString *)hexValue;
-(NSString *)rgbValue;
-(NSString *)rgbaValue;

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


@end




