#import "MZEContentModule-Protocol.h"
#import "MZEToggleViewController.h"

@interface MZEToggleModule : NSObject <MZEContentModule>
{
    MZEToggleViewController *_viewController;
}

@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
- (void)refreshState;
@property(readonly, copy, nonatomic) NSString *glyphState;
@property(readonly, copy, nonatomic) CAPackage *glyphPackage;
@property(readonly, copy, nonatomic) UIColor *selectedColor; // @dynamic selectedColor;
@property(readonly, copy, nonatomic) UIImage *selectedIconGlyph; // @dynamic selectedIconGlyph;
@property(readonly, copy, nonatomic) UIImage *iconGlyph; // @dynamic iconGlyph;
@property(nonatomic, getter=isSelected) BOOL selected; // @dynamic selected;

@end