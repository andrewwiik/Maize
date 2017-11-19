#import <MaizeUI/MZEMenuModuleViewController.h>

@class MZEPolusActionLauncherModule;

@interface MZEPolusActionLauncherViewController : MZEMenuModuleViewController {
	MZEPolusActionLauncherModule *_module;
}

@property(nonatomic, retain, readwrite) MZEPolusActionLauncherModule *module;
- (id)init;
- (NSString *)applicationIdentifier;
@end