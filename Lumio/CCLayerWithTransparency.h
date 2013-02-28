//
//  CCLayerWithTransparency.h
//  Lumio
//
//  Created by Joanne Dyer on 2/21/13.
//  Copyright 2013 Joanne Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//Created in order to give a fade transition between layers (only normally available for scenes.)
@interface CCLayerWithTransparency : CCLayer {
}

@property (nonatomic) GLubyte opacity;

@end
