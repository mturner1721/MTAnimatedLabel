//
//  MTAnimatedLabel.m
//  
//
//  Created by michael on 8/3/12.
//  Copyright (c) 2012 Michael Turner. All rights reserved.
//

/*
 Copyright (c) 2012 Michael Turner. All rights reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MTAnimatedLabel.h"
#import <objc/runtime.h>

#define kGradientSize       0.45f
#define kAnimationDuration  2.25f
#define kGradientTint       [UIColor whiteColor]

#define kAnimationKey       @"gradientAnimation"

@interface MTAnimatedLabel () {
    
    CATextLayer     *_textLayer;
}

@end


@implementation MTAnimatedLabel
@synthesize animationDuration   = _animationDuration;
@synthesize gradientWidth       = _gradientWidth;
@synthesize tint                = _tint;

#pragma mark - Initialization

- (void)initializeLayers
{
    /* set Defaults */
    self.tint               = kGradientTint;
    self.animationDuration  = kAnimationDuration;
    self.gradientWidth      = kGradientSize;
    
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor   = [super.textColor CGColor];
    gradientLayer.startPoint        = CGPointMake(-self.gradientWidth, 0.);
    gradientLayer.endPoint          = CGPointMake(0., 0.);
    gradientLayer.colors            = [NSArray arrayWithObjects:(id)[self.textColor CGColor],(id)[self.tint CGColor], (id)[self.textColor CGColor], nil];

    _textLayer                      = [CATextLayer layer];
    _textLayer.backgroundColor      = [[UIColor clearColor] CGColor];
    _textLayer.contentsScale        = [[UIScreen mainScreen] scale];
    _textLayer.rasterizationScale   = [[UIScreen mainScreen] scale];
    _textLayer.bounds               = self.bounds;
    _textLayer.anchorPoint          = CGPointZero;
    
    /* set initial values for the textLayer because they may have been loaded from a nib */
    [self setFont:          super.font];
    [self setTextAlignment: super.textAlignment];
    [self setText:          super.text];
    [self setTextColor:     super.textColor];

    /*
        finally set the textLayer as the mask of the gradientLayer, this requires offscreen rendering
        and therefore this label subclass should ONLY BE USED if animation is required
     */
    gradientLayer.mask = _textLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeLayers];
    }
    return self;
}

#pragma mark - UILabel Accessor overrides

-(UIColor *)textColor
{
    return [UIColor colorWithCGColor:self.layer.backgroundColor];
}

-(void) setTextColor:(UIColor *)textColor
{
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor   = [textColor CGColor];
    gradientLayer.colors            = [NSArray arrayWithObjects:(id)[textColor CGColor],(id)[self.tint CGColor], (id)[textColor CGColor], nil];
    
    [self setNeedsDisplay];
}

-(NSString *)text
{
    return _textLayer.string;
}

- (void)setText:(NSString *)text
{
    _textLayer.string = text;
    [self setNeedsDisplay];
}

-(UIFont *)font
{
    CTFontRef ctFont    = _textLayer.font;
    NSString *fontName  = (__bridge NSString *)CTFontCopyName(ctFont, kCTFontPostScriptNameKey);
    CGFloat fontSize    = CTFontGetSize(ctFont);
    return [UIFont fontWithName:fontName size:fontSize];
}

-(void) setFont:(UIFont *)font
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, &CGAffineTransformIdentity);
    _textLayer.font = fontRef;
    _textLayer.fontSize = font.pointSize;
    CFRelease(fontRef);
    [self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
    //_textLayer.frame = frame;
    [super setFrame:frame];
    [self setNeedsDisplay];
}


/*
 //Shadows don't work with a masked layer

-(UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:_textLayer.shadowColor];
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    _textLayer.shadowColor = shadowColor.CGColor;
    [self setNeedsDisplay];
}

-(CGSize)shadowOffset
{
    return _textLayer.shadowOffset;
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    _textLayer.shadowOffset = shadowOffset;
    [self setNeedsDisplay];
}
*/

- (UITextAlignment)textAlignment
{
    return [MTAnimatedLabel UITextAlignmentFromCAAlignment:_textLayer.alignmentMode];
}

- (void)setTextAlignment:(UITextAlignment)textAlignment
{
    _textLayer.alignmentMode = [MTAnimatedLabel CAAlignmentFromUITextAlignment:textAlignment];
}

#pragma mark - UILabel Layer override

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

/* Stop UILabel from drawing because we are using a CATextLayer for that! */
- (void)drawRect:(CGRect)rect {}

#pragma mark - Utility Methods

+ (NSString *)CAAlignmentFromUITextAlignment:(UITextAlignment)textAlignment
{    
    switch (textAlignment) {
        case UITextAlignmentLeft:   return kCAAlignmentLeft;
        case UITextAlignmentCenter: return kCAAlignmentCenter;
        case UITextAlignmentRight:  return kCAAlignmentRight;
        default:                    return kCAAlignmentNatural;
    }
}

+ (UITextAlignment)UITextAlignmentFromCAAlignment:(NSString *)alignment
{
    if ([alignment isEqualToString:kCAAlignmentLeft])       return UITextAlignmentLeft;
    if ([alignment isEqualToString:kCAAlignmentCenter])     return UITextAlignmentCenter;
    if ([alignment isEqualToString:kCAAlignmentRight])      return UITextAlignmentRight;
    if ([alignment isEqualToString:kCAAlignmentNatural])    return UITextAlignmentLeft;
    return UITextAlignmentLeft;
}

#pragma mark - LayoutSublayers

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    _textLayer.frame = self.layer.bounds;
}

#pragma mark - MTAnimated Label Public Methods

- (void)setTint:(UIColor *)tint
{
    _tint = tint;
    
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.colors            = [NSArray arrayWithObjects:(id)[self.textColor CGColor],(id)[_tint CGColor], (id)[self.textColor CGColor], nil];
    [self setNeedsDisplay];
}

- (void)startAnimating
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey] == nil) {
        
        CABasicAnimation *startPointAnimation = [CABasicAnimation animationWithKeyPath:@"startPoint"];
        startPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 0)];
        startPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *endPointAnimation = [CABasicAnimation animationWithKeyPath:@"endPoint"];
        endPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1+self.gradientWidth, 0)];
        endPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithObjects:startPointAnimation, endPointAnimation, nil];
        group.duration = self.animationDuration;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.repeatCount = FLT_MAX;
        
        [gradientLayer addAnimation:group forKey:kAnimationKey];
    }
}

- (void)stopAnimating
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey]) {
        [gradientLayer removeAnimationForKey:kAnimationKey];
    }
}

@end
