//
//  GeneticAlgorithmFactory2D.m
//  BinPackingProject
//
//  Created by Ugljesa Erceg on 5/21/12.
//  Open Source project
//

#import "GeneticAlgorithmFactory2D.h"

@implementation GeneticAlgorithmFactory2D
{
    @private float storageWidth;
    @private float storageHeight;
    @private float usedStorage;
    @private float bestShelvesUsage;
    @private float usedStorageHeight;
    @private float usedStorageHeightPercent;
    
    @private NSUInteger elitismFactor;
    @private NSUInteger numberOfRectanglesInUnit;
    @private NSUInteger numberOfUnitsInGeneration;
    
    @private NSUInteger lowestCost;
    
    @private NSMutableArray *rectangles;
    @private NSMutableArray *rectanglesElite;
    @private NSMutableArray *dummyRectangles;
    @private NSMutableArray *newGeneration;
    @private NSMutableArray *currentGeneration;
    @private NSMutableArray *currentGenerationCost;
}

@synthesize lowestCost, usedStorage, usedStorageHeight, usedStorageHeightPercent, bestShelvesUsage;

// INIT: Custom initializator
- (id) initWithNumberOfUnitsInGeneration:(NSUInteger)numberOfUnits 
                         rectanglesArray:(NSMutableArray *)rectanglesArray
                           elitismFactor:(NSUInteger)elitism 
                            storageWidth:(float)width 
                           storageHeight:(float)height
{
    if (self = [super init]) 
    {
        self->lowestCost = INT_MAX;
        self->elitismFactor = elitism;
        self->storageWidth = width;
        self->storageHeight = height;
        self->bestShelvesUsage = (float)INT_MAX;
        
        // Save original array of items
        self->rectangles = [NSMutableArray new];
        [self->rectangles addObjectsFromArray:rectanglesArray];
        
        self->newGeneration = [NSMutableArray array];
        self->currentGeneration = [NSMutableArray array];
        self->currentGenerationCost = [NSMutableArray new];
        self->rectanglesElite = [NSMutableArray array];
        
        // Initialize GA fields
        self->numberOfRectanglesInUnit = [self->rectangles count];
        self->numberOfUnitsInGeneration = numberOfUnits;
        
        self->dummyRectangles = [NSMutableArray new];
        for (NSUInteger i = 0; i < self->numberOfRectanglesInUnit; i++)
        {
            [self->dummyRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]];
        }
    }
    
    return self;
}

// PUBLIC: Generate initial population of units
- (void) generateInitialPopulation
{
    // Generate numberOfUnitsInGeneration units in to start algorithm
    for (NSUInteger i = 0; i < self->numberOfUnitsInGeneration; i++)
    {
        [self shuffleRectangles];
        
        NSMutableArray *newUnit = [NSMutableArray new];
        [newUnit addObjectsFromArray:self->rectangles];
        
        [self->currentGeneration addObject:newUnit];
    }
}

