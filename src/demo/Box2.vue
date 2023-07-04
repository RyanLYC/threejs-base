<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
/** 多个立方体 */
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

onMounted(() => {
  const scene = new Scene()
  const camera = new PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  )

  const canvas = document.getElementById('canvas') as HTMLCanvasElement
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
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
<!-- <style scoped></style> -->
