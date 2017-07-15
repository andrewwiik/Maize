@protocol MZEContentModuleContentViewController
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;

@optional
@property(readonly, nonatomic) BOOL providesOwnPlatter;
@property(readonly, nonatomic) BOOL shouldHidePlatterWhenExpanded;
@property(readonly, nonatomic) double preferredExpandedContentWidth;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillPresent;
- (void)dismissPresentedContent;
- (BOOL)canDismissPresentedContent;
- (void)didTransitionToExpandedContentMode:(BOOL)arg1;
- (void)willTransitionToExpandedContentMode:(BOOL)arg1;
- (BOOL)shouldBeginTransitionToExpandedContentModule;
- (void)willResignActive;
- (void)willBecomeActive;
@end