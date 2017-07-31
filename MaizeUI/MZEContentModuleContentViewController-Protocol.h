@protocol MZEContentModuleContentViewController <NSObject>
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;

@optional
@property(readonly, nonatomic) BOOL providesOwnPlatter;
@property(readonly, nonatomic) BOOL shouldHidePlatterWhenExpanded;
@property(readonly, nonatomic) CGFloat preferredExpandedContentWidth;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillPresent;
- (void)dismissPresentedContent;
- (BOOL)canDismissPresentedContent;
- (void)didTransitionToExpandedContentMode:(BOOL)arg1;
- (void)willTransitionToExpandedContentMode:(BOOL)arg1;
- (BOOL)shouldBeginTransitionToExpandedContentModule;
- (void)willResignActive;
- (void)willBecomeActive;

@property(nonatomic) BOOL allowsInPlaceFiltering;
@property(readonly, nonatomic) CALayer *punchOutRootLayer;
@property(readonly, nonatomic, getter=isGroupRenderingRequired) BOOL groupRenderingRequired;
@end