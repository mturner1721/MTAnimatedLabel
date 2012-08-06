//
//  ViewController.m
//  AnimatedUILabelExample
//
//  Created by michael on 8/3/12.
//  Copyright (c) 2012 Michael Turner. All rights reserved.
//

#import "ViewController.h"

#define kMaxTranslation 190.0f

@interface ViewController () {
    
    CGFloat sliderInitialX;
}

@end

@implementation ViewController
@synthesize animatedLabel;
@synthesize slider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.slider addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self.animatedLabel stopAnimating];
    }
    
    if (gr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint t = [gr translationInView:self.view]; //get Translation
        
        CGRect f = self.slider.frame;
        f.origin.x = MAX(sliderInitialX, MIN(kMaxTranslation, f.origin.x+t.x)); //enforce slider bounds
        self.slider.frame = f;
        
        self.animatedLabel.alpha = 1-(self.slider.frame.origin.x/(kMaxTranslation*0.5 - sliderInitialX)); //calc label alpha
        
        [gr setTranslation:CGPointZero inView:self.view]; //reset translation

    }
    
    if (gr.state == UIGestureRecognizerStateEnded) {
        
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect f = self.slider.frame;
            f.origin.x = sliderInitialX;
            self.slider.frame = f;
        } completion:^(BOOL finished) {
            [self.animatedLabel startAnimating];
            self.animatedLabel.alpha = 1.0f;
        }];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.animatedLabel startAnimating];
    sliderInitialX = self.slider.frame.origin.x;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.animatedLabel stopAnimating];
}

- (void)viewDidUnload
{
    [self setAnimatedLabel:nil];
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}




@end
