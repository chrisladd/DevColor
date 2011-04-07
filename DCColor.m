//
//  DCColor.m
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
