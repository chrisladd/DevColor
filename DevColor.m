//
//  DevColor.m
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//

#import "DevColor.h"
#import "NSColor+hex.h"
#import "DCColor.h"

@implementation DevColor
@synthesize colorMode, colorHistory, historyIndex, enjoysQuiet, fxArray, swatchNeeded;

#define MAIN_SHADES_BASE_TAG 400
#define COMPLENENT_BASE_TAG 500
#define SPLIT_COMPLEMENT_BASE1 600
#define SPLIT_COMPLEMENT_BASE2 700



#define HISTORY_WELL_BASE_TAG 900
#define LOCK_BASE_TAG 800
#define HISTORY_LENGTH 5


-(void)awakeFromNib {
	
    
    
	self.colorMode = uicolor;
	self.historyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"dColorIndex"];

    BOOL needsColorHistory = YES;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"dColorData"];


    if ([colorData isKindOfClass:[NSData class]]) {

        NSData *filthyHistory = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
        if ([filthyHistory isKindOfClass:[NSArray class]]) {
            NSArray *historyArray = (NSArray *)filthyHistory;
            
            DCColor *c0 = [historyArray objectAtIndex:0];
            DCColor *c1 = [historyArray objectAtIndex:1];
            DCColor *c2 = [historyArray objectAtIndex:2];
            DCColor *c3 = [historyArray objectAtIndex:3];
            DCColor *c4 = [historyArray objectAtIndex:4];

            self.color0 = c0.color;
            self.color0 = c1.color;
            self.color0 = c2.color;
            self.color0 = c3.color;
            self.color0 = c4.color;

            self.colorHistory = historyArray;
            
            needsColorHistory = NO;
        
        }
    }
    
    soundMenuItem.target = self;
    soundMenuItem.action = @selector(toggleSound:);
    
    self.enjoysQuiet = [[NSUserDefaults standardUserDefaults] boolForKey:@"enjoysQuiet"];
    
    if (self.enjoysQuiet) {
        soundMenuItem.state = NSOffState;
    } else {
        soundMenuItem.state = NSOnState;
        
    }
    
    if (needsColorHistory) {
        [self setupColorHistory];
        
    }
    
    
    
    [self setupLocks];
    [self updateLocks];
    
    
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

    [self refreshHistoryWells];
    
    
    
    // and the sound fx
  
    NSSound *sound1 = [NSSound soundNamed:@"bip2.aif"];
    NSSound *sound2 = [NSSound soundNamed:@"bip3.aif"];    
    
    sound1.volume = 0.1;
    sound2.volume = 0.1;    

    self.fxArray = [NSArray arrayWithObjects:sound1, sound2, nil];
    
    
}


-(void)setupColorHistory {
    
    NSMutableArray *preColors = [NSMutableArray array];
    
    for (int i = 0; i < HISTORY_LENGTH; i++) {
        
        NSColor *rColor = [self randomColor];
        DCColor *dColor = [DCColor colorWithNSColor:rColor];
        
        [preColors addObject:dColor];
        
    }
  
    
    self.colorHistory = [NSArray arrayWithArray:preColors];
    [self saveColorHistory];
    
}


-(NSColor *)randomColor {
    float redFloat;
    float greenFloat;
    float blueFloat;

    redFloat = (arc4random() % 100) / 100.0;
    greenFloat = (arc4random() % 100) / 100.0;        
    blueFloat = (arc4random() % 100) / 100.0;

    NSColor *aColor = [NSColor colorWithCalibratedRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
    
    return aColor;
    
}


-(void)saveColorHistory {
    
    if (self.colorHistory) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.colorHistory];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"dColorData"];

    }
    
}



-(NSColor *)color0 {
    return color0;
    
}

-(NSColor *)color1 {
    return color1;
    
}
-(NSColor *)color2 {
    return color2;
    
}

-(NSColor *)color3 {
    return color3;
    
}
-(NSColor *)color4 {
    return color4;
    
}


