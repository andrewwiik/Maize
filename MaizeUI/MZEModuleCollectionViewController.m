#import "MZEModuleCollectionViewController.h"
#import <UIKit/UIScreen+Private.h>
#import "MZELayoutOptions.h"
#import <SpringBoard/SBControlCenterController+Private.h>
#import <UIKit/UIWindow+Orientation.h>
#import <UIKit/UIView+Private.h>
#import "macros.h"
#import <UIKit/UIScreen+Private.h>
#import "MZEOptionsManager.h"

// static BOOL isIOS11Mode = YES;

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:[MZEModuleRepository settingsChangedNotificationName]
                                                    object:nil
                                                  userInfo:nil];
}

@implementation MZEModuleCollectionViewController
	@synthesize delegate=_delegate;

- (id)initWithModuleInstanceManager:(MZEModuleInstanceManager *)moduleInstanceManager {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_currentModules = [NSMutableArray new];
		_moduleInstanceManager = moduleInstanceManager;
		_moduleViewControllerByIdentifier = [NSMutableDictionary new];
		NSArray *enabledIdentifiers = [[MZEModuleRepository repositoryWithDefaults] enabledIdentifiers];
		NSMutableArray *orderedSizes = [NSMutableArray new];
		NSMutableArray *orderedIdentifiers = [NSMutableArray new];
		for (NSString *identifier in enabledIdentifiers) {
			if ([_moduleInstanceManager.moduleInstanceByIdentifier objectForKey:identifier]) {
				MZEModuleInstance *moduleInstance = [_moduleInstanceManager.moduleInstanceByIdentifier objectForKey:identifier];
				MZEModuleMetadata *moduleMetadata = moduleInstance.metadata;
				[orderedIdentifiers addObject:moduleMetadata.identifier];
				[orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake([moduleMetadata.moduleWidth floatValue],[moduleMetadata.moduleHeight floatValue])]];			
			}
		}

		_portraitLayoutStyle = [[MZELayoutStyle alloc] initWithSize:[MZELayoutOptions orientationRelativeScreenBounds].size isLandscape:NO];
		_landscapeLayoutStyle = [[MZELayoutStyle alloc] initWithSize:[MZELayoutOptions orientationRelativeScreenBounds].size isLandscape:YES];

		_portraitPositionProvider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:_portraitLayoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];
		_landscapePositionProvider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:_landscapeLayoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];
	
		_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
		_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

		CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(),
                                    NULL,
                                    settingsChanged,
                                    (__bridge CFStringRef)[MZEModuleRepository settingsChangedNotificationName],
                                    NULL,  
                                    CFNotificationSuspensionBehaviorDeliverImmediately);

		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(reloadSettings)
	                                             	 name:[MZEModuleRepository settingsChangedNotificationName]
	                                           	   object:nil];
	}
	return self;
}

- (BOOL)isLandscape {
	if (isPad) {
		return NO;
	}
	if (_delegate) {
		return UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)[_delegate interfaceOrientationForModuleCollectionViewController:self]);
	} else {
		SBControlCenterController *mainController = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
		if (mainController && mainController.view) {
			return UIInterfaceOrientationIsLandscape([[mainController.view window] interfaceOrientation]);
		}
	}
	return NO;
}

- (BOOL)isLandscapeWithoutIPad {
	if (_delegate) {
		return UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)[_delegate interfaceOrientationForModuleCollectionViewController:self]);
	} else {
		SBControlCenterController *mainController = [NSClassFromString(@"SBControlCenterController") _sharedInstanceCreatingIfNeeded:YES];
		if (mainController && mainController.view) {
			return UIInterfaceOrientationIsLandscape([[mainController.view window] interfaceOrientation]);
		}
	}
	return NO;
}

- (void)willBecomeActive {
	_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
	_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	// self.scrollView.contentInset = UIEdgeInsetsMake(layoutStyle.inset,0,0,0);
	// self.scrollView.contentSize = CGSizeMake([positionProvider sizeOfLayoutView].width,[positionProvider sizeOfLayoutView].height - self.scrollView.contentInset.top);
	if (_moduleViewControllerByIdentifier) {
		//self.view.backgroundColor = [UIColor redColor];
		NSArray<MZEContentModuleContainerViewController *> *viewControllers = [_moduleViewControllerByIdentifier allValues];
		//HBLogInfo(@"ALL CURRENT CONTROLLERS: %@", viewControllers);
		for (MZEContentModuleContainerViewController *viewController in viewControllers) {
			// if (![_currentModules containsObject:viewController]) {
			// 	viewController.view.frame = [_currentPositionProvider  positionForIdentifier:viewController.moduleIdentifier];
			// 	//viewController.view.backgroundColor = [viewController.view.backgroundColor isEqual:[UIColor whiteColor]] ? [UIColor blackColor] : [UIColor whiteColor];
			// }
			[viewController willBecomeActive];
			//viewController.view.backgroundColor = [UIColor greenColor];
		}
	}
}

