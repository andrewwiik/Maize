

@interface MZEExpandedModuleDismissTransition : NSObject<UIViewControllerAnimatedTransitioning>
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
@end