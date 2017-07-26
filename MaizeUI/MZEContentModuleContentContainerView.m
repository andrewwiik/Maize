#import "MZEContentModuleContentContainerView.h"
#import "MZELayoutOptions.h"

@implementation MZEContentModuleContentContainerView
	@synthesize moduleMaterialView=_moduleMaterialView;

- (void)_setContinuousCornerRadius:(CGFloat)cornerRadius {
	if (_moduleMaterialView) {
		_moduleMaterialView.layer.cornerRadius = cornerRadius;
		_moduleMaterialView.clipsToBounds = cornerRadius > 0 ? YES : NO;
	}
}

- (void)layoutSubviews {
	[self _configureModuleMaterialViewIfNecessary];
	[super layoutSubviews];
}

- (void)addSubview:(UIView *)subview {
	[super addSubview:subview];
	[self _transitionToExpandedMode:_expanded force:YES];
}

- (MZEMaterialView *)moduleMaterialView {
	[self _configureModuleMaterialViewIfNecessary];
	return _moduleMaterialView;
}

- (void)setModuleProvidesOwnPlatter:(BOOL)providesOwnPlatter {
	_moduleProvidesOwnPlatter = providesOwnPlatter;
	if (providesOwnPlatter) {
		[_moduleMaterialView removeFromSuperview];
		_moduleMaterialView = nil;
	} else {
		[self _configureModuleMaterialViewIfNecessary];
	}
}

- (void)_configureModuleMaterialViewIfNecessary {
	if (!_moduleMaterialView && !_moduleProvidesOwnPlatter) {
		_moduleMaterialView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		[_moduleMaterialView setFrame:[self bounds]];
		[_moduleMaterialView setAutoresizingMask:18];
		[self addSubview:_moduleMaterialView];
		[self sendSubviewToBack:_moduleMaterialView];
		[self setNeedsLayout];
	}
}

- (void)transitionToExpandedMode:(BOOL)expandedMode {
	[self _transitionToExpandedMode:expandedMode force:NO];
}

- (void)_transitionToExpandedMode:(BOOL)expanded force:(BOOL)force {
	CGFloat cornerRadius = 0;
	if (force || _expanded != expanded) {
		_expanded = expanded;
		if (expanded) {
			cornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		} else {
			cornerRadius = [MZELayoutOptions regularCornerRadius];
		}
		[self _setContinuousCornerRadius:cornerRadius];
	}
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setOpaque:NO];
		[self _transitionToExpandedMode:NO force:YES];
	}
	return self;
}

- (id)init {
	return [self initWithFrame:CGRectZero];
}
@end