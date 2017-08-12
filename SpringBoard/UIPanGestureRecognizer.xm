#import <UIKit/UIPanGestureRecognizer+Private.h>

%hook UIPanGestureRecognizer
%property (nonatomic, assign) BOOL fakePossible;
%property (nonatomic, assign) BOOL fakeBegan;
-(UIGestureRecognizerState)state {
	if (self.fakePossible) {
		return UIGestureRecognizerStatePossible;
	} else if (self.fakeBegan) {
		return UIGestureRecognizerStateBegan;
	} else return %orig;
}
%end