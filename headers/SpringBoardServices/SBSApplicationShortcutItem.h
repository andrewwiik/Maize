#import "SBSApplicationShortcutIcon.h"

@interface SBSApplicationShortcutItem : NSObject <NSCopying> {

	NSString* _type;
	NSString* _localizedTitle;
	NSString* _localizedSubtitle;
	SBSApplicationShortcutIcon* _icon;
	NSUInteger _activationMode;
	NSString* _bundleIdentifierToLaunch;
	NSData* _userInfoData;

}

@property (nonatomic,retain) NSData * userInfoData;                          //@synthesize userInfoData=_userInfoData - In the implementation block
@property (nonatomic,copy) NSString * type;                                  //@synthesize type=_type - In the implementation block
@property (nonatomic,copy) NSString * localizedTitle;                        //@synthesize localizedTitle=_localizedTitle - In the implementation block
@property (nonatomic,copy) NSString * localizedSubtitle;                     //@synthesize localizedSubtitle=_localizedSubtitle - In the implementation block
@property (nonatomic,copy) SBSApplicationShortcutIcon * icon;                //@synthesize icon=_icon - In the implementation block
@property (nonatomic,copy) NSDictionary * userInfo; 
@property (assign,nonatomic) NSUInteger activationMode;              //@synthesize activationMode=_activationMode - In the implementation block
@property (nonatomic,copy) NSString * bundleIdentifierToLaunch;              //@synthesize bundleIdentifierToLaunch=_bundleIdentifierToLaunch - In the implementation block
+(id)staticShortcutItemWithDictionary:(id)arg1 localizationHandler:(/*^block*/id)arg2 ;
-(void)setBundleIdentifierToLaunch:(NSString *)arg1 ;
-(NSDictionary *)userInfo;
-(void)setType:(NSString *)arg1 ;
-(NSString *)type;
-(id)copyWithZone:(NSZone*)arg1 ;
-(NSUInteger)activationMode;
-(void)setActivationMode:(NSUInteger)arg1 ;
-(void)setUserInfo:(NSDictionary *)arg1 ;
-(void)setIcon:(SBSApplicationShortcutIcon *)arg1 ;
-(id)initWithXPCDictionary:(id)arg1 ;
-(void)encodeWithXPCDictionary:(id)arg1 ;
-(SBSApplicationShortcutIcon *)icon;
-(NSString *)localizedTitle;
-(NSString *)localizedSubtitle;
-(NSData *)userInfoData;
-(void)setLocalizedTitle:(NSString *)arg1 ;
-(void)setLocalizedSubtitle:(NSString *)arg1 ;
-(void)setUserInfoData:(NSData *)arg1 ;
-(NSString *)bundleIdentifierToLaunch;
@end