- (void)willResignActive {
	// MZEControlCenterPositionProvider *positionProvider = [self isLandscape] ? _landscapePositionProvider : _portraitPositionProvider;
	// for (UIViewController *viewController in [self childViewControllers]) {
	// 	if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
	// 		MZEContentModuleContainerViewController *childController = (MZEContentModuleContainerViewController *)viewController;
	// 		viewController.view.frame = [positionProvider  positionForIdentifier:viewController.moduleIdentifier];
	// 	}

	// }
	if (_moduleViewControllerByIdentifier) {
		NSArray<MZEContentModuleContainerViewController *> *viewControllers = [_moduleViewControllerByIdentifier allValues];
		for (MZEContentModuleContainerViewController *viewController in viewControllers) {
			[viewController willResignActive];
		}
	}
}

- (void)loadView {
	_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
	_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	CGSize preferredContentSize = [self preferredContentSize];
	self.containerView = [[MZEModuleCollectionView alloc] initWithLayoutSource:self frame:CGRectMake(0,0,preferredContentSize.width,preferredContentSize.height)];
	self.containerView.delegate = self;

	self.psuedoCollectionView = [[MZEModuleCollectionView alloc] initWithLayoutSource:self frame:CGRectMake(0,0,preferredContentSize.width,preferredContentSize.height)];
	self.psuedoCollectionView.delegate = self;


	self.effectView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
	self.highlightEffectView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
	self.effectView.backdropView.layer.groupName = @"ModuleDarkBackground";
	self.view = self.containerView;

	if ([MZEOptionsManager isHybridMode]) {
		[self.effectView.backdropView.layer setFilters:nil];
	}
}

- (void)viewDidLoad {

	if (self.view) {
		[self.view addSubview:self.effectView];
		self.effectView.backdropView.maskView = self.psuedoCollectionView;
		//[self.view addSubview:self.psuedoCollectionView];
		// CGRect frame = self.view.frame;
		// frame.size = [_currentPositionProvider sizeOfLayoutView];
		// self.view.frame = frame;
		[self _populateModuleViewControllers];
	}
}

- (void)viewWillLayoutSubviews {

	_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
	_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	if ([self isLandscape]) {
		self.containerView.edgeInsets = UIEdgeInsetsMake(0,_currentLayoutStyle.inset,0,_currentLayoutStyle.inset);
		self.psuedoCollectionView.edgeInsets = UIEdgeInsetsMake(0,_currentLayoutStyle.inset,0,_currentLayoutStyle.inset);
	} else {
		self.containerView.edgeInsets = UIEdgeInsetsMake(0,_currentLayoutStyle.inset,_currentLayoutStyle.inset,_currentLayoutStyle.inset);
		self.psuedoCollectionView.edgeInsets = UIEdgeInsetsMake(0,_currentLayoutStyle.inset,_currentLayoutStyle.inset,_currentLayoutStyle.inset);
	}

	[self.view setSize:[self preferredContentSize]];
	[self.psuedoCollectionView setSize:[self preferredContentSize]];

	if (self.effectView) {
		self.effectView.frame = self.view.bounds;
		[self.view sendSubviewToBack:self.effectView];
	}

	[super viewWillLayoutSubviews];
}

- (CGSize)layoutSize {
	return [_currentPositionProvider sizeOfLayoutView];
}

- (CGSize)preferredContentSize {

	CGSize contentSize = [self layoutSize];
	if ([self isLandscape]) {
		contentSize.width += _landscapeLayoutStyle.inset*2;
	} else {
		contentSize.width += _portraitLayoutStyle.inset*2;
		contentSize.height += _portraitLayoutStyle.inset;
	}
	return contentSize;
}



// - (void)viewDidLoad {
// 	[super viewDidLoad];
// 	CGRect frame = self.view.frame;
// 	frame.size = [_positionProvider sizeOfLayoutView];
// 	self.view.frame = frame;
// 	[self _populateModuleViewControllers];

// }

