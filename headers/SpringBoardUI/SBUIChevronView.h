@interface SBUIChevronView : UIView
@property (assign,nonatomic) CGFloat animationDuration; 
@property (assign,nonatomic) NSInteger state;                                
@property (nonatomic,retain) UIColor * color;
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
-(UIColor *)color;
-(void)setColor:(UIColor *)color;
-(void)setBackgroundView:(UIView *)backgroundView;
-(id)initWithColor:(UIColor *)color;
-(CGFloat)animationDuration;
-(BOOL)_setState:(NSInteger)state;
-(BOOL)_setUnified:(BOOL)unified;
-(void)configureForLightStyle;
-(void)setState:(NSInteger)state animated:(BOOL)animated;
@end