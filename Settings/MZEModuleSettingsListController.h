#import <Preferences/PSListController.h>
#import <MaizeServices/MZEModuleMetadata.h>

@interface MZEModuleSettingsListController : PSListController {
	MZEModuleMetadata *_metadata;
	NSBundle *_settingsBundle;
}
@property (nonatomic, retain, readwrite) MZEModuleMetadata *metadata;
- (id)initWithModuleMetadata:(MZEModuleMetadata *)metadata;
- (id)specifiers;
@end