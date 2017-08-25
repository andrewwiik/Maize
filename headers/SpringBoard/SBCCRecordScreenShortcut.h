@interface SBCCRecordScreenShortcut : NSObject
+(BOOL)isSupported:(int)capability;
+(BOOL)enabledByDefault;
-(void)_startRecording;
-(void)deactivate;
-(void)activate;
-(void)_stopRecording;
@end