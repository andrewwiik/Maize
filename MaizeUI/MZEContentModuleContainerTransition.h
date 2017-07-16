@class CCUIContentModuleContainerViewController, NSString;

@interface MZEContentModuleContainerTransition : NSObject <_UIPreviewInteractionViewControllerTransition>
{
    _Bool _appearanceTransition;
    CCUIContentModuleContainerViewController *_viewController;
}

@property(nonatomic, getter=isAppearanceTransition) _Bool appearanceTransition; // @synthesize appearanceTransition=_appearanceTransition;
@property(nonatomic) __weak CCUIContentModuleContainerViewController *viewController; // @synthesize viewController=_viewController;
- (void)transitionDidEnd:(_Bool)arg1;
- (void)performTransitionFromView:(id)arg1 toView:(id)arg2 containerView:(id)arg3;
- (void)prepareTransitionFromView:(id)arg1 toView:(id)arg2 containerView:(id)arg3;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end