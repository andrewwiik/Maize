#import <SpringBoard/SBControlCenterController+Private.h>

%hook CCUIButtonModule
- (id)controlCenterSystemAgent {
	id orig = %orig;
	if (orig) return orig;
	else return [[NSClassFromString(@"SBControlCenterController") sharedInstance] valueForKey:@"_systemAgent"];
}
%end