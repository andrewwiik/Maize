#import "MZELayoutOptions.h"
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <UIKit/UIScreen+Private.h>
#import <UIKit/UIView+Private.h>
#import <QuartzCore/CALayer+Private.h>

static CGFloat cachedEdgeSize = 0;
static CGFloat cachedSpacingSize = 0;
static CGFloat cachedInsetSize = 0;
static CGFloat cachedRoundButtonSize = 0;
// static CGFloat cachedRoundButtonTitlePaddingSize = 0;
static CGFloat cachedRoundButtonExpandedSizeInsetSize = 0;
static CGFloat cachedRoundButtonExpandedContainerWidth = 0;
static CGFloat cachedRoundButtonExpandedContainerHeight = 0;
static CGFloat cachedDefaultExpandedModuleWidth = 0;
static CGFloat cachedDefaultMenuItemHeight = 0;
static CGFloat cachedRegularCornerRadius = 0;
static CGFloat cachedExpandedCornerRadius = 0;
static CGFloat cachedExpandedSliderHeight;
static CGFloat cachedExpandedSliderWidth;

static CGFloat regularContinuousCornerRadius = 0;
static CGRect regularCornerCenter;
static CGFloat expandedContinuousCornerRadius = 0;
static CGRect expandedCornerCenter;

MPULayoutInterpolator *spacingInterpolator;
MPULayoutInterpolator *edgeInterpolator;
MPULayoutInterpolator *insetInterpolator;
MPULayoutInterpolator *roundButtonInterpolator;
MPULayoutInterpolator *roundButtonExpandedSideInsetInterpolator;
MPULayoutInterpolator *roundButtonContainerExpandedSizeHeight;
MPULayoutInterpolator *roundButtonContainerExpandedSizeWidth;
MPULayoutInterpolator *sliderExpandedHeightInterpolator;
MPULayoutInterpolator *sliderExpandedWidthInterpolator;
MPULayoutInterpolator *defaultExpandedWidthInterpolator;
MPULayoutInterpolator *defaultMenuItemHeightInterpolator;
MPULayoutInterpolator *regularCornerRadiusInterpolator;
MPULayoutInterpolator *expandedCornerRadiusInterpolator;
// MPULayoutInterpolator *flipSwitchGlyphSizeInterpolator;
// MPULayoutInterpolator *flipSwitchOriginValueInterpolator;
// MPULayoutInterpolator *roundButtonTitlePaddingInterpolator;


static CGRect deviceBounds;
static CGFloat cachedDeviceWidth = 0;
static CGFloat cachedDeviceHeight = 0;
@implementation MZELayoutOptions

+ (CGFloat)deviceWidth {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		deviceBounds = [UIScreen mainScreen].bounds;
		if (cachedDeviceWidth < 1) {
			cachedDeviceWidth = deviceBounds.size.width > deviceBounds.size.height ? deviceBounds.size.height : deviceBounds.size.width;
		}
    });
    return cachedDeviceWidth;

}

+ (CGFloat)deviceHeight {
	static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
		deviceBounds = [UIScreen mainScreen].bounds;
		if (cachedDeviceHeight < 1) {
			cachedDeviceHeight = deviceBounds.size.width > deviceBounds.size.height ? deviceBounds.size.width : deviceBounds.size.height;
		}
    });
	return cachedDeviceHeight;
}

