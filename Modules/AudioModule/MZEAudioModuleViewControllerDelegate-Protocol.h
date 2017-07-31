
@class MZEAudioModuleViewController;

@protocol MZEAudioModuleViewControllerDelegate <NSObject>
- (void)audioModuleViewController:(MZEAudioModuleViewController *)moduleViewController volumeDidChange:(float)volume;
@end

