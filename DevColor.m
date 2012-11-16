//
//    Copyright (C) 2011 by Christopher Ladd
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//
//  DevColor.m
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//

#import "DevColor.h"
#import "NSColor+devColor.h"
#import "DCColor.h"

@implementation DevColor
@synthesize colorMode, colorHistory, historyIndex, enjoysQuiet, fxArray, swatchNeeded, wantsSemiColon, wantsHSB, wantsSet;

#define MAIN_SHADES_BASE_TAG 400
#define COMPLENENT_BASE_TAG 500
#define SPLIT_COMPLEMENT_BASE1 600
#define SPLIT_COMPLEMENT_BASE2 700

#define HISTORY_WELL_BASE_TAG 900
#define LOCK_BASE_TAG 800
#define HISTORY_LENGTH 5


- (NSColor *)colorFromScreenAtPoint:(NSPoint)point {
    CGImageRef image = CGDisplayCreateImageForRect(CGMainDisplayID(), CGRectMake(point.x, point.y, 1, 1));
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
    CGImageRelease(image);
    NSColor *color = [bitmap colorAtX:0 y:0];
    [bitmap release];
    
    return color;
    
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSLog(@"%@", theEvent);
}

-(void)awakeFromNib {
    [self resetComboSelection];

    // set up the app
    [self setupColorHistory];
    [self setupMenuItems];
    [self setupLocks];
    [self updateLocks];
    
    [self setupColorWell];
    
    [self refreshHistoryWells];
    
    [self setupSound];
    [self setupEvents];    

    // make sure the panel can be seen
    [panel makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];

    // and welcome the nice people
    [self doWelcome];

    
}

-(void)setupSound {
    
    NSSound *sound1 = [NSSound soundNamed:@"bip2.aif"];
    NSSound *sound2 = [NSSound soundNamed:@"bip3.aif"];    
    
    sound1.volume = 0.1;
    sound2.volume = 0.1;    
    
    self.fxArray = [NSArray arrayWithObjects:sound1, sound2, nil];

    
}


-(void)setupColorWell {
    
    CGFloat lastRed = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastRed"];
	CGFloat lastGreen = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastGreen"];
	CGFloat lastBlue = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastBlue"];
	NSColor *lastColor = [NSColor colorWithCalibratedRed:lastRed green:lastGreen blue:lastBlue alpha:1.0];
	
	if (lastColor) {
		[colorWell setColor:lastColor];
	} else {
        [colorWell setColor:[NSColor randomColor]];
    }
	
	[self swapColorMode:nil];
	[self colorWellUpdated:nil];
    

    
}

- (void)showPanel:(id)sender {
    [panel makeKeyAndOrderFront:nil];
}

-(void)setupEvents {

//    [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask
//                                           handler:^(NSEvent *incomingEvent) {
//                                                NSPoint eventLocation = [NSEvent mouseLocation];
//                                                NSColor *color = [self colorFromScreenAtPoint:eventLocation];
//                                                [self setColor:color];
//                                                NSLog(@"%@", color);
//                                           }];
//    
//    
    
    

    // register for keydown notifications...
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
                                          handler:^(NSEvent *incomingEvent) {
                                              
                                              NSEvent *result = incomingEvent;
                                              
                                              char aChar = [result.characters characterAtIndex:0];
                                              
                                              if (aChar == 's') {
                                                  [self showPanel:nil];
                                                  result = nil;
                                              }
                                              
                                              if (aChar == 'c') {
                                                  [self copyCodeToClipboard:nil];
                                                  result = nil;
                                              }                                              
                                              
                                              // give the cutters a surprise...
                                              if (aChar == 'x') { 
                                                  [self copyCodeToClipboard:nil];
                                                  [self doWelcomeWithReset:NO];
                                                  result = nil;
                                              }                                              
                                              
                                              if (aChar == 'v') {
                                                  [self parseColorFromPasteboard:nil];
                                                  result = nil;
                                              }
                                              
                                              if (aChar == 'r') {
                                                  [self updateWithRandomColor:nil];
                                                  result = nil;
                                              }
                                              
                                              if (aChar == '=' | aChar == '+' | aChar == '-' | aChar == '_') {
                                                  if (aChar == '-' | aChar == '_') {
                                                      [self decrementHue:nil];
                                                      
                                                  } else {
                                                      [self incrementHue:nil];
                                                      
                                                  }
                                                  
                                                  result = nil;
                                              }
                                              
                                              // saturation  
                                              if (aChar == ']' || aChar == '[') {
                                                  if (aChar == '[') {
                                                      [self decrementSaturation:nil];
                                                      
                                                  } else {
                                                      [self incrementSaturation:nil];
                                                  }
                                                  
                                                  result = nil;
                                              }
                                              
                                              // brightness
                                              if (aChar == ';' | aChar == ':' | aChar == '\'' | aChar == '"') {
                                                  if (aChar == ';' | aChar == ':') {
                                                      [self decrementBrightness:nil];
                                                      
                                                  } else {
                                                      [self incrementBrightness:nil];
                                                  }
                                                  result = nil;
                                              }

                                              return result;
                                          }];
}

