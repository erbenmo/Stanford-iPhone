//
//  Vacation+Create.m
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Vacation+Create.h"
#import "Place+Create.h"

@implementation Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)vacationId
        inManagedObjectContext:(NSManagedObjectContext *)context
                  andPlacesIds:(NSSet *)places {
    Vacation* vacation;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate = [NSPredicate predicateWithFormat:@"vacationId = %@", vacationId];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"vacationId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray* matches = [context executeFetchRequest:request error:nil];
    
    if(!matches || [matches count] > 1) {
        NSLog(@"error");
    } else if([matches count] == 0) {
        vacation = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation" inManagedObjectContext:context];
        vacation.vacationId = vacationId;

        for (NSString* placeId in places) {
            Place* place = [Place placeWithId:placeId inManagedObjectContext:context];
            [vacation addPlacesObject:place];
        }
    } else {
        vacation = [matches lastObject];
    }
    
    return vacation;
}
@end
