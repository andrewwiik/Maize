#import <UIKit/UIControl.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPUAVRouteHeaderLabel.h>

@interface MPUAVRouteHeaderView : UIControl {

	CAShapeLayer* _topSeparatorLayer;
	CAShapeLayer* _bottomSeparatorLayer;
	UIImageView* _iconImageView;
	UIImageView* _disclosureIndicatorImageView;
	BOOL _activated;
	MPAVRoute* _route;
	UIVisualEffect* _primaryVisualEffect;
	UIVisualEffect* _secondaryVisualEffect;
	MPUAVRouteHeaderLabel* _textLabel;

}

@property (nonatomic,retain) MPAVRoute * route;                                   //@synthesize route=_route - In the implementation block
@property (nonatomic,retain) UIVisualEffect * primaryVisualEffect;                //@synthesize primaryVisualEffect=_primaryVisualEffect - In the implementation block
@property (nonatomic,retain) UIVisualEffect * secondaryVisualEffect;              //@synthesize secondaryVisualEffect=_secondaryVisualEffect - In the implementation block
@property (assign,getter=isActivated,nonatomic) BOOL activated;                   //@synthesize activated=_activated - In the implementation block
@property (nonatomic,readonly) MPUAVRouteHeaderLabel * textLabel;                 //@synthesize textLabel=_textLabel - In the implementation block
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
-(id)initWithCoder:(NSCoder *)coder;
-(void)_init;
-(void)setHighlighted:(BOOL)highlighted;
-(MPUAVRouteHeaderLabel *)textLabel;
-(void)setActivated:(BOOL)activated;
-(MPAVRoute *)route;
-(void)setRoute:(MPAVRoute *)route;
-(UIVisualEffect *)primaryVisualEffect;
-(UIVisualEffect *)secondaryVisualEffect;
-(void)setPrimaryVisualEffect:(UIVisualEffect *)visualEffect;
-(void)setSecondaryVisualEffect:(UIVisualEffect *)visualEffect;
-(BOOL)isActivated;
-(void)setActivated:(BOOL)activated animated:(BOOL)animated;
-(UIImage *)_disclosureIconImageForCurrentState;
-(void)_updateBottomClippingForAnimatedTransition;
@end
