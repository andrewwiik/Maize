@interface CAState : NSObject <NSCoding, NSCopying> {

	NSString* _name;
	NSString* _basedOn;
	NSMutableArray* _elements;
	double _nextDelay;
	double _previousDelay;
	BOOL _enabled;
	BOOL _locked;
	BOOL _initial;

}

@property (nonatomic,copy) NSString * name;                            //@synthesize name=_name - In the implementation block
@property (copy) NSString * basedOn;                                   //@synthesize basedOn=_basedOn - In the implementation block
@property (getter=isEnabled) BOOL enabled;                             //@synthesize enabled=_enabled - In the implementation block
@property (nonatomic,copy) NSArray * elements; 
@property (assign) double nextDelay;                                   //@synthesize nextDelay=_nextDelay - In the implementation block
@property (assign) double previousDelay;                               //@synthesize previousDelay=_previousDelay - In the implementation block
@property (assign,getter=isLocked,nonatomic) BOOL locked;              //@synthesize locked=_locked - In the implementation block
@property (getter=isInitial) BOOL initial;                             //@synthesize initial=_initial - In the implementation block
+(void)CAMLParserStartElement:(id)arg1 ;
-(void)CAMLParser:(id)arg1 setValue:(id)arg2 forKey:(id)arg3 ;
-(id)CAMLTypeForKey:(id)arg1 ;
-(void)encodeWithCAMLWriter:(id)arg1 ;
-(void)removeElement:(id)arg1 ;
-(NSString *)basedOn;
-(void)setBasedOn:(NSString *)arg1 ;
-(double)nextDelay;
-(void)setNextDelay:(double)arg1 ;
-(double)previousDelay;
-(void)setPreviousDelay:(double)arg1 ;
-(BOOL)isInitial;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(void)dealloc;
-(id)debugDescription;
-(void)setName:(NSString *)arg1 ;
-(NSString *)name;
-(NSArray *)elements;
-(BOOL)isLocked;
-(void)setEnabled:(BOOL)arg1 ;
-(BOOL)isEnabled;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setLocked:(BOOL)arg1 ;
-(void)setElements:(NSArray *)arg1 ;
-(void)foreachLayer:(/*^block*/id)arg1 ;
-(void)setInitial:(BOOL)arg1 ;
-(void)addElement:(id)arg1 ;
@end