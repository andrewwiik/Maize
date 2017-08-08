#import "MZEMediaLayoutHelper.h"
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <UIKit/UIScreen+Private.h>

MPULayoutInterpolator *compactInsetInterpolator;
MPULayoutInterpolator *expandedSideInsetInterpolator;
MPULayoutInterpolator *expandedTopInsetInterpolator;
MPULayoutInterpolator *expandedBottomInsetInterpolator;
MPULayoutInterpolator *expandedPortraitContainerInsetInterpolator;
static BOOL loadedInterpolators = NO;

@implementation MZEMediaLayoutHelper
+ (void)setupInterpolators {
	if (!compactInsetInterpolator) {
		compactInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[compactInsetInterpolator addValue:15 forReferenceMetric:166];
		[compactInsetInterpolator addValue:15 forReferenceMetric:153];
		[compactInsetInterpolator addValue:12 forReferenceMetric:140];
	}

	if (!expandedSideInsetInterpolator) {
		expandedSideInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[expandedSideInsetInterpolator addValue:16 forReferenceMetric:346];
		[expandedSideInsetInterpolator addValue:16 forReferenceMetric:321];
		[expandedSideInsetInterpolator addValue:12 forReferenceMetric:288];

	}

	if (!expandedTopInsetInterpolator) {
		expandedTopInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[expandedTopInsetInterpolator addValue:42 forReferenceMetric:320];
		[expandedTopInsetInterpolator addValue:44 forReferenceMetric:375];
		[expandedTopInsetInterpolator addValue:52 forReferenceMetric:414];
	}

	if (!expandedPortraitContainerInsetInterpolator) {
		expandedPortraitContainerInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[expandedPortraitContainerInsetInterpolator addValue:16 forReferenceMetric:320];
		[expandedPortraitContainerInsetInterpolator addValue:27 forReferenceMetric:375];
		[expandedPortraitContainerInsetInterpolator addValue:34 forReferenceMetric:414];
	}
	loadedInterpolators = YES;
}

+ (UIEdgeInsets)compactLayoutInsets {
	if (!loadedInterpolators) {
		[MZEMediaLayoutHelper setupInterpolators];
	}

	CGFloat inset = [compactInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen]._referenceBounds.size.width];
	return UIEdgeInsetsMake(inset,inset,inset,inset);
}

+ (UIEdgeInsets)expandedLayoutInsetsForSize:(CGSize)size {
	if (!loadedInterpolators) {
		[MZEMediaLayoutHelper setupInterpolators];
	}

	BOOL isLandscape = size.width > size.height;
	if (isLandscape) {
		CGFloat topInset = [expandedTopInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen]._referenceBounds.size.width];
		CGFloat bottomInset = topInset + 2.0;
		CGFloat compactInset = [compactInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen]._referenceBounds.size.width];
		CGFloat sideInset = compactInset * (5.0 + (1.0/3.0));
		return UIEdgeInsetsMake(topInset, sideInset, bottomInset, sideInset);
	} else {
		CGFloat sideInset = [expandedSideInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen]._referenceBounds.size.width];
		CGFloat topInset = [expandedTopInsetInterpolator valueForReferenceMetric:[UIScreen mainScreen]._referenceBounds.size.width];
		CGFloat bottomInset = topInset + 2.0;
		return UIEdgeInsetsMake(topInset, sideInset, bottomInset, sideInset);
	}
}

+ (CGFloat)buttonWidthForInsets:(UIEdgeInsets)insets containerSize:(CGSize)containerSize numberOfColumns:(NSUInteger)colCount {
	if (!loadedInterpolators) {
		[MZEMediaLayoutHelper setupInterpolators];
	}

	BOOL isLandscape = containerSize.width > containerSize.height;
	if (isLandscape) {
		return containerSize.width - (insets.left * 2 + ((colCount - 1)*(insets.left * 0.5)))/colCount;
	} else {
		return containerSize.width - (insets.left * 2 + ((colCount - 1)*insets.left))/colCount;
	}
	//return insets.left * 2 +
}

+ (CGFloat)widthForExpandedContainerWithContainerSize:(CGSize)size defaultButtonSize:(CGSize)buttonSize {
	if (!loadedInterpolators) {
		[MZEMediaLayoutHelper setupInterpolators];
	}

	BOOL isLandscape = size.width > size.height;
	if (isLandscape) {
		return size.width - (buttonSize.width * 2);
	} else {
		return size.width - ([expandedPortraitContainerInsetInterpolator valueForReferenceMetric:size.width]*2);
	}
}

	/*

	small : 64 inset landscape


	button width = inset landscape * 2 + ((number of cols - 1)*(inset landscape * 0.5);

	inset landscape = compact inset * (5.0 + (1.0/3.0));
	container width landscape = outside container width - (default button width * 2);
	container width porttrait = outside conaine width - (default container side inset * 2.0)

	container Height landscape =

	16, 27, 34
	1.629

	top container inset for large is 31 , for small is 17
	top inset is 52 for large, 44 for mid, and 42 for small

	bottom inset is 54 for large, 46 for mid, 44 ,so really 2+ the top

	top inset is 36 for large and mid and 32 for small

	80 side for large and mid and 64 for small

	32 landscaoe spacing for small

	36 land spaing for large

	34 for mid



	*/

@end
