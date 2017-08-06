#import "MZEModularControlCenterViewController.h"
#import "MZEModuleInstanceManager.h"
#import <UIKit/_UIBackdropViewSettings+Private.h>
#import <QuartzCore/CALayer+Private.h>
#import "macros.h"

@implementation MZEModularControlCenterViewController

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_initFrame = frame;
		_closedCollectionViewYOrigin = frame.size.height;
		self.luminanceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
	    self.luminanceBackgroundView.layer.allowsGroupBlending = NO;
	    //[self.view addSubview:self.luminanceViewHolder];

	  	self.luminanceBackdropView = [[_MZEBackdropView alloc] init];
	  	self.luminanceBackdropView.frame = CGRectMake(0,0,frame.size.width, frame.size.height);
	  	self.luminanceBackdropView.luminanceAlpha = 1.0f;
	  	self.luminanceBackdropView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	    //self.mze_lumnianceView.alpha = 0.45;
	  	[self.luminanceBackgroundView addSubview:self.luminanceBackdropView];


	  	_animatedBackgroundView = [[MZEAnimatedBlurView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
	  	_animatedBackgroundView.backdropSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
	  	_animatedBackgroundView.backdropSettings.blurRadius = 30.0f;
	  	_animatedBackgroundView.backdropSettings.saturationDeltaFactor = 1.9f;
	    _animatedBackgroundView.backdropSettings.grayscaleTintAlpha = 0;
	    _animatedBackgroundView.backdropSettings.colorTintAlpha = 0;
	    _animatedBackgroundView.backdropSettings.grayscaleTintLevel = 0;
	    _animatedBackgroundView.backdropSettings.usesGrayscaleTintView = NO;
	    _animatedBackgroundView.backdropSettings.usesColorTintView = NO;
	    _animatedBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	    _collectionViewController = [[MZEModuleCollectionViewController alloc] initWithModuleInstanceManager:[MZEModuleInstanceManager sharedInstance]];
	    _collectionViewController.delegate = self;
	    [_collectionViewController loadView];
	    //collectionViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	    if ([self isLandscape] && !(isPad)) {
	    	_openCollectionViewYOrigin = frame.size.height/2 - _collectionViewController.view.frame.size.height/2;
	    } else {
	    	_openCollectionViewYOrigin = frame.size.height - _collectionViewController.view.frame.size.height;
	    }
	    _openCollectionViewYOrigin = frame.size.height - _collectionViewController.view.frame.size.height;
	    CGRect collectionViewFrame = _collectionViewController.view.frame;
	    collectionViewFrame.origin.y = _closedCollectionViewYOrigin;
	    _collectionViewController.view.frame = collectionViewFrame;

	  	//[self.view addSubview:self.mze_animatedBlurView];
	  	//[self.view bringSubviewToFront:self.mze_animatedBlurView];
	}
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,_initFrame.size.width, _initFrame.size.height)];
	if (self.luminanceBackgroundView) {
		[self.view addSubview:self.luminanceBackgroundView];
	}

	if (_animatedBackgroundView) {
		[self.view addSubview:_animatedBackgroundView];
		[self.view bringSubviewToFront:_animatedBackgroundView];
	}

	if (_collectionViewController) {
		if (_collectionViewController.view) {
			[self.view addSubview:_collectionViewController.view];
			[self.view bringSubviewToFront:_collectionViewController.view];

		}
	}

	self.headerPocket = [[MZEHeaderPocketView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height/8.875)];
	[self.view addSubview:self.headerPocket];

}