// PUBLIC: Method where selection + crossing is done
- (void) mate:(NSUInteger)crossingPointsNumber
{
    // Place elite units in new generation
    [self->newGeneration removeAllObjects];
    
    for (NSNumber *eliteUnit in self->rectanglesElite)
    {
        [self->newGeneration addObject:eliteUnit];
    }
    
    // 2 parents make 1 new unit
    for (NSUInteger i = 0; i < (self->numberOfUnitsInGeneration - self->elitismFactor); i++)
    {
        NSUInteger parentIndexOne;
        NSUInteger parentIndexTwo;
        
        do
        {
            parentIndexOne = arc4random_uniform(self->numberOfUnitsInGeneration);
            parentIndexTwo = arc4random_uniform(self->numberOfUnitsInGeneration);
            
        } while (parentIndexOne == parentIndexTwo);
        
        // At this point we have chosen 2 different parents
        // Now we should do the crossover
        
        NSInteger randomIndexes[[self->rectangles count]];
        
        for (NSUInteger i = 0; i < [self->rectangles count]; i++)
        {
            randomIndexes[i] = i;
        }
        
        NSUInteger maximum = [self->rectangles count] - 1;
        
        // Randomize index positions
        do
        {
            NSUInteger randomPosition = arc4random_uniform(maximum);
            NSInteger temp;
            
            temp = randomIndexes[maximum];
            randomIndexes[maximum] = randomIndexes[randomPosition];
            randomIndexes[randomPosition] = temp;
            
            maximum -= 1;
        } while (maximum != -1);
        
        // At this point we have indexes, we should now mix parents to create child
        NSMutableArray *parentOne = [NSMutableArray new];
        NSMutableArray *parentTwo = [NSMutableArray new];
        
        [parentOne addObjectsFromArray:[self->currentGeneration objectAtIndex:parentIndexOne]];
        [parentTwo addObjectsFromArray:[self->currentGeneration objectAtIndex:parentIndexTwo]];
        
        // Initialize child array with dummy values, since all need to be REPLACED
        NSUInteger parentChoice = arc4random_uniform(2);
        NSMutableArray *child = [NSMutableArray new];
        [child addObjectsFromArray:self->dummyRectangles];
        
        if (parentChoice == 0)
        {
            // Items will be taken from second parent            
            for (NSUInteger i = 0; i < crossingPointsNumber; i++)
            {
                [child replaceObjectAtIndex:randomIndexes[i] withObject:[parentOne objectAtIndex:randomIndexes[i]]];
            }
            
            // Fill the rest of the fields with remaining items from parent two
            // In sequential order from left to right
            NSUInteger remainedIndexes[self->numberOfRectanglesInUnit - crossingPointsNumber];
            NSUInteger remainedIndexesCount = 0;
            
            // Determine remained unfilled indexes
            for (NSUInteger j = 0; j < self->numberOfRectanglesInUnit; j++)
            {
                BOOL indexContained = NO;
                
                for (NSUInteger k = 0; k < crossingPointsNumber; k++)
                {
                    if (j == randomIndexes[k])
                    {
                        indexContained = YES;
                        break;
                    }
                }
                
                if (NO == indexContained)
                {
                    remainedIndexes[remainedIndexesCount] = j;
                    remainedIndexesCount += 1;
                }
            }
            
            // Determine unfilled items
            NSMutableArray *remainedRectangles = [NSMutableArray new];
            [remainedRectangles addObjectsFromArray:parentTwo];
            
            // Determine items which should be removed and which are taken from firstly selected parent
            NSMutableArray *rectanglesToRemoveFromRemained = [NSMutableArray new];
            
            for (NSUInteger j = 0; j < crossingPointsNumber; j++)
            {
                [rectanglesToRemoveFromRemained addObject:[parentOne objectAtIndex:randomIndexes[j]]];
            }
            
            // Remove those items from secondly selected parent
            for (NSValue *wrappedRectangle in rectanglesToRemoveFromRemained)
            {
                NSUInteger j;
                
                for (j = 0; j < [remainedRectangles count]; j++)
                {
                    if (YES == [wrappedRectangle isEqualToValue:[remainedRectangles objectAtIndex:j]])
                    {
                        break;
                    }
                }
                
                [remainedRectangles removeObjectAtIndex:j];
            }
            
            // Now place unfilled items to unfilled indexes in child
            for (NSInteger j = 0; j < [remainedRectangles count]; j++)
            {
                [child replaceObjectAtIndex:remainedIndexes[j] withObject:[remainedRectangles objectAtIndex:j]];
            }
        }
        else
        {
            // Items will be taken from second parent            
            for (NSUInteger i = 0; i < crossingPointsNumber; i++)
            {
                [child replaceObjectAtIndex:randomIndexes[i] withObject:[parentTwo objectAtIndex:randomIndexes[i]]];
            }
            
            // Fill the rest of the fields with remaining items from parent two
            // In sequential order from left to right
            NSUInteger remainedIndexes[self->numberOfRectanglesInUnit - crossingPointsNumber];
            NSUInteger remainedIndexesCount = 0;
            
            // Determine remained unfilled indexes
            for (NSUInteger j = 0; j < self->numberOfRectanglesInUnit; j++)
            {
                BOOL indexContained = NO;
                
                for (NSUInteger k = 0; k < crossingPointsNumber; k++)
                {
                    if (j == randomIndexes[k])
                    {
                        indexContained = YES;
                        break;
                    }
                }
                
                if (NO == indexContained)
                {
                    remainedIndexes[remainedIndexesCount] = j;
                    remainedIndexesCount += 1;
                }
            }
            
            // Determine unfilled items
            NSMutableArray *remainedRectangles = [NSMutableArray new];
            [remainedRectangles addObjectsFromArray:parentOne];
            
            // Determine items which should be removed and which are taken from firstly selected parent
            NSMutableArray *rectanglesToRemoveFromRemained = [NSMutableArray new];
            
            for (NSUInteger j = 0; j < crossingPointsNumber; j++)
            {
                [rectanglesToRemoveFromRemained addObject:[parentTwo objectAtIndex:randomIndexes[j]]];
            }
            
            // Remove those items from secondly selected parent
            for (NSValue *wrappedRectangle in rectanglesToRemoveFromRemained)
            {
                NSUInteger j;
                
                for (j = 0; j < [remainedRectangles count]; j++)
                {
                    if (YES == [wrappedRectangle isEqualToValue:[remainedRectangles objectAtIndex:j]])
                    {
                        break;
                    }
                }
                
                [remainedRectangles removeObjectAtIndex:j];
            }
            
            // Now place unfilled items to unfilled indexes in child
            for (NSInteger j = 0; j < [remainedRectangles count]; j++)
            {
                [child replaceObjectAtIndex:remainedIndexes[j] withObject:[remainedRectangles objectAtIndex:j]];
            }
        }
        
        // At this moment we have child and we will add it to next generation
        [self->newGeneration addObject:child];
    }
}