- (void)_removeAndTearDownModuleViewControllerFromHierarchy:(MZEContentModuleContainerViewController *)viewController {
	[viewController setDelegate:nil];
	[viewController.view removeFromSuperview];
	[viewController.psuedoView removeFromSuperview];
	[viewController willMoveToParentViewController:nil];
	[viewController removeFromParentViewController];
}
- (void)_setupAndAddModuleViewControllerToHierarchy:(MZEContentModuleContainerViewController *)viewController {
	[viewController setDelegate:self];
	[self.view addSubview:viewController.view];
	[self.psuedoCollectionView addSubview:viewController.psuedoView];
	[self addChildViewController:viewController];
	[viewController didMoveToParentViewController:self];

}
- (void)_populateModuleViewControllers {
	_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
	_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	NSArray<MZEModuleInstance *> *moduleInstances = [self _moduleInstances];
	if (!_moduleViewControllerByIdentifier) {
		_moduleViewControllerByIdentifier = [NSMutableDictionary new];
	}
	//_moduleViewControllerByIdentifier = [NSMutableDictionary new];

	for (MZEModuleInstance *moduleInstance in moduleInstances) {
		NSString *moduleIdentifier = moduleInstance.metadata.identifier;
		MZEContentModuleContainerViewController *viewController;
		BOOL isEnabled = [[[MZEModuleRepository repositoryWithDefaults] enabledIdentifiers] containsObject:moduleIdentifier];
		if (![_moduleViewControllerByIdentifier objectForKey:moduleIdentifier] && isEnabled) {
			viewController = [[MZEContentModuleContainerViewController alloc] initWithModuleIdentifier:moduleIdentifier contentModule:moduleInstance.module];
			[_moduleViewControllerByIdentifier setObject:viewController forKey:moduleIdentifier];
			viewController.view.hidden = isEnabled ? NO : YES;
			viewController.psuedoView.hidden = isEnabled ? NO : YES;
			[self _setupAndAddModuleViewControllerToHierarchy:viewController];
		} else {
			viewController = [_moduleViewControllerByIdentifier objectForKey:moduleIdentifier];
			viewController.view.hidden = isEnabled ? NO : YES;
			viewController.psuedoView.hidden = isEnabled ? NO : YES;

		}
	}

	//_moduleViewControllerByIdentifier = moduleViewControllerByIdentifier;
}

- (void)hideSnapshottedModules:(BOOL)shouldHide {
	for (UIViewController *viewController in [self childViewControllers]) {
		if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
			viewController.view.hidden = shouldHide;
		}
	}
}

- (NSArray<MZEModuleInstance *> *)_moduleInstances {
	return [_moduleInstanceManager moduleInstances];
}

- (MZEModuleCollectionView *)moduleCollectionView {
	return self.containerView;
}

#pragma mark MZELayoutViewLayoutSourceDelegate

- (BOOL)layoutView:(MZELayoutView *)layoutView shouldIgnoreSubview:(UIView *)subview {
	if ([subview respondsToSelector:@selector(moduleIdentifier)]) {
		if (CGAffineTransformEqualToTransform(subview.transform,CGAffineTransformIdentity)) {
			return NO;
		}
	}

	return YES;
}

- (CGRect)layoutView:(MZELayoutView *)layoutView layoutRectForSubview:(UIView *)subview {
	MZEContentModuleContainerView *view = (MZEContentModuleContainerView *)subview;
	if (view) {
		return [_currentPositionProvider positionForIdentifier:view.moduleIdentifier];
	} else return CGRectZero;
}

- (CGSize)layoutSizeForLayoutView:(MZELayoutView *)layoutView {
	return [self layoutSize];
}

