<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
/** 自适应 根据 CSS 宽高  */
import {
  BoxGeometry,
  Mesh,
  MeshPhongMaterial,
  PerspectiveCamera,
  Scene,
  WebGLRenderer,
  DirectionalLight,
} from 'three'
import { onMounted } from 'vue'

// 将渲染尺寸设置为其显示的尺寸，返回画布像素尺寸是否等于其显示(css)尺寸的布尔值
// const resizeRendererToDisplaySize = (renderer: WebGLRenderer) => {
//   const { width, height, clientWidth, clientHeight } = renderer.domElement
//   const needResize = width !== clientWidth || height !== clientHeight
//   if (needResize) {
//     renderer.setSize(clientWidth, clientHeight, false) // false 不设置 casvas 的css 尺寸
//   }
//   return needResize
// }
function resizeRendererToDisplaySize(renderer: WebGLRenderer) {
  const { width, height, clientWidth, clientHeight } = renderer.domElement
  const [w, h] = [
    clientWidth * devicePixelRatio,
    clientHeight * devicePixelRatio,
  ]
  const needResize = width !== w || height !== h
  if (needResize) {
    console.log('devicePixelRatio:', devicePixelRatio)
    renderer.setSize(w, h, false)
  }
  return needResize
}

onMounted(() => {
  const scene = new Scene()
  const camera = new PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  )

  const canvas = document.getElementById('canvas') as HTMLCanvasElement

  setTimeout(() => {
    canvas.style.width = '50%'
    canvas.style.height = '50%'
  }, 2000)

  // canvas.width = window.innerWidth
  // canvas.height = window.innerHeight
  const renderer = new WebGLRenderer({ canvas })

  const geometry = new BoxGeometry() // threejs 内置 正方体几何体
  const material = new MeshPhongMaterial({ color: 0x44bb88 }) // 接收光源
  // const cube = new Mesh(geometry, material)
  // scene.add(cube)
  const cubes = [-2, 0, 2].map((num) => makeInstance(num))
  function makeInstance(x: number) {
    const cube = new Mesh(geometry, material)
    cube.position.x = x
    return cube
  }
  scene.add(...cubes)

  const color = 0xffffff
  const intensity = 1
  // 增加平行光
  const light = new DirectionalLight(color, intensity)
  light.position.set(-1, 2, 4)
  scene.add(light)

  camera.position.z = 5
  const animate = () => {
    requestAnimationFrame(animate)

    if (resizeRendererToDisplaySize(renderer)) {
      const { clientWidth, clientHeight } = renderer.domElement
      camera.aspect = clientWidth / clientHeight
      camera.updateProjectionMatrix()
    }

    // cube.rotation.x += 0.01
    // cube.rotation.y += 0.01

    cubes.forEach((cube) => {
      cube.rotation.x += 0.01
      cube.rotation.y += 0.01
    })

    renderer.render(scene, camera)
  }
  animate()
})
</script>
<style scoped>
canvas {
  width: 100%;
  height: 100%;
}
</style>
