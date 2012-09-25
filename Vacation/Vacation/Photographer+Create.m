//
//  Photographer+Create.m
//  Vacation
//
//  Created by Erben Mo on 24/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context {
    Photographer* photographer = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray* matches = [context executeFetchRequest:request error:nil];
    
    if(!matches || [matches count] > 1) {
        NSLog(@"error");
    } else if([matches count] == 0) {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        photographer.name = name;
    } else {
        photographer = [matches lastObject];
    }
    
    return photographer;
}

@end
