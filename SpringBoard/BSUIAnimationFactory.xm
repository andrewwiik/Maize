#import <UIKit/UIView+Private.h>

%hook BSUIAnimationFactory
%new
+ (void)_animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options factory:(id)factory animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	[UIView _animateWithDuration:duration delay:delay options:options factory:factory animations:animations completion:completion];
}
%end
