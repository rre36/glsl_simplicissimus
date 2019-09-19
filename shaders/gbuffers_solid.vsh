#include "/lib/math.glsl"

varying flat int noDiffuse;

varying vec2 coord;
varying vec2 lmap;

varying vec3 normal;

varying vec3 vpos;
varying vec3 wpos;
varying vec3 spos;
varying vec3 lvec;

varying vec3 sunlightColor;
varying vec3 skylightColor;
varying vec3 torchlightColor;

varying vec4 tint;

attribute vec4 mc_Entity;

uniform vec3 shadowLightPosition;

vec4 position;

#include "/lib/terrain/transform.glsl"
#include "/lib/shadowmap.glsl"

vec3 getShadowCoordinate(vec3 vpos, float bias) {
	vec3 position 	= vpos;
		position   += vec3(bias)*lvec;
		position 	= viewMAD(gbufferModelViewInverse, position);
		position 	= viewMAD(shadowModelView, position);
		position 	= projMAD(shadowProjection, position);

		position.z *= 0.2;
		warpShadowmap(position.xy);

	return position*0.5+0.5;
}

void main() {
	//essential vertex setup
	tint 	= gl_Color;
	coord 	= (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;	
	lmap 	= (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	
	position 	= (gl_ModelViewMatrix*gl_Vertex);
    vpos 		= position.xyz;

    position 	= gbufferModelViewInverse*position;
    position.xyz += cameraPosition.xyz;
	wpos = position.xyz;

	repackPos();

	gl_Position = position;
	gl_FogFragCoord = gl_Position.z;

	normal 	= normalize(gl_NormalMatrix*gl_Normal);
	lvec	= normalize(shadowLightPosition);

	spos 		= getShadowCoordinate(vpos, 0.06);

	//colors
    sunlightColor = vec3(1.0, 1.0, 1.0);
	skylightColor = vec3(0.1, 0.1, 0.1);
	torchlightColor = vec3(1.0, 0.3, 0.0);

	if (mc_Entity.x == 6.0 ||
		mc_Entity.x == 18.0 ||
		mc_Entity.x == 31.0 ||
		mc_Entity.x == 38.0 ||
		mc_Entity.x == 59.0 ||
		mc_Entity.x == 83.0 ||
		mc_Entity.x == 141.0 ||
		mc_Entity.x == 142.0 ||
		mc_Entity.x == 175.0 ||
		mc_Entity.x == 207.0 ||
		mc_Entity.x == 600.0 ||
		mc_Entity.x == 601.0) {
			noDiffuse = 1;
		} else {
            noDiffuse = 0;
        }
}