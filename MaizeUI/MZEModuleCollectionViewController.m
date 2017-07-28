#import "MZEModuleCollectionViewController.h"

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

		_layoutStyle = [[MZELayoutStyle alloc] initWithSize:[UIScreen mainScreen].bounds.size];
		_positionProvider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:_layoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];
	}
	return self;
}

- (void)willBecomeActive {
	if (_moduleViewControllerByIdentifier) {
		NSArray<MZEContentModuleContainerViewController *> *viewControllers = [_moduleViewControllerByIdentifier allValues];
		for (MZEContentModuleContainerViewController *viewController in viewControllers) {
			[viewController willBecomeActive];
		}
	}
}

- (void)willResignActive {
	if (_moduleViewControllerByIdentifier) {
		NSArray<MZEContentModuleContainerViewController *> *viewControllers = [_moduleViewControllerByIdentifier allValues];
		for (MZEContentModuleContainerViewController *viewController in viewControllers) {
			[viewController willResignActive];
		}
	}
}

- (void)loadView {
	[super loadView];
	if (self.view) {
		CGRect frame = self.view.frame;
		frame.size = [_positionProvider sizeOfLayoutView];
		self.view.frame = frame;
		[self _populateModuleViewControllers];
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
	NSArray<MZEModuleInstance *> *moduleInstances = [self _moduleInstances];
	NSMutableDictionary<NSString *, MZEContentModuleContainerViewController *> *moduleViewControllerByIdentifier = [NSMutableDictionary new];

	for (MZEModuleInstance *moduleInstance in moduleInstances) {
		NSString *moduleIdentifier = moduleInstance.metadata.identifier;
		MZEContentModuleContainerViewController *viewController = [[MZEContentModuleContainerViewController alloc] initWithModuleIdentifier:moduleIdentifier contentModule:moduleInstance.module];
		[moduleViewControllerByIdentifier setObject:viewController forKey:moduleIdentifier];
		viewController.view.frame = [self compactModeFrameForContentModuleContainerViewController:viewController];
		[self _setupAndAddModuleViewControllerToHierarchy:viewController];
	}
}

- (NSArray<MZEModuleInstance *> *)_moduleInstances {
	return [_moduleInstanceManager moduleInstances];
}

#pragma mark MZEContentModuleContainerViewControllerDelegate

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController didCloseExpandedModule:(id <MZEContentModule>)module {
	[_currentModules removeObject:containerViewController];
	[_delegate  moduleCollectionViewController:self didCloseExpandedModule:module];
}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController willCloseExpandedModule:(id <MZEContentModule>)module {
	[_delegate moduleCollectionViewController:self willCloseExpandedModule:module];

	if ([[UIDevice currentDevice] userInterfaceIdiom] != 1) {
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

	[self.view bringSubviewToFront:[containerViewController moduleContainerView]];

	[_currentModules addObject:containerViewController];

	if ([[UIDevice currentDevice] userInterfaceIdiom] != 1) {
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

}

- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didBeginInteractionWithModule:(id <MZEContentModule>)arg2 {

}

- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)viewController {
	return [_positionProvider  positionForIdentifier:viewController.moduleIdentifier];
}
@end