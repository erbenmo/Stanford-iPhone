//
//  Tag+Create.m
//  Vacation
//
//  Created by Erben Mo on 24/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context {
    Tag* tag;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray* matches = [context executeFetchRequest:request error:nil];
    
    if(!matches || [matches count] > 1) {
        NSLog(@"error");
    } else if([matches count] == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"   inManagedObjectContext:context];
        tag.name = name;
    } else {
        tag = [matches lastObject];
    }
    
    return tag;
}
@end
