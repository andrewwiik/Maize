#import "MZEAppLauncherViewController.h"
#import "MZEAppLauncherModule.h"
#import "macros.h"

@implementation MZEAppLauncherViewController
- (id)init {
	self = [super init];
	if (self) {

	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];

	[self setGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphColor:[UIColor whiteColor]];
	[self setGlyphPackage:[_module glyphPackage]];
	[self setEnabled:[_module isEnabled]];
	[self setAllowsHighlighting:YES];
	//[self refreshState];
}

- (id)appTest {
	if (_module) {
		if ([_module applicationIdentifier]) {
			if ([[_module applicationIdentifier] length] > 0) {
				if (NSClassFromString(@"SBApplication")) {
					SBApplication *app = applicationForID([_module applicationIdentifier]);
					return app;
					if (app) {
						launchApplication(app);
					}
				}
			}
		}
	}
	return nil;
}
- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	if (_module) {
		if ([_module applicationIdentifier]) {
			if ([[_module applicationIdentifier] length] > 0) {
				if (NSClassFromString(@"SBApplication")) {
					SBApplication *app = applicationForID([_module applicationIdentifier]);
					if (app) {
						launchApplication(app);
					}
				}
			}
		}
	}
	//HBLogInfo(@"THE BUTTON WAS TAPPED");
	// BOOL isSelected = [_module isSelected] ? NO : YES;
	// if ([_module shouldSelfSelect])
	// 	[self setSelected:isSelected];
	// [_module setSelected:isSelected];
	[super buttonTapped:button forEvent:event];
}
@end