// vertexShader : 这是顶点着色器的代码。顶点着色器的主要任务是计算顶点的最终位置（3D坐标转变为屏幕的2D坐标）。在这个例子中，顶点着色器仅仅是执行了一个标准的模型-视图-投影变换。函数void main()是着色器的入口点
void main(){
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4( position, 1.0 );
}
