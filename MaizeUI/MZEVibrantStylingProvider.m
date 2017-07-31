#import "MZEVibrantStylingProvider.h"
#import "MZEVibrantSecondaryDarkStyling.h"
#import "MZEVibrantPrimaryDarkStyling.h"


@implementation MZEVibrantStylingProvider
+ (MZEVibrantStyling *)_controlCenterPrimaryVibrantStyling {
	return [MZEVibrantPrimaryDarkStyling new];
}
+ (MZEVibrantStyling *)_controlCenterSecondaryVibrantStyling {
	return [MZEVibrantSecondaryDarkStyling new];
}
@end