#import "MZEScrollView.h"

@implementation MZEScrollView
	@dynamic delegate;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(scrollView:gestureRecognizerShouldBegin:)]) {
			return [self.delegate scrollView:self gestureRecognizerShouldBegin:gestureRecognizer];
		}
	}
	return [super gestureRecognizerShouldBegin:gestureRecognizer];
}
@end