@interface SBUIAction : NSObject {

	NSString *_title;
	NSString *_subtitle;
	UIImage *_image;
	UIView *_badgeView;
	id _handler;

}

@property (nonatomic,copy,readonly) NSString * title;
@property (nonatomic,copy,readonly) NSString * subtitle;
@property (nonatomic,readonly) UIImage * image;
@property (nonatomic,readonly) UIView * badgeView;
@property (nonatomic,copy,readonly) id handler;
-(id)init;
-(NSString *)title;
-(UIImage *)image;
-(UIView *)badgeView;
-(NSString *)subtitle;
-(void(^)(void))handler;
-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image badgeView:(UIView *)badgeView handler:(void(^)(void))handler;
-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image handler:(void(^)(void))handler;
-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle handler:(void(^)(void))handler;
-(id)initWithTitle:(NSString *)title handler:(void(^)(void))handler;
@end