- (void)revealWithProgress:(CGFloat)progress {

	if (!_animator) {
		[self willBecomeActive];
	}

	if (_animator) {
		[UIView animateWithDuration:0.05 animations:^{
			_collectionViewController.view.center = CGPointMake(_collectionViewController.view.center.x, (CGRectGetHeight([self.view bounds]) + (([_collectionViewController layoutSize].height*0.5)*fabs(progress-1.0))) - (CGRectGetHeight(self.view.bounds) - _openCollectionViewYOrigin)*progress) ;
			if (_animatedBackgroundView) {
				_animatedBackgroundView.progress = progress;
			}

			if (_luminanceBackdropView) {
				if (progress <= 1) {
				    _luminanceBackdropView.alpha = 0.45*progress;
				} else if (progress > 1) {
					_luminanceBackdropView.alpha = 0.45;
				}
			}
		//_animator.fractionComplete = progress;
		} completion:nil];
		// CGFloat wantedY = CGRectGetHeight(self.view.bounds) - ((CGRectGetHeight(self.view.bounds)-_openCollectionViewYOrigin)*progress);
		//_collectionViewController.view.center = CGPointMake(_collectionViewController.view.center.x, (CGRectGetHeight([self.view bounds]) + (([_collectionViewController layoutSize].height*0.5)*fabs(progress-1.0))) - (CGRectGetHeight(self.view.bounds) - _openCollectionViewYOrigin)*progress) ;
		//_animator.fractionComplete = progress;
	}
	float height = self.view.frame.size.height/8.875;
	self.headerPocket.frame = CGRectMake(0,height * (1 - progress),self.view.frame.size.width, height);
	[self.headerPocket animateProgress:progress];

	self.headerPocket.headerChevronView.alpha = progress - 0.35;

	// if (_animatedBackgroundView) {
	// 	_animatedBackgroundView.progress = progress;
	// }

	// if (_luminanceBackdropView) {
	// 	if (progress <= 1) {
	// 	    _luminanceBackdropView.alpha = 0.45*progress;
	// 	} else if (progress > 1) {
	// 		_luminanceBackdropView.alpha = 0.45;
	// 	}
	// }
}

- (void)willResignActive {
	_animator = nil;

	if (_collectionViewController) {
		[_collectionViewController willResignActive];
	}
}
- (void)willBecomeActive {

	if ([self isLandscape] && !(isPad)) {
    	_openCollectionViewYOrigin = self.view.center.y;
    } else {
    	_openCollectionViewYOrigin = CGRectGetHeight(self.view.bounds) - [_collectionViewController layoutSize].height*0.5;
    }

    if (_collectionViewController && _collectionViewController.view) {
    	if ([self isLandscape] && !(isPad)) {
    		CGSize layoutSize = [_collectionViewController layoutSize];
    		self.collectionViewController.view.frame = CGRectMake(self.collectionViewController.view.frame.origin.x,self.collectionViewController.view.frame.origin.y, layoutSize.width,layoutSize.height);
    		_animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
		    	self.collectionViewController.view.center = CGPointMake(self.collectionViewController.view.center.x,self.view.center.y);
		    }];
    	} else {
    		CGSize layoutSize = [_collectionViewController layoutSize];
    		self.collectionViewController.view.frame = CGRectMake(self.collectionViewController.view.frame.origin.x,self.collectionViewController.view.frame.origin.y, layoutSize.width,layoutSize.height);
    		_animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
		    	self.collectionViewController.view.frame = CGRectMake(0,_openCollectionViewYOrigin,self.collectionViewController.view.frame.size.width,self.collectionViewController.view.frame.size.height);
		    }];
    	}
	}

	if (_collectionViewController) {
		//self.view.backgroundColor = [UIColor redColor];
		[_collectionViewController willBecomeActive];
	}

	self.headerPocket.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height/8.875);
}

- (BOOL)isLandscape {
	return UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)[[self.view window] interfaceOrientation]);
}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willRemoveModuleContainerViewController:(MZEContentModuleContainerViewController *)moduleContainerViewController {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didAddModuleContainerViewController:(MZEContentModuleContainerViewController *)moduleContainerViewController {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didCloseExpandedModule:(id <MZEContentModule>)module {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willCloseExpandedModule:(id <MZEContentModule>)module {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didOpenExpandedModule:(id <MZEContentModule>)module {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willOpenExpandedModule:(id <MZEContentModule>)module {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didFinishInteractionWithModule:(id <MZEContentModule>)module {

}

- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didBeginInteractionWithModule:(id <MZEContentModule>)module {

}

- (NSInteger)interfaceOrientationForModuleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController {
	return [[self.view window] interfaceOrientation];
}

- (BOOL)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController shouldForwardAppearanceCall:(BOOL)shouldForward animated:(BOOL)animated {
	return YES;
}
@end
