@protocol MZEContentModule;

@protocol MZEModuleProviderDelegate <NSObject>
@required
+ (NSArray<NSString *> *)possibleIdentifiers;
+ (id<MZEContentModule>)moduleForIdentifier:(NSString *)identifier;
+ (UIImage *)glyphForIdentifier:(NSString *)identifier;
+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier;
+ (NSInteger)rowsForIdentifier:(NSString *)identifier;
+ (NSInteger)columnsForIdentifier:(NSString *)identifier;
@end