#import "MZEPocketMaterialView.h"

@interface SBUIChevronView : UIView
-(void)setState:(long long)arg1 animated:(BOOL)arg2 ;
-(void)setColor:(UIColor *)arg1 ;
@end

@interface MZEHeaderPocketView : UIView
@property(retain, nonatomic, readwrite) SBUIChevronView *headerChevronView; // @synthesize subtitleLabel=_subtitleLabel;
@property(retain, nonatomic, readwrite) UIView *headerDivider; // @synthesize subtitleLabel=_subtitleLabel;
@property(retain, nonatomic, readwrite) MZEPocketMaterialView *headerBackgroundView; // @synthesize subtitleLabel=_subtitleLabel;
@property(assign, nonatomic, readwrite) BOOL chevronPointingDown; // @synthesize subtitleLabel=_subtitleLabel;
@property(assign, nonatomic, readwrite) BOOL showingBackground; // @synthesize subtitleLabel=_subtitleLabel;
@property(assign, nonatomic, readwrite) CGFloat chevronAlpha; // @synthesize subtitleLabel=_subtitleLabel;
-(void)animateProgress:(CGFloat)arg1;
-(void)toggleDividerVisibility;
@end
