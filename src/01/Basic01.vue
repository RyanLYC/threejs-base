<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'

onMounted(() => {
  //创建场景
  const scene = new THREE.Scene()

  //创建相机
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  )
  //设置相机位置
  camera.position.set(0, 0, 10)
  scene.add(camera)
  //创建物体
  //创建几何体
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
  const mate = new THREE.MeshBasicMaterial({ color: 0xff0000 })
  //根据几何体和材质创建物体
  const cube = new THREE.Mesh(cubeGeometry, mate)
  // 移动物体
  // cube.position.set(5, 0, 0)
  // cube.position.x = 3

  //物体的缩放
  // cube.scale.set(3, 2, 5)

  // 物体旋转
  cube.rotation.set(Math.PI / 4, 0, 0)

  scene.add(cube)

  const canvas = document.getElementById('canvas') as HTMLCanvasElement
  // canvas.width = window.innerWidth
  // canvas.height = window.innerHeight
  //初始化渲染器
  const renderer = new THREE.WebGLRenderer({ canvas })
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)

  // 渲染内容
  // renderer.render(scene, camera)

  //创建轨道控制器
  new OrbitControls(camera, renderer.domElement)

  //坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  function render() {
    renderer.render(scene, camera)

    // cube.position.x += 0.1
    // if (cube.position.x > 5) {
    //   cube.position.x = 0
    // }

    //浏览器自带的请求动画帧
    requestAnimationFrame(render)
  }

  render()
})
</script>
<style scoped>
#canvas {
  width: 100%;
  height: 100%;
}
</style>
