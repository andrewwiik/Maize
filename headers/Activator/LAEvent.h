#import "LAActivatorVersion.h"

// Events represent an assignable gesture that has or could occurred

@interface LAEvent : NSObject<NSCoding> LA_PRIVATE_IVARS(LAEvent)

+ (id)eventWithName:(NSString *)name;
+ (id)eventWithName:(NSString *)name mode:(NSString *)mode;
- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name mode:(NSString *)mode;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *mode;
@property (nonatomic, getter=isHandled) BOOL handled;
@property (nonatomic, copy) NSDictionary *userInfo;

@end 