// PUBLIC: Method which mutates unit with certain percentage of probability
- (void) mutate:(NSUInteger)mutationFactorPercentage
{
    NSMutableArray *newGenerationHelp = [NSMutableArray arrayWithArray:self->newGeneration];
    [self->newGeneration removeAllObjects];
    
    for (NSMutableArray *unit in newGenerationHelp)
    {
        NSUInteger randomNumber = arc4random_uniform(100);
        
        if (randomNumber < mutationFactorPercentage)
        {
            // Do the mutation
            NSUInteger randomIndexOne;
            NSUInteger randomIndexTwo;
            NSUInteger mutateLoopLimit = self->numberOfRectanglesInUnit * 0.2f;
            
            for (NSUInteger i = 0; i < mutateLoopLimit; i++)
            {
                do
                {
                    randomIndexOne = arc4random_uniform(self->numberOfRectanglesInUnit);
                    randomIndexTwo = arc4random_uniform(self->numberOfRectanglesInUnit);
                    
                } while (randomIndexOne == randomIndexTwo);
                
                NSValue *firstRectangle = [unit objectAtIndex:(NSUInteger)randomIndexOne];
                NSValue *secondRectangle = [unit objectAtIndex:(NSUInteger)randomIndexTwo];
                
                [unit replaceObjectAtIndex:(NSUInteger)randomIndexOne withObject:secondRectangle];
                [unit replaceObjectAtIndex:(NSUInteger)randomIndexTwo withObject:firstRectangle];
            }
        }
        
        [self->newGeneration addObject:unit];
    }

}

// PUBLIC: Method which swaps newly created generation to become current generation
- (void) generationSwap
{
    [self->currentGeneration removeAllObjects];
    [self->currentGeneration addObjectsFromArray:self->newGeneration];
    [self->newGeneration removeAllObjects];
}

