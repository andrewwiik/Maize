#import "MZEModuleSettingsListController.h"

@implementation MZEModuleSettingsListController

- (id)initWithModuleMetadata:(MZEModuleMetadata *)metadata {
	self = [super init];
	if (self) {
		_metadata = metadata;
	}
	return self;
}

-(id)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *array = [NSMutableArray array];
    
	    NSString *path = [NSString stringWithFormat:@"%@/Settings", _metadata.bundlePath.path];
	    
	    NSBundle *widgetBundle = [NSBundle bundleWithPath:path];
	    _settingsBundle = widgetBundle;
	    
	    array = [[self loadSpecifiersFromPlistName:@"Root" target:self bundle:widgetBundle] mutableCopy];
	   // array = [[self localizedSpecifiersForSpecifiers:array andBundle:widgetBundle] mutableCopy];
	    
	    if ([self respondsToSelector:@selector(navigationItem)]) {
	        [[self navigationItem] setTitle:_metadata.displayName];
	    }
        
        _specifiers = array;
    }
    
	return _specifiers;
}
@end