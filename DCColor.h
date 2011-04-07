//
//  DCColor.h
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DCColor : NSObject<NSCoding> {
    BOOL isLocked;
    NSColor *color;


@private
    
}

@property (retain) NSColor *color;
@property BOOL isLocked;

+(DCColor *)colorWithNSColor:(NSColor *)anotherColor;

@end
