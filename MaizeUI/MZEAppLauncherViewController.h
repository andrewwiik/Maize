#import "MZEMenuModuleViewController.h"

@class MZEAppLauncherModule;

@interface MZEAppLauncherViewController : MZEMenuModuleViewController {
	MZEAppLauncherModule *_module;
}

@property(nonatomic, retain, readwrite) MZEAppLauncherModule *module;
- (id)init;
@end