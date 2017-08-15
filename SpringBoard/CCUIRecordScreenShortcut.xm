#import <objc/runtime.h>
#import <dlfcn.h>


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



%hook RecordScreenShortcutClass
- (void)_toggleState {
	if ([[NSClassFromString(@"RPScreenRecorder") sharedRecorder] isRecording]) {
		[(CCUIRecordScreenShortcut *)self _stopRecording];
	} else {
		[(CCUIRecordScreenShortcut *)self _startRecording];
	}
	return;
}
%end

%ctor {

	dlopen("/System/Library/Frameworks/ReplayKit.framework/ReplayKit", RTLD_NOW);

	NSString *recordShortcutClass;
	if (NSClassFromString(@"CCUIRecordScreenShortcut"))
		recordShortcutClass = @"CCUIRecordScreenShortcut";
	else
		recordShortcutClass = @"SBCCRecordScreenShortcut";
	%init(RecordScreenShortcutClass=NSClassFromString(recordShortcutClass));
}