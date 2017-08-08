

@interface CCUIRecordScreenShortcut : NSObject
+ (id)alloc;
- (void)_startRecording;
- (void)_stopRecording;
- (BOOL)_toggleState;
@end