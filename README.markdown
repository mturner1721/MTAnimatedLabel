# MTAnimatedLabel

This codebase implements MTAnimatedLabel, a UILabel subclass that supports animation like the iPhone lock screen.

## License

pending...

## Automatic Reference Counting (ARC)

The source code in this repository uses Automatic Reference Counting.

## Required Frameworks

MTAnimatedLabel requires the following frameworks:
	
	CoreText
	QuartzCore
	UIKit
	Foundation
	CoreGraphics

## Design

### MTAnimatedLabel

A UILabel subclass that uses CATextLayer & CAGradientLayer to accomplish an iPhone lock screen like animation.

### So how do I use it?

Just as you would use any other UILabel, either from a nib or in code.

	/*Example*/
    MTAnimatedLabel *label = [[MTAnimatedLabel alloc] initWithFrome:CGRectMake(0,0,100,35)];
    label.text = @"slide to unlock";
    [self.view addSubview:label];
    [label startAnimating]; //begins animation
    
    //call animate again to stop the animation
    [label stopAnimating];
    
It's is also possible to change the gradient tint, animation duration, and gradient width.

### Performance Considerations

MTAnimatedLabel uses a CATextLayer to mask a CAGradientLayer which requires off screen rendering. Due to this MTAnimatedLabel should only be used when animation is required.


### TODO's

MTAnimatedLabel does not currently respect the following UILabel properties:

	1. lineBreakMode
	2. shadows on text are not currently working
	3. baselineAdjustment
	4. highlighting
	5. autosizeTextToFit
	6. numberOfLines
	
If you feel like jumping in on some of these please feel free!

