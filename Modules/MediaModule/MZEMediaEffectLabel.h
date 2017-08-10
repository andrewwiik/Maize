#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@interface MZEMediaEffectLabel : UILabel
@property (nonatomic, readwrite) int style;
-(void)setEffects:(int)style;
@end