-(void)setupMenuItems {
    
    self.enjoysQuiet = [[NSUserDefaults standardUserDefaults] boolForKey:@"enjoysQuiet"];
    
    if (self.enjoysQuiet) {
        soundMenuItem.state = NSOffState;
    } else {
        soundMenuItem.state = NSOnState;
        
    }
    
    
    self.wantsHSB = [[NSUserDefaults standardUserDefaults] boolForKey:@"wantsHSB"];
    
    if (self.wantsHSB) {
        RGBMenuItem.state = NSOffState;
    } else {
        RGBMenuItem.state = NSOnState;
    }
    

    self.wantsSemiColon = [[NSUserDefaults standardUserDefaults] boolForKey:@"wantsSemiColon"];
    
    if (self.wantsSemiColon) {
        addSemiColonMenuItem.state = NSOnState;
    } else {
        addSemiColonMenuItem.state = NSOffState;
    }
    
    
    
    self.wantsSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"wantsSet"];
    
    if (self.wantsSet) {
        addSetMenuItem.state = NSOnState;
    } else {
        addSetMenuItem.state = NSOffState;
    }


    
    
}


-(IBAction)incrementHue:(id)sender {
    NSColor *color = colorWell.color;
    
    float hueFloat = color.hueComponent;
    
        if (hueFloat < 1.0) {
            hueFloat += 0.01;                                                          
        }
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:hueFloat saturation:color.saturationComponent brightness:color.brightnessComponent alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;
    
}

-(IBAction)decrementHue:(id)sender {
    
    NSColor *color = colorWell.color;
    
    float hueFloat = color.hueComponent;
    
        if (hueFloat > 0) {
            hueFloat -= 0.01;
        }
    
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:hueFloat saturation:color.saturationComponent brightness:color.brightnessComponent alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;

}




-(IBAction)incrementSaturation:(id)sender {
    
    NSColor *color = colorWell.color;
    
    float satFloat = color.saturationComponent;
    
        if (satFloat < 1.0) {
            satFloat += 0.01;                                                          
        }
    
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:color.hueComponent saturation:satFloat brightness:color.brightnessComponent alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;
}


-(IBAction)decrementSaturation:(id)sender {
    NSColor *color = colorWell.color;
    
    float satFloat = color.saturationComponent;
    
        if (satFloat > 0) {
            satFloat -= 0.01;
        }
    
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:color.hueComponent saturation:satFloat brightness:color.brightnessComponent alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;
    
}


-(IBAction)incrementBrightness:(id)sender {
    
    NSColor *color = colorWell.color;
    
    float brightFloat = color.brightnessComponent;
    
        if (brightFloat < 1.0) {
            brightFloat += 0.01;                                                          
        }
    
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:color.hueComponent saturation:color.saturationComponent brightness:brightFloat alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;

    
    
}


- (void)setColor:(NSColor *)color {
    colorWell.color = color;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;
}

-(IBAction)decrementBrightness:(id)sender {
    
    NSColor *color = colorWell.color;
    
    float brightFloat = color.brightnessComponent;
    
        if (brightFloat > 0) {
            brightFloat -= 0.01;
        }
        
    
    
    NSColor *newColor = [NSColor colorWithCalibratedHue:color.hueComponent saturation:color.saturationComponent brightness:brightFloat alpha:1.0];
    
    
    colorWell.color = newColor;
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;

}



