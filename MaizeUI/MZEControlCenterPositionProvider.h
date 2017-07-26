#import "MZELayoutStyle.h"

@interface MZEControlCenterPositionProvider : NSObject {
	MZELayoutStyle *_layoutStyle;
	NSArray *_orderedIdentifiers;
	NSArray *_orderedSizes;
	CGFloat _numberOfColumns;
	CGFloat _numberOfRows;
}
@property (nonatomic, retain, readwrite) MZELayoutStyle *layoutStyle;
@property (nonatomic, retain, readwrite) NSArray *orderedIdentifiers;
@property (nonatomic, retain, readwrite) NSArray *orderedSizes;
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, NSValue *> *framesByIdentifiers;

- (id)initWithLayoutStyle:(MZELayoutStyle *)layoutStyle orderedIdentifiers:(NSArray<NSString *> *)orderedIdentifiers orderedSizes:(NSArray<NSString *> *)orderedSizes;
- (CGRect)positionForIdentifier:(NSString *)identifier;
- (void)generateAllFrames;
- (CGSize)sizeOfLayoutView;
- (NSMutableArray *)testOtherOrder;
- (NSMutableDictionary *)orderedStuff;
@end