#pragma mark MZEContentModuleContainerViewControllerDelegate

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController didCloseExpandedModule:(id <MZEContentModule>)module {
	[_currentModules removeObject:containerViewController];
	
	// containerViewController.view.frame = [self compactModeFrameForContentModuleContainerViewController:containerViewController];
	// containerViewController.contentViewController.view.frame = CGRectMake(0,0,containerViewController.view.frame.size.width,containerViewController.view.frame.size.height);

	// [containerViewController.view removeFromSuperview];
	// [containerViewController willMoveToParentViewController:nil];
	// [containerViewController removeFromParentViewController];
	// [self.view addSubview:containerViewController.view];

	//self.view.backgroundColor = [UIColor redColor];
	if (_snapshotView) {
		_snapshotView.hidden = YES;
	}
	//_snapshotView.hidden = YES;
	self.view.hidden = NO;

	//_snapshotView.hidden = YES;
	if (_delegate) {
		[_delegate  moduleCollectionViewController:self didCloseExpandedModule:module];
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController willCloseExpandedModule:(id <MZEContentModule>)module {
	if (_delegate) {
		[_delegate moduleCollectionViewController:self willCloseExpandedModule:module];
	}

	if (YES != NO) {

		// [UIView performWithoutAnimation:^{
  //   		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0265 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		// 	    [UIView animateWithDuration:0.08 animations:^{
		// 			for (UIViewController *viewController in [self childViewControllers]) {
		// 				if (viewController != containerViewController) {
		// 					if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		// 						viewController.view.alpha = 1;
		// 					}
		// 				}
		// 			}
		// 		}];
		// 	});
  //   	}];
		// [UIView animateWithDuration:0.0f delay:0.275 options:0 animations:^{
		// 	 [UIView performWithoutAnimation:^{
		// 		for (UIViewController *viewController in [self childViewControllers]) {
		// 			if (viewController != containerViewController) {
		// 				if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		// 					viewController.view.alpha = 1;
		// 				}
		// 			}
		// 		}
		// 	 }];
		// 	// self.view.alpha = 1.0;
		// } completion:^(BOOL complete) {
		// 	// [UIView performWithoutAnimation:^{
		// 	// 	for (UIViewController *viewController in [self childViewControllers]) {
		// 	// 		if (viewController != containerViewController) {
		// 	// 			if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		// 	// 				viewController.view.alpha = 1;
		// 	// 			}
		// 	// 		}
		// 	// 	}
		// 	// }];
		// }];
	}

	if (_snapshotView) {
		_snapshotView.alpha = 1;
		//self.view.hidden = NO;
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didOpenExpandedModule:(id <MZEContentModule>)arg2 {

}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController willOpenExpandedModule:(id <MZEContentModule>)module {
	if (_delegate) {
		[_delegate moduleCollectionViewController:self willOpenExpandedModule:module];
	}

	//[self.view bringSubviewToFront:[containerViewController moduleContainerView]];

	[_currentModules addObject:containerViewController];

	// if (YES != NO) {
	// 	[UIView performWithoutAnimation:^{
	// 		for (UIViewController *viewController in [self childViewControllers]) {
	// 			if (viewController != containerViewController) {
	// 				if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
	// 					viewController.view.alpha = 0;
	// 				}
	// 			}
	// 		}
	// 	}];
	// }

	if (_snapshotView) {
		_snapshotView.alpha = 0;
		//_snapshotView.hidden = YES;
		//self.view.hidden = NO;
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didFinishInteractionWithModule:(id <MZEContentModule>)arg2 {
	if (_delegate) {
		[_delegate moduleCollectionViewController:self didFinishInteractionWithModule:arg2];
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didBeginInteractionWithModule:(id <MZEContentModule>)arg2 {
	if (_delegate) {
		[_delegate moduleCollectionViewController:self didBeginInteractionWithModule:arg2];
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController openExpandedModule:(id <MZEContentModule>)expandedModule {
	
	[UIView setAnimationsEnabled:NO];
	// [containerViewController.view removeFromSuperview];
	[containerViewController willMoveToParentViewController:nil];
	[containerViewController removeFromParentViewController];



	[UIView animateWithDuration:0.0f animations:^{
		containerViewController.view.alpha = 0.0;
		_snapshotView.hidden = YES;
		if (_snapshotView) {
			[_snapshotView removeFromSuperview];
		}
	} completion:^(BOOL completed) {
		if ([self.view superview]) {
			_snapshotView = [[NSClassFromString(@"UIScreen") mainScreen] snapshotView];
			containerViewController.view.alpha = 1.0;
			if (![_snapshotView superview] && [self.view superview]) {
				CGRect frame = _snapshotView.frame;

				if ([MZEOptionsManager isHybridMode]) {
					CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
					frame.origin.x -= frameInWindow.origin.x;
					frame.origin.y -= frameInWindow.origin.y;
				}
				if ([[self.view superview] isKindOfClass:NSClassFromString(@"UIScrollView")]) {
					frame.origin.x += ((UIScrollView *)[self.view superview]).contentOffset.x; 
					frame.origin.y += ((UIScrollView *)[self.view superview]).contentOffset.y;
				}
				_snapshotView.frame = frame;
				[[self.view superview] addSubview:_snapshotView];
				self.view.hidden = YES;
			}
		}

		[self presentViewController:containerViewController animated:true completion:nil];
	}];
	// if (_snapshotView) {
	// 	[_snapshotView removeFromSuperview];
	// }

	// [self.view setNeedsDisplay];
	// [self.view setNeedsLayout];

	// if ([self.view superview]) {
	// 	_snapshotView = [[NSClassFromString(@"UIScreen") mainScreen] _snapshotExcludingWindows:nil withRect:[self.view superview].bounds];
	// 	if (![_snapshotView superview] && [self.view superview]) {
	// 		[[self.view superview] addSubview:_snapshotView];
	// 	}
	// }
	// // _snapshotView = [[NSClassFromString(@"UIScreen") mainScreen] _snapshotExcludingWindows:nil withRect:[self.view superview].bounds];
	// // if (![_snapshotView superview] && [self.view superview]) {
	// // 	[[self.view superview] addSubview:_snapshotView];
	// // }
	// [self presentViewController:containerViewController animated:true completion:nil];
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController closeExpandedModule:(id <MZEContentModule>)expandedModule {
	[self dismissViewControllerAnimated:YES completion:^ {
		//if (isIOS11Mode) {
			containerViewController.contentContainerView.moduleMaterialView.hidden = YES;
			containerViewController.psuedoView.hidden = NO;
		//}
	}];

	//[self contentModuleContainerViewController:containerViewController closeExpandedModule:expandedModule withCompletion:nil];
}

- (BOOL)handleMenuButtonTap {
	if ([_currentModules count] > 0) {
		return [[_currentModules objectAtIndex:0] closeModule];
		//return YES;
	}
	return NO;
}

// - (BOOL)handlDoubleMenuButtonTao {
// 	if ([_currentModules count] > 0) {
// 		[[_currentModules objectAtIndex:0] closeModuleWithCompletion:^{
// 			if ([_currentModules count] > 0) {
// 				[[_currentModules objectAtIndex:0] closeModuleWithCompletion:^{
// 					completionBlock();
// 				}];
// 			} else {
// 				if (completionBlock) {
// 					completionBlock();
// 				}
// 			}
// 		}];
// 		return YES;
// 	}
// 	return NO;
// }


- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)viewController {
	CGFloat xOriginOffset = _currentLayoutStyle.inset;

	CGRect frame = [_currentPositionProvider positionForIdentifier:viewController.moduleIdentifier];
	frame.origin.x += xOriginOffset;

	return frame;
}

- (void)reloadSettings {
	[[MZEModuleRepository repositoryWithDefaults] loadSettings];
	NSArray *enabledIdentifiers = [[MZEModuleRepository repositoryWithDefaults] enabledIdentifiers];
	NSMutableArray *orderedSizes = [NSMutableArray new];
	NSMutableArray *orderedIdentifiers = [NSMutableArray new];
	for (NSString *identifier in enabledIdentifiers) {
		if ([_moduleInstanceManager.moduleInstanceByIdentifier objectForKey:identifier]) {
			MZEModuleInstance *moduleInstance = [_moduleInstanceManager.moduleInstanceByIdentifier objectForKey:identifier];
			MZEModuleMetadata *moduleMetadata = moduleInstance.metadata;
			[orderedIdentifiers addObject:moduleMetadata.identifier];
			[orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake([moduleMetadata.moduleWidth floatValue],[moduleMetadata.moduleHeight floatValue])]];			
		}
	}

	_portraitLayoutStyle = [[MZELayoutStyle alloc] initWithSize:[MZELayoutOptions orientationRelativeScreenBounds].size isLandscape:NO];
	_landscapeLayoutStyle = [[MZELayoutStyle alloc] initWithSize:[MZELayoutOptions orientationRelativeScreenBounds].size isLandscape:YES];

	_portraitPositionProvider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:_portraitLayoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];
	_landscapePositionProvider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:_landscapeLayoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];

	_currentPositionProvider = [self isLandscapeWithoutIPad] ? _landscapePositionProvider : _portraitPositionProvider;
	_currentLayoutStyle = [self isLandscapeWithoutIPad] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	[self _populateModuleViewControllers];
}

- (void)expandModuleWithIdentifier:(NSString *)identifier {
	if (_moduleViewControllerByIdentifier) {
		MZEContentModuleContainerViewController *controller = [_moduleViewControllerByIdentifier objectForKey:identifier];
		if (controller) {
			[controller expandModule];
		}
	}
}
@end