-(void)setColor0:(NSColor *)aColor {
    color0 = aColor;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:0];
    
    if (aColor) {
        dColor.color = color0;
    }
    
    [self saveColorHistory];
    self.swatchNeeded = NO;
}


-(void)setColor1:(NSColor *)aColor {
    color1 = aColor;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:1];
    
    if (aColor) {
        dColor.color = color1;
    }
    
    [self saveColorHistory];
       self.swatchNeeded = NO;
}


-(void)setColor2:(NSColor *)aColor {
    color2 = aColor;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:2];
    
    if (aColor) {
        dColor.color = color2;
    }
    
    [self saveColorHistory];
    self.swatchNeeded = NO;    
}


-(void)setColor3:(NSColor *)aColor {
    color3 = aColor;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:3];
    
    if (aColor) {
        dColor.color = color3;
    }
    
    [self saveColorHistory];
    self.swatchNeeded = NO;    
}


-(void)setColor4:(NSColor *)aColor {
    color4 = aColor;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:4];
    
    if (aColor) {
        dColor.color = color4;
    }
    
    [self saveColorHistory];
    self.swatchNeeded = NO;    
}



-(IBAction)toggleSound:(id)sender {
    
    if (self.enjoysQuiet) {
        self.enjoysQuiet = NO;
    } else {
        self.enjoysQuiet = YES;
    }
    
    if (self.enjoysQuiet) {
        soundMenuItem.state = NSOffState;
    } else {
        soundMenuItem.state = NSOnState;
        
    }    
    
    [[NSUserDefaults standardUserDefaults] setBool:self.enjoysQuiet forKey:@"enjoysQuiet"];
    
}


-(IBAction)colorWellUpdated:(id)sender {
	
	NSColor *color = [colorWell color];
    
    // update the sliders
    rSlider.floatValue = color.redComponent;
    gSlider.floatValue = color.greenComponent;    
    bSlider.floatValue = color.blueComponent;    
    
    
    hSlider.floatValue = color.hueComponent;
    sSlider.floatValue = color.saturationComponent;    
    tSlider.floatValue = color.brightnessComponent;    

    NSColor *complement = [color complement];
    [self updateShadedColorWellsForColor:complement withBaseTag:COMPLENENT_BASE_TAG];
    [self updateShadedColorWellsForColor:color withBaseTag:MAIN_SHADES_BASE_TAG];
    
    NSArray *splitComplements = [complement twinColorCousinsSeparatedByDegrees:20.0 initialOffset:0.0];
    
    [self updateShadedColorWellsForColor:[splitComplements objectAtIndex:0] withBaseTag:SPLIT_COMPLEMENT_BASE1];
    [self updateShadedColorWellsForColor:[splitComplements objectAtIndex:1] withBaseTag:SPLIT_COMPLEMENT_BASE2];

    
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
	self.swatchNeeded = YES;
    
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
    
    
    
    // Play a random sound. You know, for fun.
    
    if (!self.enjoysQuiet) {
        
        int soundIndex = (arc4random() % self.fxArray.count);
        NSSound *aSound = [self.fxArray objectAtIndex:soundIndex];

        [aSound play];
        
    }
    

    
    // and save our color, since our user obviously likes it.
    // swap the color in our colorHistory.
    
    if (self.swatchNeeded) {
    
            NSColor *color = colorWell.color;
            DCColor *onDeckDCColor;
            
            int i = 0;
            
            while (i < HISTORY_LENGTH) {
                self.historyIndex = (self.historyIndex + 1) % HISTORY_LENGTH;
                onDeckDCColor = [self.colorHistory objectAtIndex:self.historyIndex];
                
                if (!onDeckDCColor.isLocked) {
                    
                    // reset the color
                    onDeckDCColor.color = color;
                    
                    
                    // and the color well. You should be doing this with KVO, but oh well...
                    int wellGrabberInt = HISTORY_WELL_BASE_TAG + self.historyIndex;
                    NSColorWell *aWell = [mainView viewWithTag:wellGrabberInt];
                    aWell.color = color;
                    
                    // we no longer need a swatch -- we'll need one again when the Main color well is updated
                    self.swatchNeeded = NO;
                    
                    break;
                }
                
                
                i++;
            }
            [self saveColorHistory];

    }
}



