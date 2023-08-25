<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
import basicVertexShader from '../shader/raw/vertex.glsl?raw'
import basicFragmentShader from '../shader/raw/fragment.glsl?raw'

// 创建场景
const scene = new THREE.Scene()
// 渲染器
let renderer: THREE.WebGLRenderer
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
// 轨道控制器
let controls: OrbitControls
// canvas
let canvas: HTMLCanvasElement

// 创建着色器材质
const shaderMaterial = new THREE.RawShaderMaterial({
  vertexShader: basicVertexShader,
  fragmentShader: basicFragmentShader,
})
// const basicMate = new THREE.MeshBasicMaterial({
//   color: 0xffff00,
// })
// 利用着色器材质创建一个平面
const plane = new THREE.Mesh(
  new THREE.PlaneGeometry(1, 1, 64, 64),
  shaderMaterial
)
// 添加平面到场景
scene.add(plane)

const render = () => {
  controls.update()
  renderer.render(scene, camera)

  //浏览器自带的请求动画帧
  requestAnimationFrame(render)
}

onMounted(() => {
  canvas = document.getElementById('canvas') as HTMLCanvasElement
  //初始化渲染器
  renderer = new THREE.WebGLRenderer({ canvas })
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)

  camera.aspect = clientWidth / clientHeight //更新相机
  camera.updateProjectionMatrix() //更新相机投影矩阵

  // 创建轨道控制器
  controls = new OrbitControls(camera, renderer.domElement)
  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true
  //坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  render()
})

// 监听画面变化渲染画面
window.addEventListener('resize', () => {
  canvas.style.width = '100%'
  canvas.style.height = '100%'

  const { width, height, clientWidth, clientHeight } = renderer.domElement

  const [w, h] = [
    clientWidth * window.devicePixelRatio,
    clientHeight * window.devicePixelRatio,
  ]
  const needResize = width !== w || height !== h
  // const needResize = width !== clientWidth || height !== clientHeight
  if (needResize) {
    camera.aspect = clientWidth / clientHeight //更新相机
    camera.updateProjectionMatrix() //更新相机投影矩阵
    renderer.setSize(clientWidth, clientHeight, false) //更新渲染器尺寸大小
    // renderer.setPixelRatio(window.devicePixelRatio) //设置渲染器像素比————就是缩放比
  }
})
</script>
<style scoped>
#canvas {
  width: 100%;
  height: 100%;
}
</style>