// PUBLIC: Method which calculates cost per each unit in generation based on fitness function
- (void) calculateGenerationCostForFitnessFunction1:(NSUInteger (^) (NSMutableArray *))ffunction1 
                                   fitnessFunction2:(NSUInteger (^) (NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *))ffunction2
{
    [self->rectanglesElite removeAllObjects];
    [self->currentGenerationCost removeAllObjects];
    
    // Run fitness function on all items and calculate cost for each item
    for (NSMutableArray *rectangleArray in self->currentGeneration)
    {
        NSUInteger unitCost = ffunction1(rectangleArray);
        
        [self->currentGenerationCost addObject:[NSNumber numberWithInt:unitCost]];
    }
    
    // Find out which units are elite one and save them
    NSMutableArray *specArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [self->currentGenerationCost count]; i++)
    {
        [specArray addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:[[self->currentGenerationCost objectAtIndex:i] floatValue]], [NSNumber numberWithInteger:i], nil]];
    }
    
    NSArray *sortedArray = [specArray sortedArrayUsingFunction:customCompareFunction2D context:NULL];
    
    for (NSUInteger i = 0; i < self->elitismFactor; i++)
    {
        [self->rectanglesElite addObject:[self->currentGeneration objectAtIndex:[[[sortedArray objectAtIndex:i] objectAtIndex:1] intValue]]];
    }
    
    // Save the best one for printing purpose (best ones are in elite units)
    for (NSUInteger i = 0; i < [self->rectanglesElite count]; i++)
    {
        NSMutableArray *eliteUnit = [NSMutableArray arrayWithArray:[self->rectanglesElite objectAtIndex:i]];
        NSMutableArray *eliteUnitShelvesHeight = [NSMutableArray new];
        NSMutableArray *eliteUnitCurrentlyUsedShelfWidth = [NSMutableArray new];
        NSMutableArray *eliteUnitCurrentlyUsedShelfArea = [NSMutableArray new];
        
        NSUInteger shelfNumber = ffunction2(eliteUnit, eliteUnitCurrentlyUsedShelfWidth, eliteUnitShelvesHeight, eliteUnitCurrentlyUsedShelfArea);
        
        float currentShelvesUsage = [self shelvesWidthUsagePercentage:eliteUnitShelvesHeight 
                                                 currentlyUsedArea:eliteUnitCurrentlyUsedShelfArea];
        
        if (self->bestShelvesUsage > currentShelvesUsage)
        {
            self->bestShelvesUsage = currentShelvesUsage;
            
            if (self->lowestCost >= shelfNumber)
            {
                [self updateUsageParametersIfNeeded:eliteUnit
                             eliteUnitShelvesHeight:eliteUnitShelvesHeight];
            }
        }
    }
    
    // Update lowest cost (least number of used shelves in this case) if neccessary
    if (self->lowestCost > [[[sortedArray objectAtIndex:0] objectAtIndex:0] floatValue])
    {
        self->lowestCost = [[[sortedArray objectAtIndex:0] objectAtIndex:0] floatValue];
    }
}

// PRIVATE: Update fields which are public in this class for being able to print them outside
- (void) updateUsageParametersIfNeeded:(NSMutableArray *)eliteUnit
                eliteUnitShelvesHeight:(NSMutableArray *)eliteUnitShelvesHeight
{
    float storageUsedArea = 0.0f;
    float storageUsedHeight = 0.0f;
    float storageArea = self->storageWidth * self->storageHeight;
    
    // Calculate actual area used by added rectangles
    for (NSValue *wrappedRectangle in eliteUnit)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        storageUsedArea += rectangle.size.width * rectangle.size.height;
    }
    
    // Calculate storage used height
    for (NSNumber *height in eliteUnitShelvesHeight)
    {
        storageUsedHeight += [height floatValue];
    }
    
    // Update publicly exposed fields from this class
    self->usedStorage = storageUsedArea / storageArea * 100.0f;
    self->usedStorageHeight = storageUsedHeight;
    self->usedStorageHeightPercent = storageUsedHeight / self->storageHeight * 100.0f;
}

// PRIVATE: Calculate current shelves width usage in % in order to help
//          detail search algorithm to locate the best rectangle combination
- (float) shelvesWidthUsagePercentage:(NSMutableArray *)shelvesHeight 
                   currentlyUsedArea:(NSMutableArray *)currentlyUsedShelfArea
{
    float usedShelvesArea = 0.0f;
    float totalShelvesArea = 0.0f;
    
    for (NSNumber *height in shelvesHeight)
    {
        totalShelvesArea += [height floatValue] * self->storageWidth;
    }
    
    // Calculate total used width on all shelves
    for (NSNumber *usedArea in currentlyUsedShelfArea)
    {
        usedShelvesArea += [usedArea floatValue];
    }
    
    return (totalShelvesArea - usedShelvesArea);
}

// PRIVATE: Sorting method
NSComparisonResult customCompareFunction2D(NSArray* first, NSArray* second, void* context)
{
    id firstValue = [first objectAtIndex:0];
    id secondValue = [second objectAtIndex:0];
    return [firstValue compare:secondValue];
}

// PRIVATE: Method for calculating lowest cost unit and remembering its number of used bins and its index in item array
- (void) locateLowestCostItem
{
    NSUInteger currentItemCost;
    
    for (NSNumber *cost in self->currentGenerationCost)
    {
        currentItemCost = [cost intValue];
        
        if (currentItemCost < self->lowestCost)
        {
            self->lowestCost = currentItemCost;
        }
    }
}

// PRIVATE: Shuffle items in array in order to generate new combination of items
- (void) shuffleRectangles
{    
    NSUInteger count = [self->rectangles count];
    
    for (NSUInteger i = 0; i < count; ++i) 
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        
        // Do the shuffle
        [self->rectangles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}


@end
