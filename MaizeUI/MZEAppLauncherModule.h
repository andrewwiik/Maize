#import "MZEContentModule-Protocol.h"
#import "MZEAppLauncherViewController.h"

@interface MZEAppLauncherModule : NSObject <MZEContentModule>
{
    MZEAppLauncherViewController *_viewController;
    NSString *_applicationIdentifier;
    BOOL _supportsApplicationShortcuts;
}

@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@property(readonly, copy, nonatomic) NSString *glyphState;
@property(readonly, copy, nonatomic) CAPackage *glyphPackage;
@property(readonly, copy, nonatomic) UIImage *iconGlyph; // @dynamic iconGlyph;
@property(readonly, copy, nonatomic) NSString *applicationIdentifier;
@property(readonly, nonatomic) BOOL enabled;
@property(nonatomic, readwrite) BOOL supportsApplicationShortcuts;
- (NSString *)applicationIdentifier;
@end