
/*

Primary is the Album Name and First in Compact
Secondary is Artist - Song Name and second in compact
Title is name of currently playin device and first in compact

s

*/

#import <MPUFoundation/MPUMarqueeView.h>


@interface MZEMusicModuleHeaderView : UIView
@property(retain, nonatomic, readwrite) NSString *primaryString; // @synthesize primaryString=_primaryString;
@property(retain, nonatomic, readwrite) UILabel *primaryLabel; // @synthesize primaryLabel=_primaryLabel;
@property(retain, nonatomic, readwrite) MPUMarqueeView *primaryMarqueeView; // @synthesize primaryMarqueeView=_primaryMarqueeView;

@property(retain, nonatomic, readwrite) NSString *secondaryString; // @synthesize secondaryString=_secondaryString;
@property(retain, nonatomic, readwrite) UILabel *secondaryLabel; // @synthesize secondaryLabel=_secondaryLabel;
@property(retain, nonatomic, readwrite) MPUMarqueeView *secondaryMarqueeView; // @synthesize secondaryMarqueeView=_secondaryMarqueeView;

@property(retain, nonatomic, readwrite) NSString *titleString; // @synthesize titleString=_titleString;
@property(retain, nonatomic, readwrite) UILabel *titleLabel; // @synthesize titleLabel=_titleLabel;
@property(retain, nonatomic, readwrite) MPUMarqueeView *titleMarqueeView; // @synthesize titleMarqueeView=_titleMarqueeView;
@end