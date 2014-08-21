//
//  ShaderProcessor.h
//  GLParticles1
//
//  Created by GRITS on 3/14/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderProcessor : NSObject

- (GLuint)BuildProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource;

@end
