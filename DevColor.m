//
//  DevColor.m
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//

#import "DevColor.h"
#import "NSColor+hex.h"
@implementation DevColor
@synthesize colorMode;

-(void)awakeFromNib {
	
	self.colorMode = uicolor;
	
	CGFloat lastRed = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastRed"];
	CGFloat lastGreen = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastGreen"];
	CGFloat lastBlue = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastBlue"];
	CGFloat lastAlpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastAlpha"]; 
	NSColor *lastColor = [NSColor colorWithCalibratedRed:lastRed green:lastGreen blue:lastBlue alpha:lastAlpha];
	
//	NSLog(@"lastColor: %@", lastColor);
	
	if (lastColor) {
		[colorWell setColor:lastColor];
	}
	
	int lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastColorMode"];
	
	if (!lastIndex) {
		lastIndex = 0;
	}
	
	[comboBox selectItemAtIndex:lastIndex];
	
	[self swapColorMode:nil];
	[self colorWellUpdated:nil];

}



-(IBAction)colorWellUpdated:(id)sender {
	
	NSColor *color = [colorWell color];
	[[NSUserDefaults standardUserDefaults] setFloat:color.redComponent forKey:@"lastRed"];
	[[NSUserDefaults standardUserDefaults] setFloat:color.greenComponent forKey:@"lastGreen"];
	[[NSUserDefaults standardUserDefaults] setFloat:color.blueComponent forKey:@"lastBlue"];
	[[NSUserDefaults standardUserDefaults] setFloat:color.alphaComponent forKey:@"lastAlpha"];	
	
	NSString *codeString;
	
	switch (self.colorMode) {
		case uicolor:
		codeString = [NSString stringWithFormat:@"[UIColor colorWithRed:%.3f green:%.3f blue:%.3f alpha:%.2f]", color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent];	
			break;
		case nscolor:
			codeString = [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%.2f green:%.2f blue:%.2f alpha:%.2f]", color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent];	
			break;
		case hex:
			codeString = [color hexValue];
			break;
        case rgba:
            codeString = [color rgbaValue];
            break;
        case rgb:
            codeString = [color rgbValue];
            break;

		default:
			break;
	}
	

	copyableTextField.stringValue = codeString;
	
}

-(IBAction)swapColorMode:(id)sender {
	
	int comboIndex = [comboBox indexOfSelectedItem];
	
	[[NSUserDefaults standardUserDefaults] setInteger:comboIndex forKey:@"lastColorMode"];
	
	switch (comboIndex) {
		case 0:
			self.colorMode = uicolor;
			break;
		case 1:
			self.colorMode = nscolor;
			break;
		case 2:
			self.colorMode = hex;
			break;
		case 3:
			self.colorMode = rgba;
			break;
		case 4:
			self.colorMode = rgb;
			break;
	
		default:
			break;
	}

	[self colorWellUpdated:nil];

}

-(IBAction)copyCodeToClipboard:(id)sender {
	
    if (sender != copyButton) {
        [copyButton highlight:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(copyButtonNormal:) userInfo:nil repeats:NO];
    }
    
    
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
	[pb declareTypes:types owner:self];
	
	[pb setString:copyableTextField.stringValue forType:NSStringPboardType];
	
    if ([NSColorPanel sharedColorPanelExists]) {
        [[NSColorPanel sharedColorPanel] close];
        
    }

    
}


-(void)copyButtonNormal:(NSTimer *)aTimer {
    [copyButton highlight:NO];
}


-(void)dealloc {
    [super dealloc];
}


@end
