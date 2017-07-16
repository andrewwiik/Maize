#import "MZELayoutOptions.h"
#import <MPUFoundation/MPULayoutInterpolator.h>

static CGFloat cachedEdgeSize = 0;
static CGFloat cachedSpacingSize = 0;
static CGFloat cachedInsetSize = 0;
static CGFloat cachedRoundButtonSize = 0;
// static CGFloat cachedRoundButtonTitlePaddingSize = 0;
static CGFloat cachedRoundButtonExpandedSizeInsetSize = 0;
static CGFloat cachedRoundButtonExpandedContainerWidth = 0;
static CGFloat cachedRoundButtonExpandedContainerHeight = 0;

MPULayoutInterpolator *spacingInterpolator;
MPULayoutInterpolator *edgeInterpolator;
MPULayoutInterpolator *insetInterpolator;
MPULayoutInterpolator *roundButtonInterpolator;
MPULayoutInterpolator *roundButtonExpandedSideInsetInterpolator;
MPULayoutInterpolator *roundButtonContainerExpandedSizeHeight;
MPULayoutInterpolator *roundButtonContainerExpandedSizeWidth;
// MPULayoutInterpolator *roundButtonTitlePaddingInterpolator;


@implementation MZELayoutOptions

+ (void)setupInterpolators {
	if (!spacingInterpolator) {
		spacingInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[spacingInterpolator addValue:8 forReferenceMetric:320];
		[spacingInterpolator addValue:15 forReferenceMetric:375];
		[spacingInterpolator addValue:14 forReferenceMetric:414];
		cachedSpacingSize = [spacingInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!edgeInterpolator) {
		edgeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[edgeInterpolator addValue:66 forReferenceMetric:320];
		[edgeInterpolator addValue:69 forReferenceMetric:375];
		[edgeInterpolator addValue:76 forReferenceMetric:414];
		cachedEdgeSize = [edgeInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!insetInterpolator) {
		insetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[insetInterpolator addValue:16 forReferenceMetric:320];
		[insetInterpolator addValue:27 forReferenceMetric:375];
		[insetInterpolator addValue:34 forReferenceMetric:414];
		cachedInsetSize = [insetInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!roundButtonInterpolator) {
		roundButtonInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[roundButtonInterpolator addValue:52 forReferenceMetric:320];
		[roundButtonInterpolator addValue:54 forReferenceMetric:375];
		[roundButtonInterpolator addValue:60 forReferenceMetric:414];
		cachedRoundButtonSize = [roundButtonInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!roundButtonExpandedSideInsetInterpolator) {
		roundButtonExpandedSideInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[roundButtonExpandedSideInsetInterpolator addValue:12 forReferenceMetric:320];
		[roundButtonExpandedSideInsetInterpolator addValue:16 forReferenceMetric:375];
		[roundButtonExpandedSideInsetInterpolator addValue:16 forReferenceMetric:414];
		cachedRoundButtonExpandedSizeInsetSize = [roundButtonExpandedSideInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!roundButtonContainerExpandedSizeHeight) {
		roundButtonContainerExpandedSizeHeight = [NSClassFromString(@"MPULayoutInterpolator") new];
		[roundButtonContainerExpandedSizeHeight addValue:84.5 forReferenceMetric:320];
		[roundButtonContainerExpandedSizeHeight addValue:86.5 forReferenceMetric:375];
		[roundButtonContainerExpandedSizeHeight addValue:92.3333 forReferenceMetric:414];
		cachedRoundButtonExpandedContainerHeight = [roundButtonContainerExpandedSizeHeight valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	if (!roundButtonContainerExpandedSizeWidth) {
		roundButtonContainerExpandedSizeWidth = [NSClassFromString(@"MPULayoutInterpolator") new];
		[roundButtonContainerExpandedSizeWidth addValue:126 forReferenceMetric:320];
		[roundButtonContainerExpandedSizeWidth addValue:136.5 forReferenceMetric:375];
		[roundButtonContainerExpandedSizeWidth addValue:149 forReferenceMetric:414];
		cachedRoundButtonExpandedContainerWidth = [roundButtonContainerExpandedSizeWidth valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}



	// if (!roundButtonTitlePaddingInterpolator) {
	// 	roundButtonTitlePaddingInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// 	[roundButtonTitlePaddingInterpolator addValue:12 forReferenceMetric:320];
	// 	[roundButtonTitlePaddingInterpolator addValue:54 forReferenceMetric:375];
	// 	[roundButtonTitlePaddingInterpolator addValue:60 forReferenceMetric:414];
	// 	cachedRoundButtonTitlePaddingSize = [roundButtonTitlePaddingInterpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	// }
}

+ (CGFloat)itemSpacingSize {
	if (cachedSpacingSize == 0) {
		[MZELayoutOptions setupInterpolators];
	}

	return cachedSpacingSize;
}
+ (CGFloat)edgeSize {
	if (cachedEdgeSize == 0) {
		[MZELayoutOptions setupInterpolators];
	}

	return cachedEdgeSize;
}
+ (CGFloat)edgeInsetSize {
	if (cachedInsetSize == 0) {
		[MZELayoutOptions setupInterpolators];
	}

	return cachedInsetSize;
}

+ (CGFloat)roundButtonSize {
	if (cachedRoundButtonSize == 0) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedRoundButtonSize;
}

+ (CGFloat)roundButtonTitlePaddingSize {
	return 12.0f;
}

+ (CGFloat)roundButtonSubtitlePaddingSize {
	return 28.0f;
}

+ (CGFloat)roundButtonExpandedSideInsetSize {
	if (cachedRoundButtonExpandedSizeInsetSize == 0) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedRoundButtonExpandedSizeInsetSize;
}

+ (CGSize)roundButtonContainerExpandedSize {
	if (!cachedRoundButtonExpandedContainerWidth || !cachedRoundButtonExpandedContainerHeight) {
		[MZELayoutOptions setupInterpolators];
	}
	return CGSizeMake(cachedRoundButtonExpandedContainerWidth, cachedRoundButtonExpandedContainerHeight);
}

+ (CGFloat)regularCornerRadius {
	return 19.0f;
}

+ (CGFloat)expandedModuleCornerRadius {
	return 38.0f;
}
@end