function loadShader(gl: WebGLRenderingContext, type: number, source: string) {
  //根据着色类型，建立着色器对象
  const shader = gl.createShader(type)
  if (shader === null) {
    return shader
  }
  //将着色器源文件传入着色器对象中
  gl.shaderSource(shader, source)
  //编译着色器对象
  gl.compileShader(shader)
  //返回着色器对象
  return shader
}

export function initShaders(
  gl: WebGLRenderingContext,
  vsSource: string,
  fsSource: string
) {
  //创建程序对象
  const program = gl.createProgram()
  if (program === null) {
    return program
  }
  //建立着色对象
  const vertexShader = loadShader(gl, gl.VERTEX_SHADER, vsSource)
  if (vertexShader === null) {
    return vertexShader
  }
  const fragmentShader = loadShader(gl, gl.FRAGMENT_SHADER, fsSource)
  if (fragmentShader === null) {
    return fragmentShader
  }
  //把顶点着色对象装进程序对象中
  gl.attachShader(program, vertexShader)
  //把片元着色对象装进程序对象中
  gl.attachShader(program, fragmentShader)
  //连接webgl上下文对象和程序对象
  gl.linkProgram(program)
  //启动程序对象
  gl.useProgram(program)

  return program
}
