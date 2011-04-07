//
//  DevColor.h
//  DevColor
//
//  Created by Christopher Ladd on 1/25/11.
//  Copyright 2011 WalkSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum codeTypes {
	uicolor, nscolor, hex, rgb, rgba
	
} codeType;

@interface DevColor : NSObject {

	IBOutlet NSColorWell *colorWell;

	IBOutlet NSComboBox *comboBox;
	IBOutlet NSTextField *copyableTextField;
    IBOutlet NSButton *copyButton;
    
	codeType colorMode;
	
	
}

@property (readwrite, assign) codeType colorMode;


-(IBAction)colorWellUpdated:(id)sender;
-(IBAction)swapColorMode:(id)sender;
-(IBAction)copyCodeToClipboard:(id)sender;
-(void)copyButtonNormal:(NSTimer *)aTimer;
@end
