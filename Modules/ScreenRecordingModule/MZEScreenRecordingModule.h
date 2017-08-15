#import <MaizeUI/MZEAnimatedFlipSwitchToggleModule.h>
#import <ControlCenterUI/CCUIRecordScreenShortcut.h>


@interface RPScreenRecorder : NSObject
+ (instancetype)sharedRecorder;
- (BOOL)isRecording;
// - (void)_startRecordingWithMicrophoneEnabled:(bool)arg1 cameraEnabled:(bool)arg2 streamingEnabled:(bool)arg3 handler:(id /* block */)arg4;
// - (void)startRecordingWithMicrophoneEnabled:(BOOL)arg1 windowToRecord:(id)arg2 systemRecording:(BOOL)arg3 handler:(id /* block */)arg4;

@end

@interface MZEScreenRecordingModule : MZEAnimatedFlipSwitchToggleModule {
	NSString *_temporaryGlyphState;
	BOOL _countingDown;
	BOOL _isRecording;
}

@property (nonatomic, retain) NSTimer *countDownTimer;
@property (nonatomic, retain) CCUIRecordScreenShortcut *recordToggle;
- (id)init;
- (CAPackage *)glyphPackage;
- (NSString *)glyphState;
@end