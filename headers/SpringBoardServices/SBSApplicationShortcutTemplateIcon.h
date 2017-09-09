#import "SBSApplicationShortcutIcon.h"

@interface SBSApplicationShortcutTemplateIcon : SBSApplicationShortcutIcon {

	NSString* _templateImageName;

}

@property (nonatomic,readonly) NSString * templateImageName;              //@synthesize templateImageName=_templateImageName - In the implementation block
-(id)_initForSubclass;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)initWithXPCDictionary:(id)arg1 ;
-(void)encodeWithXPCDictionary:(id)arg1 ;
-(id)initWithTemplateImageName:(id)arg1 ;
-(NSString *)templateImageName;
@end