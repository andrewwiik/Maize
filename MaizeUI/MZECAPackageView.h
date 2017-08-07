#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAPackage+Private.h>
#import <QuartzCore/CAStateController+Private.h>
#import "macros.h"

@interface MZECAPackageView : UIView
{
    CAPackage *_package;
    CAStateController *_stateController;
    CALayer *_packageLayer;
}

@property(retain, nonatomic) CAPackage *package; // @synthesize package=_package;
- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (void)_setPackage:(CAPackage *)package;
- (void)setStateName:(NSString *)name;
- (void)layoutSubviews;

@end