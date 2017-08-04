#import "MZEModuleCollectionViewController.h"
#import <UIKit/UIScreen+Private.h>
#import "MZELayoutOptions.h"

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
	}
	return self;
}

- (BOOL)isLandscape {
	return UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)[_delegate interfaceOrientationForModuleCollectionViewController:self]);
}

- (void)willBecomeActive {
	MZEControlCenterPositionProvider *positionProvider = [self isLandscape] ? _landscapePositionProvider : _portraitPositionProvider;
	MZELayoutStyle *layoutStyle = [self isLandscape] ? _landscapeLayoutStyle : _portraitLayoutStyle;

	self.scrollView.contentInset = UIEdgeInsetsMake(layoutStyle.inset,0,0,0);
	self.scrollView.contentSize = CGSizeMake([positionProvider sizeOfLayoutView].width,[positionProvider sizeOfLayoutView].height - self.scrollView.contentInset.top);
	if (_moduleViewControllerByIdentifier) {
		//self.view.backgroundColor = [UIColor redColor];
		NSArray<MZEContentModuleContainerViewController *> *viewControllers = [_moduleViewControllerByIdentifier allValues];
		//HBLogInfo(@"ALL CURRENT CONTROLLERS: %@", viewControllers);
		for (MZEContentModuleContainerViewController *viewController in viewControllers) {
			if (![_currentModules containsObject:viewController]) {
				viewController.view.frame = [positionProvider  positionForIdentifier:viewController.moduleIdentifier];
				//viewController.view.backgroundColor = [viewController.view.backgroundColor isEqual:[UIColor whiteColor]] ? [UIColor blackColor] : [UIColor whiteColor];
			}
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
	MZEControlCenterPositionProvider *positionProvider = [self isLandscape] ? _landscapePositionProvider : _portraitPositionProvider;
	self.scrollView = [[MZEModuleCollectionView alloc] initWithFrame:CGRectZero];
	self.scrollView.delegate = self;
	self.view = self.scrollView;
	if (self.view) {
		CGRect frame = self.view.frame;
		frame.size = [positionProvider sizeOfLayoutView];
		self.view.frame = frame;
		[self _populateModuleViewControllers];
	}
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
}

- (CGSize)layoutSize {
	if ([self isLandscape]) {
		return [_landscapePositionProvider sizeOfLayoutView];
	} else {
		return [_portraitPositionProvider sizeOfLayoutView];
	}
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
	[viewController willMoveToParentViewController:nil];
	[viewController removeFromParentViewController];
}
- (void)_setupAndAddModuleViewControllerToHierarchy:(MZEContentModuleContainerViewController *)viewController {
	[viewController setDelegate:self];
	[self.view addSubview:viewController.view];
	[self addChildViewController:viewController];
	[viewController didMoveToParentViewController:self];

}
- (void)_populateModuleViewControllers {
	MZEControlCenterPositionProvider *positionProvider = [self isLandscape] ? _landscapePositionProvider : _portraitPositionProvider;
	NSArray<MZEModuleInstance *> *moduleInstances = [self _moduleInstances];
	NSMutableDictionary<NSString *, MZEContentModuleContainerViewController *> *moduleViewControllerByIdentifier = [NSMutableDictionary new];

	for (MZEModuleInstance *moduleInstance in moduleInstances) {
		NSString *moduleIdentifier = moduleInstance.metadata.identifier;
		MZEContentModuleContainerViewController *viewController = [[MZEContentModuleContainerViewController alloc] initWithModuleIdentifier:moduleIdentifier contentModule:moduleInstance.module];
		[moduleViewControllerByIdentifier setObject:viewController forKey:moduleIdentifier];
		viewController.view.frame = [positionProvider  positionForIdentifier:viewController.moduleIdentifier];
		[self _setupAndAddModuleViewControllerToHierarchy:viewController];
	}

	_moduleViewControllerByIdentifier = moduleViewControllerByIdentifier;
}

- (NSArray<MZEModuleInstance *> *)_moduleInstances {
	return [_moduleInstanceManager moduleInstances];
}

#pragma mark MZEContentModuleContainerViewControllerDelegate

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController didCloseExpandedModule:(id <MZEContentModule>)module {
	[_currentModules removeObject:containerViewController];
	
	containerViewController.view.frame = [self compactModeFrameForContentModuleContainerViewController:containerViewController];
	containerViewController.contentViewController.view.frame = CGRectMake(0,0,containerViewController.view.frame.size.width,containerViewController.view.frame.size.height);

	// [containerViewController.view removeFromSuperview];
	// [containerViewController willMoveToParentViewController:nil];
	// [containerViewController removeFromParentViewController];
	// [self.view addSubview:containerViewController.view];

	//self.view.backgroundColor = [UIColor redColor];
	[_delegate  moduleCollectionViewController:self didCloseExpandedModule:module];
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController willCloseExpandedModule:(id <MZEContentModule>)module {
	[_delegate moduleCollectionViewController:self willCloseExpandedModule:module];

	if (YES != NO) {
		for (UIViewController *viewController in [self childViewControllers]) {
			if (viewController != containerViewController) {
				if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
					viewController.view.alpha = 1;
				}
			}
		}
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didOpenExpandedModule:(id <MZEContentModule>)arg2 {

}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController willOpenExpandedModule:(id <MZEContentModule>)module {
	[_delegate moduleCollectionViewController:self willOpenExpandedModule:module];

	//[self.view bringSubviewToFront:[containerViewController moduleContainerView]];

	[_currentModules addObject:containerViewController];

	if (YES != NO) {
		for (UIViewController *viewController in [self childViewControllers]) {
			if (viewController != containerViewController) {
				if ([viewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
					viewController.view.alpha = 0;
				}
			}
		}
	}
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didFinishInteractionWithModule:(id <MZEContentModule>)arg2 {
	[_delegate moduleCollectionViewController:self didFinishInteractionWithModule:arg2];
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didBeginInteractionWithModule:(id <MZEContentModule>)arg2 {

}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController openExpandedModule:(id <MZEContentModule>)expandedModule {
	[containerViewController.view removeFromSuperview];
	[containerViewController willMoveToParentViewController:nil];
	[containerViewController removeFromParentViewController];

	[self presentViewController:containerViewController animated:true completion:nil];
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController closeExpandedModule:(id <MZEContentModule>)expandedModule {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)viewController {
	if ([self isLandscape]) {
		return [_landscapePositionProvider  positionForIdentifier:viewController.moduleIdentifier];
	} else {
		return [_portraitPositionProvider  positionForIdentifier:viewController.moduleIdentifier];
	}
}
@end