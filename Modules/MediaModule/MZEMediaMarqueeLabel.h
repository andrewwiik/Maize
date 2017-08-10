#import "MZEMediaEffectLabel.h"
#import <MPUFoundation/MPUMarqueeView.h>
@interface MPUMarqueeView (Others)
-(void)setContentSize:(CGSize)arg1 ;
@end
@interface MZEMediaMarqueeLabel : MPUMarqueeView
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *label;
@end