+ (void)setupInterpolators {

	static dispatch_once_t onceToken3;
    dispatch_once(&onceToken3, ^{

		CGFloat deviceWidth = [MZELayoutOptions deviceWidth];
		CGFloat deviceHeight = [MZELayoutOptions deviceHeight];
		if (!spacingInterpolator) {
			spacingInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[spacingInterpolator addValue:8 forReferenceMetric:320];
			[spacingInterpolator addValue:15 forReferenceMetric:375];
			[spacingInterpolator addValue:14 forReferenceMetric:414];
			[spacingInterpolator addValue:10 forReferenceMetric:768];
			cachedSpacingSize = [spacingInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!edgeInterpolator) {
			edgeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[edgeInterpolator addValue:66 forReferenceMetric:320];
			[edgeInterpolator addValue:69 forReferenceMetric:375];
			[edgeInterpolator addValue:76 forReferenceMetric:414];
			[edgeInterpolator addValue:66 forReferenceMetric:768];
			cachedEdgeSize = [edgeInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!insetInterpolator) {
			insetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[insetInterpolator addValue:16 forReferenceMetric:320];
			[insetInterpolator addValue:27 forReferenceMetric:375];
			[insetInterpolator addValue:34 forReferenceMetric:414];
			[insetInterpolator addValue:140 forReferenceMetric:568];
			[insetInterpolator addValue:173 forReferenceMetric:667];
			[insetInterpolator addValue:60 forReferenceMetric:736];
			[insetInterpolator addValue:30 forReferenceMetric:768];
			cachedInsetSize = [insetInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!roundButtonInterpolator) {
			roundButtonInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[roundButtonInterpolator addValue:52 forReferenceMetric:320];
			[roundButtonInterpolator addValue:54 forReferenceMetric:375];
			[roundButtonInterpolator addValue:60 forReferenceMetric:414];
			[roundButtonInterpolator addValue:52 forReferenceMetric:768];
			cachedRoundButtonSize = [roundButtonInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!roundButtonExpandedSideInsetInterpolator) {
			roundButtonExpandedSideInsetInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[roundButtonExpandedSideInsetInterpolator addValue:12 forReferenceMetric:320];
			[roundButtonExpandedSideInsetInterpolator addValue:16 forReferenceMetric:375];
			[roundButtonExpandedSideInsetInterpolator addValue:16 forReferenceMetric:414];
			[roundButtonExpandedSideInsetInterpolator addValue:14 forReferenceMetric:768];
			cachedRoundButtonExpandedSizeInsetSize = [roundButtonExpandedSideInsetInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!roundButtonContainerExpandedSizeHeight) {
			roundButtonContainerExpandedSizeHeight = [NSClassFromString(@"MPULayoutInterpolator") new];
			[roundButtonContainerExpandedSizeHeight addValue:84.5 forReferenceMetric:320];
			[roundButtonContainerExpandedSizeHeight addValue:86.5 forReferenceMetric:375];
			[roundButtonContainerExpandedSizeHeight addValue:92.3333 forReferenceMetric:414];
			cachedRoundButtonExpandedContainerHeight = [roundButtonContainerExpandedSizeHeight valueForReferenceMetric:deviceWidth];
		}

		if (!roundButtonContainerExpandedSizeWidth) {
			roundButtonContainerExpandedSizeWidth = [NSClassFromString(@"MPULayoutInterpolator") new];
			[roundButtonContainerExpandedSizeWidth addValue:126 forReferenceMetric:320];
			[roundButtonContainerExpandedSizeWidth addValue:136.5 forReferenceMetric:375];
			[roundButtonContainerExpandedSizeWidth addValue:149 forReferenceMetric:414];
			cachedRoundButtonExpandedContainerWidth = [roundButtonContainerExpandedSizeWidth valueForReferenceMetric:deviceWidth];
		}

		if (!sliderExpandedHeightInterpolator) {
			sliderExpandedHeightInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[sliderExpandedHeightInterpolator addValue:254 forReferenceMetric:568];
			[sliderExpandedHeightInterpolator addValue:315 forReferenceMetric:667];
			[sliderExpandedHeightInterpolator addValue:340 forReferenceMetric:736];
			[sliderExpandedHeightInterpolator addValue:340 forReferenceMetric:1024];
			[sliderExpandedHeightInterpolator addValue:340 forReferenceMetric:768];

			cachedExpandedSliderHeight = [sliderExpandedHeightInterpolator valueForReferenceMetric:deviceHeight];
		}

		if (!sliderExpandedWidthInterpolator) {
			sliderExpandedWidthInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[sliderExpandedWidthInterpolator addValue:106 forReferenceMetric:320];
			[sliderExpandedWidthInterpolator addValue:123 forReferenceMetric:375];
			[sliderExpandedWidthInterpolator addValue:132 forReferenceMetric:414];
			[sliderExpandedWidthInterpolator addValue:123 forReferenceMetric:768];
			[sliderExpandedWidthInterpolator addValue:123 forReferenceMetric:1024];

			cachedExpandedSliderWidth = [sliderExpandedWidthInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!defaultExpandedWidthInterpolator) {
			defaultExpandedWidthInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[defaultExpandedWidthInterpolator addValue:288 forReferenceMetric:320];
			[defaultExpandedWidthInterpolator addValue:321 forReferenceMetric:375];
			[defaultExpandedWidthInterpolator addValue:346 forReferenceMetric:414];
			[defaultExpandedWidthInterpolator addValue:321 forReferenceMetric:768];
			[defaultExpandedWidthInterpolator addValue:321 forReferenceMetric:1024];

			cachedDefaultExpandedModuleWidth = [defaultExpandedWidthInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!defaultMenuItemHeightInterpolator) {
			defaultMenuItemHeightInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[defaultMenuItemHeightInterpolator addValue:50.5 forReferenceMetric:320];
			[defaultMenuItemHeightInterpolator addValue:56 forReferenceMetric:375];
			[defaultMenuItemHeightInterpolator addValue:56 forReferenceMetric:414];
			[defaultMenuItemHeightInterpolator addValue:56 forReferenceMetric:768];
			[defaultMenuItemHeightInterpolator addValue:56 forReferenceMetric:1024];

			cachedDefaultMenuItemHeight = [defaultMenuItemHeightInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!regularCornerRadiusInterpolator) {
			regularCornerRadiusInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[regularCornerRadiusInterpolator addValue:17 forReferenceMetric:320];
			[regularCornerRadiusInterpolator addValue:19 forReferenceMetric:375];
			[regularCornerRadiusInterpolator addValue:21 forReferenceMetric:414];
			[regularCornerRadiusInterpolator addValue:19 forReferenceMetric:768];
			[regularCornerRadiusInterpolator addValue:19 forReferenceMetric:1024];

			cachedRegularCornerRadius = [regularCornerRadiusInterpolator valueForReferenceMetric:deviceWidth];
		}

		if (!expandedCornerRadiusInterpolator) {
			expandedCornerRadiusInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
			[expandedCornerRadiusInterpolator addValue:34 forReferenceMetric:320];
			[expandedCornerRadiusInterpolator addValue:39 forReferenceMetric:375];
			[expandedCornerRadiusInterpolator addValue:41 forReferenceMetric:414];
			[expandedCornerRadiusInterpolator addValue:39 forReferenceMetric:768];
			[expandedCornerRadiusInterpolator addValue:39 forReferenceMetric:1024];

			cachedExpandedCornerRadius = [expandedCornerRadiusInterpolator valueForReferenceMetric:deviceWidth];
		}

		UIView *psuedoCornerCalculator = [[UIView alloc] initWithFrame:CGRectMake(0,0,cachedEdgeSize*2,cachedEdgeSize*2)];
		psuedoCornerCalculator._continuousCornerRadius = cachedRegularCornerRadius;

		regularContinuousCornerRadius = psuedoCornerCalculator.layer.cornerRadius;
		regularCornerCenter = psuedoCornerCalculator.layer.cornerContentsCenter;

		psuedoCornerCalculator._continuousCornerRadius = cachedExpandedCornerRadius;

		expandedCornerCenter = psuedoCornerCalculator.layer.cornerContentsCenter;
		expandedContinuousCornerRadius = psuedoCornerCalculator.layer.cornerRadius;


		// 123 - 340

		// if (!flipSwitchGlyphSizeInterpolator) {
		// 	flipSwitchGlyphSizeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		// 	[flipSwitchGlyphSizeInterpolator addValue:36 forReferenceMetric:320];
		// 	[flipSwitchGlyphSizeInterpolator addValue:37 forReferenceMetric:375];
		// 	[flipSwitchGlyphSizeInterpolator addValue:36 forReferenceMetric:414];
		// 	cachedRoundButtonSize = [flipSwitchGlyphSizeInterpolator valueForReferenceMetric:deviceWidth];
		// }



		// if (!roundButtonTitlePaddingInterpolator) {
		// 	roundButtonTitlePaddingInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		// 	[roundButtonTitlePaddingInterpolator addValue:12 forReferenceMetric:320];
		// 	[roundButtonTitlePaddingInterpolator addValue:54 forReferenceMetric:375];
		// 	[roundButtonTitlePaddingInterpolator addValue:60 forReferenceMetric:414];
		// 	cachedRoundButtonTitlePaddingSize = [roundButtonTitlePaddingInterpolator valueForReferenceMetric:deviceWidth];
		// }
	});
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

	return [insetInterpolator valueForReferenceMetric:[[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation].size.width];
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
	if (cachedRegularCornerRadius == 0) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedRegularCornerRadius;

	// 17 for small
}

+ (CGFloat)expandedModuleCornerRadius {
	if (cachedExpandedCornerRadius == 0) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedExpandedCornerRadius;

	//34 for small
}

+ (CGFloat)defaultExpandedContentModuleWidth {
	if (!insetInterpolator) {
		[MZELayoutOptions setupInterpolators];
	}
	return [insetInterpolator valueForReferenceMetric:[[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation].size.width];
}

+ (CGFloat)defaultExpandedSliderHeight {
	if (!sliderExpandedHeightInterpolator) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedExpandedSliderHeight;
}

+ (CGFloat)defaultExpandedSliderWidth {
	if (!defaultExpandedWidthInterpolator) {
		[MZELayoutOptions setupInterpolators];
	}
	return cachedExpandedSliderWidth;
}

+ (CGRect)orientationRelativeScreenBounds {
	return [[UIScreen mainScreen] _mainSceneBoundsForInterfaceOrientation:[UIDevice currentDevice].orientation];
}

+ (CGFloat)defaultExpandedModuleWidth {
	if (!regularCornerRadiusInterpolator) {
		[MZELayoutOptions setupInterpolators];
	}
	
	return cachedDefaultExpandedModuleWidth;
}

+ (CGFloat)defaultMenuItemHeight {
	if (!defaultMenuItemHeightInterpolator) {
		[MZELayoutOptions setupInterpolators];
	}

	return cachedDefaultMenuItemHeight;
}


#pragma mark Damn Weird Corner Radius

+ (CGFloat)expandedContinuousCornerRadius {
	if (cachedRegularCornerRadius < 1) {
		[MZELayoutOptions setupInterpolators];
	}

	return expandedContinuousCornerRadius;
}

+ (CGFloat)regularContinuousCornerRadius {
	if (cachedRegularCornerRadius < 1) {
		[MZELayoutOptions setupInterpolators];
	}

	return regularContinuousCornerRadius;
}

+ (CGRect)regularCornerCenter {
	if (cachedRegularCornerRadius < 1) {
		[MZELayoutOptions setupInterpolators];
	}

	return regularCornerCenter;
}

+ (CGRect)expandedCornerCenter {
	if (cachedRegularCornerRadius < 1) {
		[MZELayoutOptions setupInterpolators];
	}

	return expandedCornerCenter;
}

#pragma mark FlipSwitchCalculations

+ (CGFloat)flipSwitchGlyphSize {
	return 35.0f;
}

+ (CGPoint)flipSwitchGlyphOrigin {
	CGFloat origin = ([self edgeSize] - [self flipSwitchGlyphSize])/2;
	return CGPointMake(origin,origin);
}

@end