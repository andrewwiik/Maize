#import "MZEScrollViewDelegate-Protocol.h"

@interface MZEScrollView : UIScrollView
@property(nonatomic) __weak id <MZEScrollViewDelegate> delegate;
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
@end