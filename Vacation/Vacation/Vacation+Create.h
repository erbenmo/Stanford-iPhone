//
//  Vacation+Create.h
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Vacation.h"

@interface Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)vacationID
        inManagedObjectContext:(NSManagedObjectContext *)context
                  andPlacesIds:(NSSet*) places;

@end
