#import <UIKit/_UIBackdropView.h>
#import <QuartzCore/CAFilter+Private.h>
@interface _UIBackdropView (Extraf)
@property (assign,nonatomic) CGFloat appliesOutputSettingsAnimationDuration; 
@property (nonatomic, retain) CAFilter *colorSaturateFilter;
@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,readonly) UIView * effectView; 
- (void)transitionIncrementallyToSettings:(id)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(NSInteger)arg1 weighting:(CGFloat)arg2;
- (id)initWithSettings:(id)arg1 ;
- (void)transitionToStyle:(NSInteger)style;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;

@end