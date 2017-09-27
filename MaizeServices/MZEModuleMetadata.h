#import "MZEModuleProviderDelegate-Protocol.h"

@interface MZEModuleMetadata : NSObject {
	NSURL *_bundlePath;
	NSString *_identifier;
	NSNumber *_moduleWidth;
	NSNumber *_moduleHeight;
	NSArray *_supportedDeviceFamilies;
	NSString *_displayName;
	UIImage *_settingsIconGlyph;
	UIColor *_settingsIconBackgroundColor;
	BOOL _isProvider;
	NSString *_providerClass;

}
@property (nonatomic, retain, readwrite) NSURL *bundlePath;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) NSNumber *moduleWidth;
@property (nonatomic, retain, readwrite) NSNumber *moduleHeight;
@property (nonatomic, retain, readwrite) NSArray *supportedDeviceFamilies;
@property (nonatomic, retain, readwrite) NSString *displayName;
@property (nonatomic, retain, readwrite) UIImage *settingsIconGlyph;
@property (nonatomic, retain, readwrite) UIColor *settingsIconBackgroundColor;
@property (nonatomic, readonly, getter=isProvider) BOOL isProvider;
- (id)initWithBundlePath:(NSURL *)bundlePath;
- (id)initWithInfoDictionary:(NSDictionary *)info andBundlePath:(NSURL *)bundlePath;
- (Class<MZEModuleProviderDelegate>)providerClass;
@end