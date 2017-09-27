#import <Preferences/PSListController.h>
#import <MaizeServices/MZEModuleRepository.h>

@interface MZERootListController : UITableViewController {
	MZEModuleRepository *_moduleRepository;
}

@property (nonatomic, retain, readwrite) MZEModuleRepository *moduleRepository;
@property (nonatomic, retain) NSString *enabledKey;
@property (nonatomic, retain) NSString *disabledKey;
@property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain) NSArray *allIdentifiers;
@property (nonatomic, retain) NSString *settingsFilePath;
@property (nonatomic, retain) NSString *preferencesIdentifier;
@property (nonatomic, retain) NSString *notificationName;
- (NSArray *)arrayForSection:(NSInteger)section;
- (void)_flushSettings;
- (void)setRootController:(id)rootController;

@end