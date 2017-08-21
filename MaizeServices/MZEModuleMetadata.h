#import "MZEModuleProviderDelegate-Protocol.h"

@interface MZEModuleMetadata : NSObject {
	NSURL *_bundlePath;
	NSString *_identifier;
	NSNumber *_moduleWidth;
	NSNumber *_moduleHeight;
	NSArray *_supportedDeviceFamilies;
	BOOL _isProvider;
	NSString *_providerClass;

}
@property (nonatomic, retain, readwrite) NSURL *bundlePath;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) NSNumber *moduleWidth;
@property (nonatomic, retain, readwrite) NSNumber *moduleHeight;
@property (nonatomic, retain, readwrite) NSArray *supportedDeviceFamilies;
@property (nonatomic, readonly, getter=isProvider) BOOL isProvider;
- (id)initWithBundlePath:(NSURL *)bundlePath;
- (id)initWithInfoDictionary:(NSDictionary *)info andBundlePath:(NSURL *)bundlePath;
- (Class<MZEModuleProviderDelegate>)providerClass;
@end