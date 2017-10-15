#import "MZEContentModuleContentContainerView.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIView+Private.h>
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import "macros.h"
#import <UIKit/_UIBackdropViewSettings+Private.h>
#import <QuartzCore/CABackdropLayer.h>


MPULayoutInterpolator *interpolator;

static BOOL isIOS11Mode = YES;

// static NSMutableDictionary *storedCornerRadiusExpanded;
// static NSMutableDictionary *storedCornerRadiusRegular;
// static NSMutableDictionary *storedCornerRadiusCenterExpanded;
// static NSMutableDictionary *storedCornerRadiusCenterRegular;


@implementation MZEContentModuleContentContainerView
	@synthesize moduleMaterialView=_moduleMaterialView;
	// @synthesize expandedFrame = _expandedFrame;
	// @synthesize compactFrame = _compactFrame;

// - (void)_setContinuousCornerRadius:(CGFloat)cornerRadius {
// 	if (_moduleMaterialView) {
// 		_moduleMaterialView._continuousCornerRadius = cornerRadius;
// 		_moduleMaterialView.clipsToBounds = cornerRadius > 0 ? YES : NO;
// 	}
// }

- (void)layoutSubviews {

	[self _configureModuleMaterialViewIfNecessary];
	[super layoutSubviews];
	//[storedCornerRadiusExpanded setValue:@16 forKey:@"stuff"];

	// if (!_psuedoView) {
	// 	_psuedoView = [[UIView alloc] initWithFrame:self.bounds];
	// 	_psuedoView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
	// 	interpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// 	//self._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
	// 	self.smallRadius = 30;
	// 	self._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
	// 	self.bigRadius = 59;
	// 	self.layer.cornerRadius = self.smallRadius;
	// }

	// [UIView performWithoutAnimation:^{
	// 	_psuedoView.bounds = self.bounds;
	// }]
	//self._continuousCornerRadius = [interpolator valueForReferenceMetric:self.bounds.size.width];
}

- (void)addSubview:(UIView *)subview {
	[super addSubview:subview];
	if (!isIOS11Mode && subview == _fakeVibrantView) {
		return;
	}
	[self _transitionToExpandedMode:_expanded force:YES];
}

- (MZEMaterialView *)moduleMaterialView {
	[self _configureModuleMaterialViewIfNecessary];
	return _moduleMaterialView;
}

- (void)setModuleProvidesOwnPlatter:(BOOL)providesOwnPlatter {
	_moduleProvidesOwnPlatter = providesOwnPlatter;
	if (providesOwnPlatter && _moduleMaterialView) {
		[_moduleMaterialView removeFromSuperview];
		_moduleMaterialView = nil;
	} else {
		[self _configureModuleMaterialViewIfNecessary];
	}
}

- (void)_configureModuleMaterialViewIfNecessary {

	if (!isIOS11Mode && !_moduleVibrantBackground) {
		_moduleVibrantBackground = [[UIView alloc] initWithFrame:CGRectZero];
		_moduleVibrantBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];

		// _moduleVibrantExpandedBackground = [[UIView alloc] initWithFrame:CGRectZero];
		// _moduleVibrantExpandedBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
		// _moduleVibrantExpandedBackground.alpha = 0.0;
		// _moduleVibrantExpandedBackground.hidden = YES;

		_compactBackgroundFilter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
		[_compactBackgroundFilter setValue:(id)[[UIColor colorWithWhite:0.11 alpha:0.3] CGColor] forKey:@"inputColor0"];
		[_compactBackgroundFilter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.05] CGColor] forKey:@"inputColor1"];
		[_compactBackgroundFilter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];

		// _compactBackgroundFilter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
		// [_compactBackgroundFilter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:1.0] CGColor] forKey:@"inputColor0"];
		// [_compactBackgroundFilter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.3] CGColor] forKey:@"inputColor1"];
		// [_compactBackgroundFilter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];

		_moduleVibrantBackground.layer.filters = [NSArray arrayWithObjects:_compactBackgroundFilter, nil];

		//_expandedBackgroundFilter = [NSClassFromString(@"CAFilter") filterWithType:@"lightenBlendMode"];
	//	_moduleVibrantExpandedBackground.layer.compositingFilter = _expandedBackgroundFilter;
		//_moduleVibrantBackground.layer.compositingFilter = nil;
		[self addSubview:_moduleVibrantBackground];
		//[self addSubview:_moduleVibrantExpandedBackground];

		_UIBackdropViewSettings *backdropSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
	  	backdropSettings.blurRadius = 30.0f;
	  	//backdropSettings.darkeningTintSaturation = 0.2;
	  	backdropSettings.saturationDeltaFactor = 2.04;
	    backdropSettings.grayscaleTintAlpha = 0;
	    backdropSettings.colorTint = [UIColor colorWithWhite:0.7 alpha:1.0];
	    backdropSettings.colorTintAlpha = 0.56;
	    backdropSettings.grayscaleTintLevel = 0;
	 //   backdropSettings.usesGrayscaleTintView = NO;
	    backdropSettings.scale = 0.25;

		_fakeVibrantView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithFrame:self.bounds autosizesToFitSuperview:YES settings:backdropSettings];
		_fakeVibrantView.groupName = @"CCUIControlCenterBaseMaterialBlur";
	
		//_fakeVibrantView.hidden = YES;
		//_fakeVibrantView.alpha = 1.0;
		//_moduleVibrantBackground.hidden = NO;
		((CABackdropLayer *)_fakeVibrantView.effectView.layer).scale = 0.25;
		// [self addSubview:_fakeVibrantView];
		// [_fakeVibrantView removeFromSuperview];
		// _fakeVibrantView.hidden = NO;
		// [self sendSubviewToBack:_fakeVibrantView];

		//UIView *otherView = [[UIView alloc] initWithFrame:self.bounds];
		//[self addSubview:otherView];
		//otherView.backgroundColor = [UIColor colorWithWhite:0.61 alpha:0.15];
		[_fakeVibrantView transitionIncrementallyToSettings:backdropSettings weighting:1.0];
		((CABackdropLayer *)_fakeVibrantView.effectView.layer).scale = 0.25;
		//[self sendSubviewToBack:_moduleVibrantExpandedBackground];
		[self sendSubviewToBack:_moduleVibrantBackground];
		//[self sendSubviewToBack:otherView];
		//[self sendSubviewToBack:_fakeVibrantView];

		_moduleVibrantBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//_moduleVibrantExpandedBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//otherView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//_fakeVibrantView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self setNeedsLayout];
	}
	if (!_moduleMaterialView && !_moduleProvidesOwnPlatter && isIOS11Mode) {
		_moduleMaterialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		[_moduleMaterialView setFrame:[self bounds]];
		[self addSubview:_moduleMaterialView];
		[_moduleMaterialView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[self sendSubviewToBack:_moduleMaterialView];
		_moduleMaterialView.backdropView.layer.groupName = @"ModuleDarkBackground";
		[self setNeedsLayout];
	}
}

