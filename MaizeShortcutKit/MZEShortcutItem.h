typedef void (^MZEShortcutItemBlock)(void);


@interface MZEShortcutItem {
	UIImage *_image;
	NSString *_title;
	NSString *_subtitle;
	MZEShortcutItemBlock _block;
}

@property (nonatomic, retain, readwrite) UIImage *image;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *subtitle;
@property (readwrite, copy, nonatomic) MZEShortcutItemBlock block;
@end