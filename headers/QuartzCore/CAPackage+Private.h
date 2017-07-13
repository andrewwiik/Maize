extern NSString* const kCAPackageTypeCAMLBundle;

@interface CAPackage : NSObject

@property (readonly) CALayer * rootLayer; 
@property (getter=isGeometryFlipped,readonly) BOOL geometryFlipped; 
+(id)packageWithData:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
+(id)packageWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
-(Class)CAMLParser:(id)arg1 didFailToFindClassWithName:(id)arg2 ;
-(id)CAMLParser:(id)arg1 resourceForURL:(id)arg2 ;
-(void)CAMLParser:(id)arg1 didLoadResource:(id)arg2 fromURL:(id)arg3 ;
-(id)_initWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
-(id)_initWithData:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
-(void)_readFromCAMLURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
-(void)_readFromArchiveData:(id)arg1 options:(id)arg2 error:(id*)arg3 ;
-(void)_readFromCAMLData:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
-(id)substitutedClasses;
-(void)_addClassSubstitutions:(id)arg1 ;
-(void)dealloc;
-(CALayer *)rootLayer;
-(void)foreachLayer:(/*^block*/id)arg1 ;
-(BOOL)isGeometryFlipped;
-(id)publishedObjectWithName:(id)arg1 ;
-(id)publishedObjectNames;
-(Class)unarchiver:(id)arg1 cannotDecodeObjectOfClassName:(id)arg2 originalClasses:(id)arg3 ;
-(id)unarchiver:(id)arg1 didDecodeObject:(id)arg2 ;
@end