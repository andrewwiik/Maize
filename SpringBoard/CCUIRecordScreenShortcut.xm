@interface RPScreenRecorder : NSObject
+ (instancetype)sharedRecorder;
- (BOOL)isRecording;
- (void)_startRecordingWithMicrophoneEnabled:(bool)arg1 cameraEnabled:(bool)arg2 streamingEnabled:(bool)arg3 handler:(id /* block */)arg4;
- (void)startRecordingWithMicrophoneEnabled:(BOOL)arg1 windowToRecord:(id)arg2 systemRecording:(BOOL)arg3 handler:(id /* block */)arg4;
@end

@interface CCUIRecordScreenShortcut : NSObject
- (void)_startRecording;
- (void)_stopRecording;
@end



%hook CCUIRecordScreenShortcut
- (void)_toggleState {
	if ([[NSClassFromString(@"RPScreenRecorder") sharedRecorder] isRecording]) {
		[self _stopRecording];
	} else {
		[self _startRecording];
	}
	return;
}
%end