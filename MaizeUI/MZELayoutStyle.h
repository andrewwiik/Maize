@interface MZELayoutStyle : NSObject {
	BOOL _isLandscape;
}
@property (nonatomic, assign) CGFloat columns;
@property (nonatomic, assign) CGFloat rows;
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat moduleSize;
@property (nonatomic, assign, readonly, getter=isLandscape) BOOL isLandscape;
- (id)initWithSize:(CGSize)size isLandscape:(BOOL)isLandscape;
- (BOOL)isLandscape;
@end