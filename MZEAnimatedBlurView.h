#import <UIKit/_UIBackdropView+Private.h>
#import <UIKit/_UIBackdropViewSettings+Private.h>

@interface MZEAnimatedBlurView : UIView {
	CGFloat _progress;
}
@property (nonatomic, retain) _UIBackdropViewSettings *backdropSettings;
@property (nonatomic, retain) _UIBackdropView *backdropView;
@property (nonatomic, assign) CGFloat progress;
@end