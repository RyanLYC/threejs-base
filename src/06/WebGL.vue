<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { initShaders } from './utils'

onMounted(() => {
  const canvas = document.getElementById('canvas') as HTMLCanvasElement

  let gl = canvas.getContext('webgl')
  // 创建顶点着色器
  let vertexShaderSource = `
    attribute vec3 position;
    void main() {
      gl_Position = vec4(position, 1.0);
    }
  `

  // 创建片元着色器
  let fragmentShaderSource = `
    void main() {
      gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
  `
  if (gl) {
    gl.viewport(0, 0, canvas.width, canvas.height)

    const program = initShaders(gl, vertexShaderSource, fragmentShaderSource)
    if (program) {
      // 创建缓冲区
      let positionBuffer = gl.createBuffer()

      // 绑定缓冲区
      gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer)

      // 准备顶点数据
      let positions = [-0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0]
      gl.bufferData(
        gl.ARRAY_BUFFER,
        new Float32Array(positions),
        gl.STATIC_DRAW
      )

      // 获取顶点位置属性的位置
      let positionAttributeLocation = gl.getAttribLocation(program, 'position')

      // 启用顶点属性
      gl.enableVertexAttribArray(positionAttributeLocation)

      // 设置顶点属性指针
      gl.vertexAttribPointer(
        positionAttributeLocation,
        3,
        gl.FLOAT,
        false,
        0,
        0
      )
      // 清空画布
      gl.clearColor(0.0, 0.0, 0.0, 1.0)
      gl.clear(gl.COLOR_BUFFER_BIT)

      // 执行绘制命令
      gl.drawArrays(gl.TRIANGLES, 0, 3)
    }
  }
})
</script>
<style scoped>
#canvas {
  width: 100%;
  height: 100%;
}
</style>
