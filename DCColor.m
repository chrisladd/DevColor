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
//  DCColor.m
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
//

#import "DCColor.h"


@implementation DCColor
@synthesize isLocked, color;


- (id)init
{
    self = [super init];
    if (self) {
        self.isLocked = NO;
    }
    
    return self;
}

+(DCColor *)colorWithNSColor:(NSColor *)anotherColor {
    
    DCColor *aColor = [[[DCColor alloc] init] autorelease];
    
    aColor.color = anotherColor;
    
    return aColor;
    
}


-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.isLocked forKey:@"isLocked"];
    [encoder encodeObject:self.color forKey:@"color"];
    
    
}

-(id)initWithCoder:(NSCoder *)decoder {
    
    self.isLocked = [decoder decodeBoolForKey:@"isLocked"];
    self.color = [decoder decodeObjectForKey:@"color"];

    
    return self;
}




- (void)dealloc
{
    self.color = nil;
    [super dealloc];
}

@end
