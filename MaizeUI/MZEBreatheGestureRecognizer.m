#import "MZEBreatheGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MZEContentModuleContainerViewController.h"

@implementation MZEBreatheGestureRecognizer
- (void)reset {
	[super reset];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if ([self.view respondsToSelector:@selector(viewDelegate)]) {
		if ([self.view valueForKey:@"viewDelegate"]) {
			if ([[self.view valueForKey:@"viewDelegate"] respondsToSelector:@selector(touchesBegan:withEvent:)]) {
				[(MZEContentModuleContainerViewController *)[self.view valueForKey:@"viewDelegate"] touchesBegan:touches withEvent:event];
			}
		}
	}	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	if ([self.view respondsToSelector:@selector(viewDelegate)]) {
		if ([self.view valueForKey:@"viewDelegate"]) {
			if ([[self.view valueForKey:@"viewDelegate"] respondsToSelector:@selector(touchesMoved:withEvent:)]) {
				[(MZEContentModuleContainerViewController *)[self.view valueForKey:@"viewDelegate"] touchesMoved:touches withEvent:event];
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent: event];
	if ([self.view respondsToSelector:@selector(viewDelegate)]) {
		if ([self.view valueForKey:@"viewDelegate"]) {
			if ([[self.view valueForKey:@"viewDelegate"] respondsToSelector:@selector(touchesEnded:withEvent:)]) {
				[(MZEContentModuleContainerViewController *)[self.view valueForKey:@"viewDelegate"] touchesEnded:touches withEvent:event];
			}
		}
	}
}
@end