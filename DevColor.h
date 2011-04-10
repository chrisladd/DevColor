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

	codeType colorMode;
    
    // color history
    int historyIndex;    
    NSArray *colorHistory;
    NSColor *color0, *color1, *color2, *color3, *color4;

    // color wells
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSColorWell *historyWell0, *historyWell1, *historyWell2, *historyWell3, *historyWell4; 

    // sounds
    NSArray *fxArray;
    
    // menu items & settings.
    IBOutlet NSMenuItem *soundMenuItem, *RGBMenuItem, *addSemiColonMenuItem, *addSetMenuItem;
    BOOL enjoysQuiet, swatchNeeded, wantsHSB, wantsSemiColon, wantsSet;
    
    
	// controls
    IBOutlet NSComboBox *comboBox;
    IBOutlet NSTextField *copyableTextField;
    IBOutlet NSButton *copyButton;
    IBOutlet NSSlider *rSlider, *gSlider, *bSlider, *hSlider, *sSlider, *tSlider; // t is for 'brighTness'
    IBOutlet DCClickableImageView *lock0, *lock1, *lock2, *lock3, *lock4;

    IBOutlet NSView *mainView;
    
    
}

/* Objects */
@property (retain) NSColor *color0, *color1, *color2, *color3, *color4;
@property (retain) NSArray *colorHistory, *fxArray;

/* Primitives */
@property int historyIndex;
@property codeType colorMode;
@property BOOL enjoysQuiet, swatchNeeded, wantsHSB, wantsSemiColon, wantsSet;


/* Events */
-(void)setupEvents;
-(void)setupSound;

/* Color History */
-(void)setupColorHistory;
-(void)saveColorHistory;
-(void)refreshHistoryWells;
-(void)setupLocks;
-(void)updateLocks;


/* Menu item toggling methods */
-(void)setupMenuItems;
-(IBAction)toggleSound:(id)sender;
-(IBAction)toggleRGB:(id)sender;
-(IBAction)toggleSet:(id)sender;
-(IBAction)toggleSemiColon:(id)sender;


/* The Color Well */
-(void)setupColorWell;
-(IBAction)colorWellUpdated:(id)sender;



/* Code generation / clipboard methods */
-(NSString *)codeStringForColor:(NSColor *)color;
-(IBAction)copyCodeToClipboard:(id)sender;
-(IBAction)swapColorMode:(id)sender;
-(void)resetTextField:(NSTimer *)aTimer;
-(void)copyButtonNormal:(NSTimer *)aTimer;
-(void)resetComboSelection;


/* Color generation. */
-(IBAction)parseColorFromPasteboard:(id)sender;
-(IBAction)updateWithRandomColor:(id)sender;
-(IBAction)updateColorFromSlider:(id)sender;

/* You know, for kids */
-(void)doWelcome;
-(void)doWelcomeWithReset:(BOOL)doesReset;
-(NSString *)welcomePhrase;
-(void)playRandomSound;





/* Complementary Colors */
-(void)updateShadedColorWellsForColor:(NSColor *)aColor withBaseTag:(int)baseTag;


/* Color editing */
-(IBAction)incrementHue:(id)sender;
-(IBAction)decrementHue:(id)sender;
-(IBAction)incrementSaturation:(id)sender;
-(IBAction)decrementSaturation:(id)sender;
-(IBAction)incrementBrightness:(id)sender;
-(IBAction)decrementBrightness:(id)sender;


/* Sliders */
-(BOOL)sliderIsRGBSlider:(NSSlider *)theSlider;


@end
