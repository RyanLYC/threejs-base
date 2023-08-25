// 在WebGL和GLSL中，attributes 和 uniforms是两种预定义的类型，都是用来在着色器中存储和传递数据的
// attributes存储的是每个顶点独有的数据，如位置，颜色，纹理坐标等
// uniforms则用于存储在一个渲染调用中对所有顶点都相同的数据，比如变换矩阵，光照参数等

//在threejs中，这些attributes和uniforms都是通过JavaScript在CPU端设置，然后在GPU端的着色器中获取其值进行计算。

// 下面是一些常见的attributes和uniforms：
// attributes：
  // position：顶点的位置。
  // normal：顶点的法向量。
  // uv：顶点的纹理坐标。

//uniforms：
  // modelViewMatrix：模型视图矩阵。
  // projectionMatrix：投影矩阵。
  // normalMatrix：法向量矩阵。
  // time：用于动画等需要时间参数的场景。

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

void main(){
  vUv = uv;
  gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4( position, 1.0 );
}
