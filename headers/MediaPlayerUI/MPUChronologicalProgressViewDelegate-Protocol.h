@protocol MPUChronologicalProgressViewDelegate
@optional
-(void)progressViewDidBeginScrubbing:(MPUChronologicalProgressView *)progressView;
-(void)progressViewDidEndScrubbing:(MPUChronologicalProgressView *)progressView;
-(void)progressView:(MPUChronologicalProgressView *)progressView didScrubToCurrentTime:(CGFloat)currentTime;

@end