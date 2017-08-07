#import "MZELayoutView.h"
@protocol MZELayoutViewLayoutSource;

@interface MZEModuleCollectionView : MZELayoutView
- (id)initWithLayoutSource:(id<MZELayoutViewLayoutSource>)layoutSource frame:(CGRect)frame;
@end