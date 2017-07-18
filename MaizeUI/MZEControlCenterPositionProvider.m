#import "MZEControlCenterPositionProvider.h"

@implementation MZEControlCenterPositionProvider
- (id)initWithLayoutStyle:(MZELayoutStyle *)layoutStyle orderedIdentifiers:(NSArray<NSString *> *)orderedIdentifiers orderedSizes:(NSArray<NSValue *> *)orderedSizes {
	self = [super init];
	if (self) {
		_layoutStyle = layoutStyle;
		_orderedIdentifiers = orderedIdentifiers;
		_orderedSizes = orderedSizes;
	}
	return self;
}
- (CGRect)positionForIdentifier:(NSString *)identifier {
	return CGRectZero;
}

- (CGSize)sizeOfLayoutView {
	BOOL isLandscape = _layoutStyle.rows == -1 ? NO : YES;

	NSInteger numberOfSpacesTaken = 0;
	NSInteger numberOfRows = 0;
	NSInteger numberOfColumns = 0;
	for (NSValue *sizeValue in _orderedSizes) {
		CGSize size = [sizeValue CGSizeValue];
		numberOfSpacesTaken += (size.width * size.height);
	}

	if (isLandscape) {
		numberOfRows = _layoutStyle.rows;
		numberOfColumns = (NSInteger)floor((CGFloat)numberOfSpacesTaken/(CGFloat)numberOfRows);

	} else {
		numberOfColumns = _layoutStyle.columns;
		numberOfRows = (NSInteger)floor((CGFloat)numberOfSpacesTaken/(CGFloat)numberOfColumns);
	}

	CGFloat width = numberOfColumns*_layoutStyle.moduleSize + (numberOfColumns-1)*_layoutStyle.spacing + (_layoutStyle.inset * 2);
	CGFloat height = numberOfRows*_layoutStyle.moduleSize + (numberOfRows - 1)*_layoutStyle.spacing;

	return CGSizeMake(width, height);
}

- (void)generateAllFrames {

}
@end