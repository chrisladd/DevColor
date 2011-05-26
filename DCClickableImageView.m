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
//  DCClickableImageView.m
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
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
