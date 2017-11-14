//#import "MZEPolusToggleModule.h"
#import <MaizeServices/MZEModuleProviderDelegate-Protocol.h>
#import <Polus/PLPrefsHelper.h>
#import <Polus/PLAppsController.h>
#import <Activator/Activator+Private.h>

#define DEFAULT_BUNDLE_ID @"com.a3tweaks.polus.defaultglyphs"

#define FLASH_ID @"com.a3tweaks.switch.flashlight"
#define FS_PREFIX @"fs-"
#define ACTION_PREFIX @"la-"

#define EVENT_PREFIX @"com.a3tweaks.polus"
#define HELD_EVENT_PREFIX @"com.a3tweaks.polus-held"

@interface MZEPolusProvider : NSObject <MZEModuleProviderDelegate>
+ (NSArray<NSString *> *)possibleIdentifiers;
+ (id<MZEContentModule>)moduleForIdentifier:(NSString *)identifier;
+ (UIImage *)glyphForIdentifier:(NSString *)identifier;
+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier;
+ (NSString *)displayNameForIdentifier:(NSString *)identifier;
+ (NSInteger)rowsForIdentifier:(NSString *)identifier;
+ (NSInteger)columnsForIdentifier:(NSString *)identifier;
@end