@interface SBCCRecordScreenShortcut : NSObject
+(BOOL)isSupported:(int)arg1;
+(BOOL)enabledByDefault;
-(void)_startRecording;
-(void)deactivate;
-(void)activate;
-(void)_stopRecording;
@end