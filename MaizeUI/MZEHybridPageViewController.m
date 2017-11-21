#import "MZEHybridPageViewController.h"
#import <UIKit/UIView+Private.h>

@implementation MZEHybridPageViewController
	@synthesize delegate=_delegate;

- (void)viewDidLoad {
	[super viewDidLoad];

	if (!_whiteLayerView) {
		_whiteLayerView = [[_MZEBackdropView alloc] init];
		_whiteLayerView.colorAddColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		_whiteLayerView.layer.groupName = @"ModuleDarkBackground";
		//_whiteLayerView.
		[self.view addSubview:_whiteLayerView];
		_whiteLayerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[_whiteLayerView _setContinuousCornerRadius:13];
	}

	// if (!_alternateWhiteLayerView) {
	// 	_alternateWhiteLayerView = [[UIView alloc] initWithFrame:CGRectZero];
	// 	_alternateWhiteLayerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	// 	[self.view addSubview:_alternateWhiteLayerView];
	// 	_alternateWhiteLayerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	// 	CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
	// 	[filter setValue:(id)[[UIColor colorWithWhite:0.11 alpha:0.3] CGColor] forKey:@"inputColor0"];
	// 	[filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.05] CGColor] forKey:@"inputColor1"];
	// 	[filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
	// 	_alternateWhiteLayerView.layer.filters = [NSArray arrayWithObjects:filter, nil];
	// }


	if (self.collectionViewController) {
		[self.view addSubview:self.collectionViewController.view];
	}

	if (!self.platterView) {
		self.platterView = [self.view ccuiPunchOutMaskedContainer];
	}

	if (self.view) {
		//self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		[self.view _setContinuousCornerRadius:13];
	}

	//self.collectionViewController.view
}

- (void)viewWillLayoutSubviews {

	if (!self.platterView) {
		self.platterView = [self.view ccuiPunchOutMaskedContainer];
	}

	[super viewWillLayoutSubviews];
	if (self.collectionViewController) {
		CGSize collectionPrefferedSize = [self.collectionViewController preferredContentSize];
		self.collectionViewController.view.frame = CGRectMake(0,0,collectionPrefferedSize.width,collectionPrefferedSize.height);
	}
	if (self.platterView && [self.platterView valueForKey:@"_whiteLayerView"]) {
		UIView *whiteLayerView = (UIView *)[self.platterView valueForKey:@"_whiteLayerView"];
		whiteLayerView.hidden = YES;
		whiteLayerView.alpha = 0;
	}

	if (_whiteLayerView) {
		_whiteLayerView.frame = self.view.bounds;
	}

	if (_alternateWhiteLayerView) {
		_alternateWhiteLayerView.frame = self.view.bounds;
	}
	//self.platterView.hidden = YES;
}

- (UIEdgeInsets)contentInsets {
	// if (self.mainViewController) {
	// 	return [self.mainViewController contentInsets];
	// }
	return UIEdgeInsetsMake(0,0,0,0);
}



- (void)controlCenterWillPresent {
	if (!_snapshotView) {
		_snapshotView = [self.collectionViewController.view snapshotView];
		[self.collectionViewController.view addSubview:_snapshotView];
		[self.collectionViewController hideSnapshottedModules:YES];
	} else {
		[self.collectionViewController.view bringSubviewToFront:_snapshotView];
	}
	return;
}

- (void)controlCenterDidDismiss {
	if (_snapshotView) {
		[_snapshotView removeFromSuperview];
		_snapshotView = nil;
	}
	[self.collectionViewController hideSnapshottedModules:NO];
	return;
}

- (void)controlCenterWillBeginTransition {

	if (!_snapshotView) {
		_snapshotView = [self.collectionViewController.view snapshotView];
		[self.collectionViewController.view addSubview:_snapshotView];
		[self.collectionViewController hideSnapshottedModules:YES];
	} else {
		[self.collectionViewController.view bringSubviewToFront:_snapshotView];
	}

}

- (void)controlCenterDidFinishTransition {

	if (_snapshotView) {
		[_snapshotView removeFromSuperview];
		_snapshotView = nil;
	}
	[self.collectionViewController hideSnapshottedModules:NO];
}
@end