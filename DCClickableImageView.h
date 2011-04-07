//
//  DCClickableImageView.h
//  DevColor
//
//  Created by Christopher Ladd on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCClickableImageViewDelegate <NSObject>
-(BOOL)clickFromDCClickableImageView:(NSImageView *)imageView;

@end



@interface DCClickableImageView : NSImageView {

    id<DCClickableImageViewDelegate> delegate;

@private
    
}

@property (retain) id <DCClickableImageViewDelegate> delegate;

-(void)shouldLock:(BOOL)shouldLock;

@end
