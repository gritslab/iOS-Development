//
//  plotter.cpp
//  GLParticles1
//
//  Created by GRITS on 4/1/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#include "plotter.h"

void drawSomething(float x,float y)
{
    // Set the background color (green)
    glClearColor(0.20f, 0.0f, 0.20f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 2
    // Uniforms
    glUniform1f(self.emitterShader.uX, emitter.uX);
    glUniform1f(self.emitterShader.uY, emitter.uY);
    glUniform1f(self.emitterShader.uCorrelation, emitter.uCorrelation);
    glUniform1f(self.emitterShader.uStdX, emitter.uStdX);
    glUniform1f(self.emitterShader.uStdY, emitter.uStdY);
    
    // 3
    // Attributes
    glEnableVertexAttribArray(self.emitterShader.aX);
    glVertexAttribPointer(self.emitterShader.aX,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, x)));
    
    glEnableVertexAttribArray(self.emitterShader.aY);
    glVertexAttribPointer(self.emitterShader.aY,1,GL_FLOAT,GL_FALSE, sizeof(Particle),(void*)(offsetof(Particle, y)));
    
    // 4
    // Draw particles
    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(self.emitterShader.aX);
    glDisableVertexAttribArray(self.emitterShader.aY);
}