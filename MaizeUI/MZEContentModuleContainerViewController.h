#import "MZEContentModuleBackgroundView.h"
#import "MZEContentModuleContainerView.h"
#import "MZEContentModuleContentContainerView.h"
#import "MZEContentModule-Protocol.h"
#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEContentModuleContentViewController-Protocol.h"

@interface MZEContentModuleContainerViewController : UIViewController <UIGestureRecognizerDelegate, UIPreviewInteractionDelegatePrivate>
{
    BOOL _expanded;
    BOOL _contentModuleProvidesOwnPlatter;
    BOOL _didSendContentAppearanceCalls;
    BOOL _didSendContentDisappearanceCalls;
    NSString *_moduleIdentifier;
    id <MZEContentModuleContainerViewControllerDelegate> _delegate;
    id <MZEContentModule> _contentModule;
    UIViewController<MZEContentModuleContentViewController> *_contentViewController;
    UIViewController *_backgroundViewController;
    UIView *_highlightWrapperView;
    MZEContentModuleBackgroundView *_backgroundView;
    MZEContentModuleContentContainerView *_contentContainerView;
    UIView *_contentView;
    UIView *_maskView;
    UITapGestureRecognizer *_tapRecognizer;
    UIPreviewInteraction *_previewInteraction;
    UIViewController *_originalParentViewController;
    UIEdgeInsets _expandedContentEdgeInsets;
}

@property(nonatomic) __weak UIViewController *originalParentViewController;
@property(nonatomic, readwrite) BOOL didSendContentDisappearanceCalls; 
@property(nonatomic, readwrite) BOOL didSendContentAppearanceCalls; 
@property(retain, nonatomic, readwrite) UIPreviewInteraction *previewInteraction;
@property(retain, nonatomic, readwrite) UITapGestureRecognizer *tapRecognizer;
@property(retain, nonatomic, readwrite) UIView *maskView;
@property(retain, nonatomic, readwrite) UIView *contentView;
@property(retain, nonatomic, readwrite) MZEContentModuleContentContainerView *contentContainerView;
@property(retain, nonatomic, readwrite) MZEContentModuleBackgroundView *backgroundView;
@property(retain, nonatomic, readwrite) UIView *highlightWrapperView;
@property(nonatomic, readwrite) BOOL contentModuleProvidesOwnPlatter;
@property(retain, nonatomic, readwrite) UIViewController *backgroundViewController;
@property(retain, nonatomic, readwrite) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@property(retain, nonatomic, readwrite) id <MZEContentModule> contentModule;
@property(nonatomic, getter=isExpanded, readwrite) BOOL expanded;
@property(nonatomic) __weak id <MZEContentModuleContainerViewControllerDelegate> delegate;
@property(nonatomic, readwrite) UIEdgeInsets expandedContentEdgeInsets;
@property(copy, nonatomic, readwrite) NSString *moduleIdentifier;
- (void)_configureForContentModuleGroupRenderingIfNecessary;
- (void)_configureMaskViewIfNecessary;
- (struct CGRect)_contentBoundsForTransitionProgress:(double)arg1;
- (struct CGRect)_backgroundFrameForExpandedState;
- (struct CGRect)_backgroundFrameForRestState;
- (struct CGRect)_contentFrameForExpandedState;
- (struct CGRect)_contentFrameForRestState;
- (void)_handleTapGestureRecognizer:(id)arg1;
- (BOOL)_previewInteractionShouldAutomaticallyTransitionToPreviewAfterDelay:(id)arg1;
- (id)_previewInteraction:(id)arg1 viewControllerPresentationForPresentingViewController:(id)arg2;
- (id)_previewInteractionHighlighterForPreviewTransition:(id)arg1;
- (void)previewInteractionDidCancel:(id)arg1;
- (void)previewInteraction:(id)arg1 didUpdatePreviewTransition:(double)arg2 ended:(BOOL)arg3;
- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1;
- (BOOL)previewInteractionShouldBegin:(id)arg1;
- (void)viewWillLayoutSubviews;
- (void)loadView;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)viewDidAppear:(BOOL)arg1;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (void)willResignActive;
- (void)willBecomeActive;
@property(readonly, nonatomic) MZEContentModuleContainerView *moduleContainerView;
- (void)closeModule;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)initWithCoder:(id)arg1;
- (id)init;
- (id)initWithModuleIdentifier:(id)arg1 contentModule:(id)arg2;

@end