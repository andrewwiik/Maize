#import "MZELayoutStyle.h"

@interface MZEControlCenterPositionProvider : NSObject
- (id)initWithLayoutStyle:(MZELayoutStyle *)layoutStyle orderIdentifiers:(NSArray<NSString *> *)orderedIdentifiers orderedSize:(NSArray<NSString *> *)orderSizes;
- (CGRect)positionForIdentifier:(NSString *)identifier;
- (void)regenerateAllFrames;
@end