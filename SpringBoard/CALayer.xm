%hook CALayer
+ (BOOL)needsDisplayForKey:(NSString *)key {
	if ([key isEqual:@"cornerContentsCenter"] || [key isEqual:@"cornerContents"]) {
		return YES;
	} else return %orig;
}
%end