-(void)doWelcome {
    [self doWelcomeWithReset:YES];
    
    
}


-(void)doWelcomeWithReset:(BOOL)doesReset {
    NSString *welcomePhrase = [self welcomePhrase];
    
    copyableTextField.stringValue = welcomePhrase;

    
    if (doesReset) {
    [NSTimer scheduledTimerWithTimeInterval:2.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];
    
    }
    
}


-(void)resetComboSelection {
    int lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastColorMode"];
	
	if (lastIndex < 0 || lastIndex > ([comboBox numberOfItems] - 1)) {
		lastIndex = 0;
	}
	
	[comboBox selectItemAtIndex:lastIndex];
    
}

-(void)setupColorHistory {
    
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
    
    
    if (needsColorHistory) {
        NSMutableArray *preColors = [NSMutableArray array];
        
        for (int i = 0; i < HISTORY_LENGTH; i++) {
            
            NSColor *rColor = [NSColor randomColor];
            DCColor *dColor = [DCColor colorWithNSColor:rColor];
            
            [preColors addObject:dColor];
            
        }
        
        
        self.colorHistory = [NSArray arrayWithArray:preColors];
        [self saveColorHistory];
        
    }
    
    
}




-(IBAction)updateWithRandomColor:(id)sender {
    
    colorWell.color = [NSColor randomColor];
    [self colorWellUpdated:nil];
    self.swatchNeeded = YES;

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


-(IBAction)toggleRGB:(id)sender {
    
    if (self.wantsHSB) {
        self.wantsHSB = NO;
    } else {
        self.wantsHSB = YES;
    }
    
    if (self.wantsHSB) {
        RGBMenuItem.state = NSOffState;
    } else {
        RGBMenuItem.state = NSOnState;
        
    }    
    
    [[NSUserDefaults standardUserDefaults] setBool:self.wantsHSB forKey:@"wantsHSB"];
    
    [self colorWellUpdated:nil];
}


-(IBAction)toggleSemiColon:(id)sender {
    
    if (self.wantsSemiColon) {
        self.wantsSemiColon = NO;
    } else {
        self.wantsSemiColon = YES;
    }
    
    if (self.wantsSemiColon) {
        addSemiColonMenuItem.state = NSOnState;
    } else {
        addSemiColonMenuItem.state = NSOffState;
        
    }    
    
    [[NSUserDefaults standardUserDefaults] setBool:self.wantsSemiColon forKey:@"wantsSemiColon"];
    
    [self colorWellUpdated:nil];

}



-(IBAction)toggleSet:(id)sender {
    
    if (self.wantsSet) {
        self.wantsSet = NO;
    } else {
        self.wantsSet = YES;
    }
    
    if (self.wantsSet) {
        addSetMenuItem.state = NSOnState;
    } else {
        addSetMenuItem.state = NSOffState;
        
    }    
    
    [[NSUserDefaults standardUserDefaults] setBool:self.wantsSet forKey:@"wantsSet"];
    
    [self colorWellUpdated:nil];
    
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
	
    NSString *codeString = [self codeStringForColor:color];

	copyableTextField.stringValue = codeString;
	self.swatchNeeded = YES;
    
}


- (BOOL)colorIsGrayscale:(NSColor *)color {
    int red = color.redComponent * 1000;
    int green = color.greenComponent * 1000;
    int blue = color.blueComponent * 1000;
    
    if (red == green && red == blue && green == blue && green == red) {
        return YES;
    }
    
    
    return NO;
}

-(NSString *)codeStringForColor:(NSColor *)color {
    
    NSString *codeString = @"";
	
	switch (self.colorMode) {
		case uicolor:
            
            if ([self colorIsGrayscale:color]) {
                codeString = [NSString stringWithFormat:@"[UIColor colorWithWhite:%.3f alpha:1.0]", color.redComponent];
            }
            else if (self.wantsHSB) {
                codeString = [NSString stringWithFormat:@"[UIColor colorWithHue:%.3f saturation:%.3f brightness:%.3f alpha:1.0]", color.hueComponent, color.saturationComponent, color.brightnessComponent];

                
            }
            else {
                codeString = [NSString stringWithFormat:@"[UIColor colorWithRed:%.3f green:%.3f blue:%.3f alpha:%.2f]", color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent];	    
                              
            }
            

            if (self.wantsSet) { // [[...] set];
                codeString = [NSString stringWithFormat:@"[%@ set];", codeString];
            } else if (self.wantsSemiColon) {
                codeString = [NSString stringWithFormat:@"%@;", codeString];
                
            }

            
            break;
		case nscolor:
            
            if (self.wantsHSB) {
                codeString = [NSString stringWithFormat:@"[NSColor colorWithCalibratedHue:%.3f saturation:%.3f brightness:%.3f alpha:1.0]", color.hueComponent, color.saturationComponent, color.brightnessComponent];
            
            } else {
                codeString = [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%.3f green:%.3f blue:%.3f alpha:1.0]", color.redComponent, color.greenComponent, color.blueComponent];

            }

            
            if (self.wantsSet) { // [[...] set];
                codeString = [NSString stringWithFormat:@"[%@ set];", codeString];
            } else if (self.wantsSemiColon) {
                codeString = [NSString stringWithFormat:@"%@;", codeString];
                
            }

				
            
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
        case java:
            if (self.wantsHSB) {
                codeString = [color javaHSVValue];
            }
            else {
                codeString = [color javaRGBValue];
            }
            break;
        case cgcolor:
            codeString = [color cgColorValue];
            break;
		default:
			break;
	}
	

    return codeString;    
    
    
    
}


-(IBAction)swapColorMode:(id)sender {
    int comboIndex = [comboBox indexOfSelectedItem];

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
		case 5:
			self.colorMode = java;
			break;
		case 6:
			self.colorMode = cgcolor;
			break;
		default:
			break;
	}
    
	[[NSUserDefaults standardUserDefaults] setInteger:comboIndex forKey:@"lastColorMode"];        
    
	[self colorWellUpdated:nil];

}
- (IBAction)updateColorFromWell:(NSObject *)sender {
    if ([sender respondsToSelector:@selector(tag)]) {
        int tag = (int)[sender performSelector:@selector(tag)];
        tag /= 10;
        NSView *possibleColorWell = [mainView viewWithTag:tag];
        
        if ([possibleColorWell isKindOfClass:[NSColorWell class]]) {
            [self setColor:[(NSColorWell *)possibleColorWell color]];
        }
    }
}

