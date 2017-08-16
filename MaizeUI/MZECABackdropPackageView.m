#import "MZECABackdropPackageView.h"

@implementation MZECABackdropPackageView

+ (Class)layerClass {
	return NSClassFromString(@"CABackdropLayer");
}

@end