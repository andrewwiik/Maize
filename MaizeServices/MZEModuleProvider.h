#import "MZEModuleProviderDelegate-Protocol.h"

@interface MZEModuleProvider : NSObject {
	NSURL *_bundlePath;
	NSArray<NSString *> *_possibleIdentifiers;
	Class<MZEModuleProviderDelegate> _provider;
}
@property (nonatomic, retain, readwrite) NSArray<NSString *> *possibleIdentifiers;
@property (nonatomic, assign) Class<MZEModuleProviderDelegate> provider;
- (id)initWithBundlePath:(NSURL *)bundlePath;
- (NSDictionary *)infoDictionaryForIdentifier:(NSString *)identifier;
@end