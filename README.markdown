# MTAnimatedLabel

This codebase implements MTAnimatedLabel, a UILabel subclass that supports animation like the iPhone lock screen.

## License

This code is licensed under the 2-clause BSD license ("Simplified BSD License" or "FreeBSD License") license. The license is reproduced below:

Copyright 2011 Jonathan Wight. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ''AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Jonathan Wight.

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

