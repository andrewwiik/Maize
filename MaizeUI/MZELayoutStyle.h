@interface MZELayoutStyle : NSObject
@property (nonatomic, assign) CGFloat columns;
@property (nonatomic, assign) CGFloat rows;
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat moduleSize;
- (id)initWithSize:(CGSize)size;
@end