//
//  MTAnimatedLabel.h
//  
//
//  Created by Michael Turner on 8/3/12.
//  Copyright (c) 2012 Michael Turner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface MTAnimatedLabel : UILabel
    
@property (nonatomic)           CGFloat animationDuration;
@property (nonatomic)           CGFloat gradientWidth;
@property (nonatomic, strong)   UIColor *tint;

- (void)startAnimating;
- (void)stopAnimating;

@end