-(void)updateShadedColorWellsForColor:(NSColor *)aColor withBaseTag:(int)baseTag {

    NSArray *colorArray = [aColor shadeArray];
    
    for (int i = 0; i < colorArray.count; i++) {
        int aTag = baseTag + i;
        
        NSColorWell *aColorWell = [mainView viewWithTag:aTag];
        aColorWell.color = [colorArray objectAtIndex:i];
        
    }
    
    
}



-(BOOL)clickFromDCClickableImageView:(NSImageView *)imageView {
    
    int colorIndex = imageView.tag - LOCK_BASE_TAG;
    
    DCColor *dColor = [self.colorHistory objectAtIndex:colorIndex];
    BOOL shouldLock;
    
    if (dColor.isLocked) {
        dColor.isLocked = NO;
        shouldLock = NO;
    } else {
        dColor.isLocked = YES;
        shouldLock = YES;
    }

    [self saveColorHistory];
    
    return shouldLock;
}


-(void)setupLocks {
    
    
    lock0.delegate = self;
    lock1.delegate = self;
    lock2.delegate = self;
    lock3.delegate = self;
    lock4.delegate = self;

    
    
}




-(void)updateLocks {
    
    int i = 0;
    for (DCColor *color in self.colorHistory) {
        
        if ([color isKindOfClass:[DCColor class]]) {
            
            int lockGrabberInt = LOCK_BASE_TAG + i;
            
            DCClickableImageView *lockImageView = [mainView viewWithTag:lockGrabberInt];
            
            if (color.isLocked) {
                [lockImageView shouldLock:YES];
                
            } else {
                [lockImageView shouldLock:NO];
                
            }
        
        }
        
        
        i++;
    }

     
}

-(void)refreshHistoryWells {
    int i = 0;
    for (DCColor *dColor in self.colorHistory) {
    
        int wellGrabberInt = HISTORY_WELL_BASE_TAG + i;
        
        NSColorWell *aWell = [mainView viewWithTag:wellGrabberInt];
        
        if ([aWell isKindOfClass:[NSColorWell class]]) {
            
            [aWell setColor:dColor.color];

        }


        
        i++;
    }
    
}


-(void)copyButtonNormal:(NSTimer *)aTimer {
    [copyButton highlight:NO];

}


-(void)dealloc {

    lock0.delegate = nil;
    lock1.delegate = nil;
    lock2.delegate = nil;
    lock3.delegate = nil;
    lock4.delegate = nil;

    self.colorHistory = nil;
    self.fxArray = nil;
    
    [super dealloc];
}


-(BOOL)sliderIsRGBSlider:(id)theSlider {
    
    if (theSlider == rSlider) {
        return YES;
    } else if (theSlider == gSlider) {
        return YES;
        
    } else if (theSlider == bSlider) {
        return YES;
        
    } else {
        return NO;
    }
    
    
}


-(IBAction)updateColorFromSlider:(id)sender {
    
    if ([self sliderIsRGBSlider:sender]) {
        
        NSColor *aColor = [NSColor colorWithCalibratedRed:rSlider.floatValue green:gSlider.floatValue blue:bSlider.floatValue alpha:1.0];
        
        colorWell.color = aColor;
        [self colorWellUpdated:nil];
        
        
    } else {
            NSColor *aColor = [NSColor colorWithCalibratedHue:hSlider.floatValue saturation:sSlider.floatValue brightness:tSlider.floatValue alpha:1.0];
            
            colorWell.color = aColor;
            [self colorWellUpdated:nil];
            
    }
}



@end
