//
//  BinPackingFactory2D.h
//  BinPackingProject
//
//  Created by Ugljesa Erceg on 5/18/12.
//  Open Source project
//

#import <Foundation/Foundation.h>

@interface BinPackingFactory2D : NSObject

// Property used only for info display purposes
@property (nonatomic) NSUInteger permutationCount;

- (id) initWithStorageWidth:(float)width 
              storageHeight:(float)height 
       storageHeightLimited:(BOOL)limit;

- (NSUInteger) shelfNextFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfNextFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfFirstFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfFirstFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfBestFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfBestFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfWorstFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) shelfWorstFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) detailSearchAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (NSUInteger) searchWithUsageOfGeneticAlgorithmForRectangles:(NSMutableArray *)bpRectangles
                                    numberOfUnitsInGeneration:(NSUInteger)unitNumber
                                          numberOfGenerations:(NSUInteger)generationsNumber 
                                     mutationFactorPercentage:(NSUInteger)mutationFactor 
                                                elitismFactor:(NSUInteger)elitismFactor 
                                      numberOfCrossoverPoints:(NSUInteger)crossoverPoints 
                                     fitnessFunctionSelection:(NSUInteger)choice;
- (void) bottomLeftAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles;
- (void) showStorageUsageDetails;
- (void) showBottomLeftStorageUsageDetails;

@end
