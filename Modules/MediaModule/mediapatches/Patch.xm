@interface MPUTransportControlsView : UIView
@end

%hook MPUTransportControlsView
-(void)layoutSubviews{
	%orig;
}
-(void)setFrame:(CGRect)frame {
    if(self.tag == 987654321){
      frame = CGRectMake(self.superview.frame.size.width/12,0,self.superview.frame.size.width - self.superview.frame.size.width/6, self.superview.frame.size.height);
    }

  %orig(frame);
}
%end