- (void)useFakeVibrantView:(BOOL)useView {
	((CABackdropLayer *)_fakeVibrantView.effectView.layer).scale = 0.25;
	if (useView) {
		[self addSubview:_fakeVibrantView];
		[self sendSubviewToBack:_fakeVibrantView];
		//_fakeVibrantView.hidden = NO;
		_moduleVibrantBackground.hidden = YES;
	} else {
		_moduleVibrantBackground.hidden = NO;
		[_fakeVibrantView removeFromSuperview];
	}
}

- (void)transitionToExpandedMode:(BOOL)expandedMode {
	[self _transitionToExpandedMode:expandedMode force:NO];
}

- (void)_transitionToExpandedMode:(BOOL)expanded force:(BOOL)force {
	self.clipsToBounds = YES;
	CGFloat cornerRadius = 0;

	//if (![storedCornerRadiusExpanded objectForKey:[NSString stringWithFormat:]])

	if (self._continuousCornerRadius < 1.0f) {
		self._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
	}

	CGRect cornerCenter = CGRectZero;

	if (force || _expanded != expanded) {
		_expanded = expanded;
		if (expanded) {
			cornerRadius = [MZELayoutOptions expandedContinuousCornerRadius];
			cornerCenter = [MZELayoutOptions expandedCornerCenter];
		} else {
			cornerRadius = [MZELayoutOptions regularContinuousCornerRadius];
			cornerCenter = [MZELayoutOptions regularCornerCenter];
		}

		if (!isIOS11Mode && _moduleVibrantBackground) {
			((CABackdropLayer *)_fakeVibrantView.effectView.layer).scale = 0.25;
			if (expanded) {
				[self addSubview:_fakeVibrantView];
				[self sendSubviewToBack:_fakeVibrantView];
				_moduleVibrantBackground.hidden = YES;
				//_fakeVibrantView.alpha = 1.0;
				//_moduleVibrantExpandedBackground.alpha = 0.0;
				//_moduleVibrantBackground.alpha = 0.0;
				// _moduleVibrantBackground.layer.filters = nil;
				// _moduleVibrantBackground.layer.compositingFilter = _expandedBackgroundFilter;
			} else {
				//_fakeVibrantView.alpha = 1.0;
				//_moduleVibrantExpandedBackground.alpha = 0.0;
				//_moduleVibrantBackground.alpha = 1.0;
				//_moduleVibrantBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
				// CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
				// [filter setValue:(id)[[UIColor colorWithWhite:0.11 alpha:0.3] CGColor] forKey:@"inputColor0"];
				// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.05] CGColor] forKey:@"inputColor1"];
				// [filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
				// _moduleVibrantBackground.layer.compositingFilter = nil;
				// _moduleVibrantBackground.layer.filters = [NSArray arrayWithObjects:_compactBackgroundFilter, nil];
			}
		}

		self.layer.cornerRadius = cornerRadius;
		self.layer.cornerContentsCenter = cornerCenter;
	}
}

- (void)didTransitionToExpandedMode:(BOOL)arg1 {
	if (!isIOS11Mode && _moduleVibrantBackground) {
		if (!arg1) {
			//_fakeVibrantView.hidden = YES;
			[_fakeVibrantView removeFromSuperview];
			_moduleVibrantBackground.hidden = NO;
			// _moduleVibrantBackground.layer.compositingFilter = nil;
			// _moduleVibrantBackground.layer.filters = [NSArray arrayWithObjects:_compactBackgroundFilter, nil];
		}
	}
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:nil];
		[self setOpaque:NO];
		[self _transitionToExpandedMode:NO force:YES];
	}
	return self;
}

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (BOOL)shouldForwardSelector:(SEL)aSelector {
    return [self.layer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.layer : self;
}

- (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {
    //if ([key isEqual:@"_continuousCornerRadius"] || [key isEqual:@"_setContinuousCornerRadius:"]) return YES;
    return ([self shouldForwardSelector:NSSelectorFromString(key)] || [super _shouldAnimatePropertyWithKey:key]);
}
@end