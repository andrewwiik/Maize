

@interface CCUIRecordScreenShortcut : NSObject
// + (BOOL)isSupported:(int)arg1;
+ (id)alloc;
- (void)_startRecording;
- (void)_stopRecording;
- (BOOL)_toggleState;
@end