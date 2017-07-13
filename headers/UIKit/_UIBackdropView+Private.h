#import <UIKit/_UIBackdropView.h>
#import <QuartzCore/CAFilter+Private.h>
@interface _UIBackdropView (Extra)
@property (assign,nonatomic) CGFloat appliesOutputSettingsAnimationDuration; 
@property (nonatomic, retain) CAFilter *colorSaturateFilter;
- (void)transitionIncrementallyToSettings:(id)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(NSInteger)arg1 weighting:(CGFloat)arg2;
- (id)initWithSettings:(id)arg1 ;

@end