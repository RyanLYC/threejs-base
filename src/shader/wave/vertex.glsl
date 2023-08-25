precision lowp float;
attribute vec3 position; // 顶点位置
attribute vec2 uv; // 图形的uv

uniform mat4 modelMatrix; // 模型矩阵
uniform mat4 viewMatrix; // 视图矩阵
uniform mat4 projectionMatrix; // 投影矩阵

// highp -2^16 - 2^16
// mediump -2^10 - 2^10
// lowp -2^8 - 2^8

varying vec2 vUv;
varying float vElevation;

// 获取时间
uniform float uTime;

void main(){
  vUv = uv;
  vec4 modelPosition = modelMatrix * vec4( position, 1.0 );

  // modelPosition.x += 1.0;
  // modelPosition.z += 1.0;

  // modelPosition.z += modelPosition.x;

  modelPosition.z = sin((modelPosition.x + uTime) * 10.0) * 0.05;
  modelPosition.z += sin((modelPosition.y + uTime) * 10.0) * 0.05;
  vElevation = modelPosition.z;

  gl_Position = projectionMatrix * viewMatrix * modelPosition;
}
