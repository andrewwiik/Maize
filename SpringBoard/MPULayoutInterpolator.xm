@interface MPULayoutInterpolator : NSObject
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSMutableArray *referenceMetrics;
- (id)init;
-(void)addValue:(CGFloat)arg1 forReferenceMetric:(CGFloat)arg2;
-(void)addValue:(CGFloat)arg1 forReferenceMetric:(CGFloat)arg2 secondaryReferenceMetric:(CGFloat)arg3;
-(CGFloat)valueForReferenceMetric:(CGFloat)arg1 secondaryReferenceMetric:(CGFloat)arg2;
-(CGFloat)valueForReferenceMetric:(CGFloat)arg1;
@end



%subclass MPULayoutInterpolator : NSObject
%property (nonatomic, retain) NSMutableArray *values;
%property (nonatomic, retain) NSMutableArray *referenceMetrics;

- (id)init {
	MPULayoutInterpolator *orig = %orig;
	if (orig) {
		orig.values = [NSMutableArray new];
		orig.referenceMetrics = [NSMutableArray new];
	}
	return orig;

}

-(void)addValue:(CGFloat)arg1 forReferenceMetric:(CGFloat)arg2 {
	[self.values addObject:[NSNumber numberWithFloat:(float)arg1]];
	[self.referenceMetrics addObject:[NSNumber numberWithFloat:(float)arg2]];
}
-(void)addValue:(CGFloat)arg1 forReferenceMetric:(CGFloat)arg2 secondaryReferenceMetric:(CGFloat)arg3 {

}
-(CGFloat)valueForReferenceMetric:(CGFloat)arg1 secondaryReferenceMetric:(CGFloat)arg2 {
	return 0.0f;
}
-(CGFloat)valueForReferenceMetric:(CGFloat)arg1 {

	if ([self.referenceMetrics count] < 1) {
		return 0.0;
	}

	float closestMetric = [(NSNumber *)self.referenceMetrics[0] floatValue];
	int closest = 0;
	for (int x = 1; x < [self.referenceMetrics count]; x++) {
		//CGFloat metric = [(NSNumber *)self.referenceMetrics[x] floatValue];
		float currentDiff = fabsf((float)arg1 - [(NSNumber *)self.referenceMetrics[x] floatValue]);
		if (currentDiff < closestMetric) {
			closestMetric = currentDiff;
			closest = x;
		}
	}

	return (CGFloat)[(NSNumber *)self.values[closest] floatValue];
}
%end


%ctor {
	if (!NSClassFromString(@"MPULayoutInterpolator")) {
		%init;
	}
}