#import <MaizeServices/MZEModuleRepository.h>
#import <MaizeServices/MZEModuleMetadata.h>
#import "MZEModuleInstance.h"

@interface MZEModuleInstanceManager : NSObject {
	MZEModuleRepository *_repository;
}
@property(copy, nonatomic) NSSet *enabledModuleIdentifiers;
@property (nonatomic, retain, readwrite) MZEModuleRepository *repository;
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, MZEModuleInstance *> *moduleInstancesByIdentifier;
@property (readonly, nonatomic) NSArray *moduleInstances;
+ (instancetype)sharedInstance;
- (id)initWithRepository:(MZEModuleRepository *)repository;
- (MZEModuleInstance *)_instantiateModuleWithMetadata:(MZEModuleMetadata *)metadata;
- (void)_loadModuleInstances;
@end
