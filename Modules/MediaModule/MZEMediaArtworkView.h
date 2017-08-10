#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@interface MZEMediaArtworkView : UIView
@property (nonatomic, retain, readwrite) UIView *artworkBackground;
@property (nonatomic, retain, readwrite) UIImageView *imageView;
-(void)setImage:(UIImage *)arg1 ;
@end
