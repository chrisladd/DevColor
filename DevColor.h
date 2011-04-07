//
//  DevColor.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DCClickableImageView.h"

@class DCColor;

typedef enum codeTypes {
	uicolor, nscolor, hex, rgb, rgba
	
} codeType;

@interface DevColor : NSObject<DCClickableImageViewDelegate, NSTextFieldDelegate> {
    
    
    NSArray *colorHistory;
    NSColor *color0, *color1, *color2, *color3, *color4;
    
    int historyIndex;
	codeType colorMode;
	
    BOOL enjoysQuiet, swatchNeeded;
    
    NSArray *fxArray;
    
    IBOutlet NSMenuItem *soundMenuItem;
    
    IBOutlet NSColorWell *colorWell;
    
	IBOutlet NSComboBox *comboBox;
	IBOutlet NSTextField *copyableTextField;
    IBOutlet NSButton *copyButton;

    IBOutlet DCClickableImageView *lock0, *lock1, *lock2, *lock3, *lock4;
    IBOutlet NSColorWell *historyWell0, *historyWell1, *historyWell2, *historyWell3, *historyWell4, *historyWell5; 
    
    IBOutlet NSView *mainView;
	
    IBOutlet NSSlider *rSlider;
    IBOutlet NSSlider *gSlider;
    IBOutlet NSSlider *bSlider;

    IBOutlet NSSlider *hSlider;
    IBOutlet NSSlider *sSlider;
    IBOutlet NSSlider *tSlider; // t is for brighTness


    float rFloat, gFloat, bFloat, hFloat, sFloat, tFloat;
    
    
}

@property float rFloat, gFloat, bFloat, hFloat, sFloat, tFloat;
@property int historyIndex;
@property codeType colorMode;
@property (retain) NSArray *colorHistory, *fxArray;
@property BOOL enjoysQuiet, swatchNeeded;

@property (retain) NSColor *color0, *color1, *color2, *color3, *color4;

-(void)saveColorHistory;
-(IBAction)toggleSound:(id)sender;
-(IBAction)colorWellUpdated:(id)sender;
-(IBAction)swapColorMode:(id)sender;
-(IBAction)copyCodeToClipboard:(id)sender;

-(void)copyButtonNormal:(NSTimer *)aTimer;
-(void)saveColorHistory;
-(void)refreshHistoryWells;
-(void)setupLocks;
-(void)updateLocks;
-(void)setupColorHistory;
-(BOOL)sliderIsRGBSlider:(NSSlider *)theSlider;
-(NSString *)codeStringForColor:(NSColor *)color;
-(void)resetComboSelection;
-(void)doWelcome;
-(NSString *)welcomePhrase;

-(void)updateShadedColorWellsForColor:(NSColor *)aColor withBaseTag:(int)baseTag;

-(void)resetTextField:(NSTimer *)aTimer;

-(NSColor *)randomColor;

-(void)playRandomSound;

@end
