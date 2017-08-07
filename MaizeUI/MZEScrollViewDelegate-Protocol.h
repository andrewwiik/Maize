@class MZEScrollView;

@protocol MZEScrollViewDelegate <UIScrollViewDelegate>
@optional
- (BOOL)scrollView:(MZEScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
@end