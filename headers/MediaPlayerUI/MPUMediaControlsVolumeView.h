#import <UIKit/UIView.h>
#import <MediaPlayerUI/MPVolumeControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPVolumeController.h>

@interface MPUMediaControlsVolumeView : UIView <MPVolumeControllerDelegate> {

	UIView* _warningView;
	BOOL _warningIndicatorBlinking;
	NSTimer* _warningBlinkTimer;
	NSTimer* _volumeCommitTimer;
	CGFloat _timeStoppedTracking;
	NSInteger _style;
	UISlider* _slider;
	MPVolumeController* _volumeController;

}

@property (nonatomic,readonly) NSInteger style;                                    //@synthesize style=_style - In the implementation block
@property (nonatomic,readonly) UISlider * slider;                                  //@synthesize slider=_slider - In the implementation block
@property (nonatomic,readonly) MPVolumeController * volumeController;              //@synthesize volumeController=_volumeController - In the implementation block
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)size;
-(NSInteger)style;
-(id)initWithStyle:(NSInteger)style;
-(void)_layoutVolumeWarningView;
-(void)_beginBlinkingWarningView;
-(void)_blinkWarningView;
-(void)volumeController:(MPVolumeController *)volumeController volumeValueDidChange:(CGFloat)volume ;
-(void)volumeController:(MPVolumeController *)volumeController volumeWarningStateDidChange:(NSInteger)warningState;
-(void)volumeController:(MPVolumeController *)volumeController EUVolumeLimitDidChange:(CGFloat)volumeLimit;
-(void)volumeController:(MPVolumeController *)volumeController EUVolumeLimitEnforcedDidChange:(BOOL)isEnforced;
-(UIImage *)_trackImageWithAlternateStyle:(BOOL)alternateStyle rounded:(BOOL)rounded;
-(void)updateSystemVolumeLevel;
-(MPVolumeController *)volumeController;
-(UISlider *)_createVolumeSliderView;
-(void)_volumeSliderBeganChanging:(UISlider *)slider;
-(void)_volumeSliderValueChanged:(UISlider *)slider;
-(void)_volumeSliderStoppedChanging:(UISlider *)slider;
-(void)_configureVolumeSliderView:(UISlider *)slider;
-(void)_stopBlinkingWarningView;
-(void)_stopVolumeCommitTimer;
-(BOOL)_shouldStartBlinkingVolumeWarningIndicator;
-(void)_beginVolumeCommitTimer;
-(BOOL)_volumeSliderDynamicsEnabled;
-(void)_removeVolumeSliderInertia;
-(void)_commitCurrentVolumeValue;
-(UIImage *)_warningTrackImage;
-(UISlider *)slider;
@end