-(IBAction)copyCodeToClipboard:(id)sender {
	

    // guard against zealous copiers!
    if ([copyableTextField.stringValue isEqualToString:@"Copied!"]) {
        copyableTextField.stringValue = [self codeStringForColor:[colorWell color]];
        
    }
    
    
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
	[pb declareTypes:types owner:self];
	
	[pb setString:copyableTextField.stringValue forType:NSStringPboardType];
	
    if ([NSColorPanel sharedColorPanelExists]) {
        [[NSColorPanel sharedColorPanel] close];
        
    }

    NSString *colorString = copyableTextField.stringValue;
    [copyButton highlight:YES];
    

    // flash a nice notification.
    copyableTextField.stringValue = @"Copied!";
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(copyButtonNormal:) userInfo:colorString repeats:NO];
    
    
    
    
    
    // Play a random sound. You know, for fun.
    [self playRandomSound];
    
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


-(void)playRandomSound {
    
    if (!self.enjoysQuiet) {
        
        int soundIndex = (arc4random() % self.fxArray.count);
        NSSound *aSound = [self.fxArray objectAtIndex:soundIndex];
        
        [aSound play];
        
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
        
        [aWell setTarget:self];
        [aWell setAction:@selector(updateColorFromWell:)];
        
        if ([aWell isKindOfClass:[NSColorWell class]]) {
            
            [aWell setColor:dColor.color];

        }


        
        i++;
    }
    
}

-(void)resetTextField:(NSTimer *)aTimer {
    copyableTextField.stringValue = [self codeStringForColor:[colorWell color]];
    [self playRandomSound];
    
}



