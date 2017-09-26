#import <MaizeUI/MZEFlipSwitchToggleModule.h>
#import <MaizeServices/MZEModuleProviderDelegate-Protocol.h>

@interface MZEFlipSwitchProvider : NSObject <MZEModuleProviderDelegate>
+ (NSArray<NSString *> *)possibleIdentifiers;
+ (id<MZEContentModule>)moduleForIdentifier:(NSString *)identifier;
+ (UIImage *)glyphForIdentifier:(NSString *)identifier;
+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier;
+ (NSString *)displayNameForIdentifier:(NSString *)identifier;
+ (NSInteger)rowsForIdentifier:(NSString *)identifier;
+ (NSInteger)columnsForIdentifier:(NSString *)identifier;
@end