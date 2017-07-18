#import <MaizeServices/MZEModuleMetadata.h>
#import "MZEContentModule-Protocol.h"

@interface MZEModuleInstance : NSObject {
    MZEModuleMetadata *_metadata;
    id <MZEContentModule> _module;
}
@property(readonly, nonatomic) id <MZEContentModule> module; // @synthesize module=_module;
@property(readonly, nonatomic) MZEModuleMetadata *metadata; // @synthesize metadata=_metadata;
- (id)initWithMetadata:(MZEModuleMetadata *)metadata module:(id<MZEContentModule>)module;
@end