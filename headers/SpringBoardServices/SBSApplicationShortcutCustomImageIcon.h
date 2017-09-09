#import "SBSApplicationShortcutIcon.h"

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon {
	BOOL _isTemplate;
	NSData* _imageData;
	NSInteger _dataType;
}

@property (nonatomic,readonly) NSData * imageData;                 //@synthesize imageData=_imageData - In the implementation block
@property (nonatomic,readonly) NSInteger dataType;                 //@synthesize dataType=_dataType - In the implementation block
@property (nonatomic,readonly) BOOL isTemplate;                    //@synthesize isTemplate=_isTemplate - In the implementation block
@property (nonatomic,readonly) NSData * imagePNGData; 
-(id)_initForSubclass;
-(id)initWithImageData:(NSData *)imageData dataType:(NSInteger)datatype;
-(NSData *)imagePNGData;
-(id)initWithXPCDictionary:(id)dictionary;
-(BOOL)isTemplate;
-(void)encodeWithXPCDictionary:(id)dictionary;
-(id)initWithImageData:(NSData *)data dataType:(NSInteger)type isTemplate:(BOOL)isTemplate;
-(id)initWithImagePNGData:(NSData *)data;
-(NSData *)imageData;
-(NSInteger)dataType;
@end