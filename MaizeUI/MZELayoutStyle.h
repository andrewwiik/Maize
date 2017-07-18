@interface MZELayoutStyle : NSObject
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat moduleSize;
- (id)initWithSize:(CGSize)size;
@end