-(void)copyButtonNormal:(NSTimer *)aTimer {
    [copyButton highlight:NO];
    copyableTextField.stringValue = aTimer.userInfo;

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


-(NSString *)welcomePhrase {
    
    NSArray *verbArray = [NSArray arrayWithObjects:@"pack", @"clean", @"fold", @"unload", @"load", @"archive", @"reverse-engineer", @"eat", @"tidy", nil];

    NSArray *nounArray = [NSArray arrayWithObjects:@"eggs", @"laundry", @"couch cushions", @"desk", @"truck", @"biplane", @"automobile", @"bicycle", @"shirt-tails", @"kiwis", @"bananas", @"favorite mug", @"midnight snack", nil];
    
    NSString *verb = [verbArray objectAtIndex:(arc4random() % verbArray.count)];
    NSString *noun = [nounArray objectAtIndex:(arc4random() % nounArray.count)];    
    
    NSString *welcomeString = [NSString stringWithFormat:@"DevColor will %@ your %@.", verb, noun];
    
    return welcomeString;
}




-(void)parseColorFromPasteboard:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [[[NSArray alloc] initWithObjects:[NSString class], nil] autorelease];
    NSDictionary *options = [NSDictionary dictionary];
    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
    if (copiedItems != nil) {
        
        
        NSString *pString = [copiedItems objectAtIndex:0];
        pString = [pString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // UIColors
        if ([NSColor stringIsUIColor:pString]) {
            
            if ([NSColor stringIsUIColorRGB:pString]) {
                NSColor *color = [NSColor colorWithRGBString:pString];
                colorWell.color = color;
                [self colorWellUpdated:nil];

                
            } else if ([NSColor stringIsUIColorHSB:pString]) {
                NSColor *color = [NSColor colorWithHSBString:pString];
                colorWell.color = color;
                [self colorWellUpdated:nil];


            }
            copyableTextField.stringValue = [NSString stringWithFormat:@"Grabbed UIColor from Clipboard!"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];

             return;
        }
        

        // NSColors
        if ([NSColor stringIsNSColor:pString]) {
            
            if ([NSColor stringIsNSColorRGB:pString]) {
                NSColor *color = [NSColor colorWithRGBString:pString];
                colorWell.color = color;
                [self colorWellUpdated:nil];
                
                
            } else if ([NSColor stringIsNSColorHSB:pString]) {
                NSColor *color = [NSColor colorWithHSBString:pString];
                colorWell.color = color;
                [self colorWellUpdated:nil];
                

            }

            copyableTextField.stringValue = [NSString stringWithFormat:@"Grabbed NSColor from Clipboard!"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];

            return;
        
        }
        

        
        // Hex
        if ([NSColor stringIsHex:pString]) {
            NSColor *color = [NSColor colorWithHexString:pString];
            colorWell.color = color;
            [self colorWellUpdated:nil];

            copyableTextField.stringValue = [NSString stringWithFormat:@"Grabbed Hex Color from Clipboard!"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];

            return;
            
        }
        
        
        
        // rgba
        if ([NSColor stringIsRGBA:pString]) {
            NSColor *color = [NSColor colorWithWebRGBString:pString];
            colorWell.color = color;
            [self colorWellUpdated:nil];
        
            copyableTextField.stringValue = [NSString stringWithFormat:@"Grabbed RGBA Color from Clipboard!"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];

            return;
            
        }
        
        
        // rgb
        if ([NSColor stringIsRGB:pString]) {
            NSColor *color = [NSColor colorWithWebRGBString:pString];
            colorWell.color = color;
            [self colorWellUpdated:nil];

            copyableTextField.stringValue = [NSString stringWithFormat:@"Grabbed RGB Color from Clipboard!"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];
            return;
        }
        

        // if we've arrived here, we've been unsuccessful... 
        // flash a nice notification.
        copyableTextField.stringValue = [NSString stringWithFormat:@"Unable to parse! You entered: \n%@", pString];
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(resetTextField:) userInfo:nil repeats:NO];

        
    }
    




}




-(void)dealloc {
    
    lock0.delegate = nil;
    lock1.delegate = nil;
    lock2.delegate = nil;
    lock3.delegate = nil;
    lock4.delegate = nil;
    
    self.colorHistory = nil;
    self.fxArray = nil;
    
    self.color0 = nil;
    self.color1 = nil;
    self.color2 = nil;
    self.color3 = nil;
    self.color4 = nil;
    
    
    [super dealloc];
}



@end
