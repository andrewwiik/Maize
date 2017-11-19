#import <MaizeUI/MZEContentModule-Protocol.h>
#import "MZEPolusActionLauncherViewController.h"

@interface MZEPolusActionLauncherModule : NSObject <MZEContentModule>
{
    MZEPolusActionLauncherViewController *_viewController;
    NSString *_applicationIdentifier;
    BOOL _supportsApplicationShortcuts;
    NSString *_identifier;
    UIImage *_cachedIconGlyph;
}

@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@property(readonly, copy, nonatomic) UIImage *iconGlyph; // @dynamic iconGlyph;
@property(readonly, copy, nonatomic) NSString *applicationIdentifier;
@property(readonly, nonatomic) BOOL enabled;
@property(nonatomic, readwrite) BOOL supportsApplicationShortcuts;
- (id)initWithIdentifier:(NSString *)identifier;
- (NSString *)applicationIdentifier;
- (BOOL)isEnabled;
@end