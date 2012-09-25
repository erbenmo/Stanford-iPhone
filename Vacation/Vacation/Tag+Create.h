//
//  Tag+Create.h
//  Vacation
//
//  Created by Erben Mo on 24/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
