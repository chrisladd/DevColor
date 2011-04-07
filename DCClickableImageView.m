//
//  DCClickableImageView.m
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DCClickableImageView.h"


@implementation DCClickableImageView
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void) mouseDown: (NSEvent*) theEvent {
    if ([delegate respondsToSelector: @selector(clickFromDCClickableImageView:)]) {

        BOOL shouldLock = [delegate clickFromDCClickableImageView:self];
        [self shouldLock:shouldLock];
        
    }
}


-(void)shouldLock:(BOOL)shouldLock {

    
    if (shouldLock) {
        self.image = [NSImage imageNamed:@"lockOn.png"];
        
    } else {
        self.image = [NSImage imageNamed:@"lockOff.png"];
    }
    
    
}



- (void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
}

@end
