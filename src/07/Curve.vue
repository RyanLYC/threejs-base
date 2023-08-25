<template>
  <div class="render-wrapper">
    <canvas id="canvas"></canvas>
  </div>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import {
  CSS2DRenderer,
  CSS2DObject,
} from 'three/examples/jsm/renderers/Css2DRenderer.js'
import { onMounted } from 'vue'

// 创建场景
const scene = new THREE.Scene()
// 渲染器
let renderer: THREE.WebGLRenderer
//创建相机
const camera = new THREE.PerspectiveCamera(
  45,
  window.innerWidth / window.innerHeight,
  0.1,
  200
)
//设置相机位置
camera.position.set(0, 5, -10)

scene.add(camera)
// 轨道控制器
let controls: OrbitControls
// canvas
let canvas: HTMLCanvasElement

// 设置直线光源
const dirLight = new THREE.DirectionalLight(0xffffff)
dirLight.position.set(0, 0, 1)
scene.add(dirLight)
const light = new THREE.AmbientLight(0xffffff, 0.5) // soft white light
scene.add(light)

const textureLoader = new THREE.TextureLoader()

const earthGeometry = new THREE.SphereGeometry(1, 16, 16)
const earthMaterial = new THREE.MeshPhongMaterial({
  specular: 0x333333,
  shininess: 5,
  map: textureLoader.load('./images/texture/earth/earth_atmos_2048.jpg'),
  specularMap: textureLoader.load(
    './images/texture/earth/earth_specular_2048.jpg'
  ),
  normalMap: textureLoader.load('./images/texture/earth/earth_normal_2048.jpg'),
  normalScale: new THREE.Vector2(0.85, 0.85),
})

const earth = new THREE.Mesh(earthGeometry, earthMaterial)
scene.add(earth)

const moonGeometry = new THREE.SphereGeometry(0.28, 16, 16)
const monMaterial = new THREE.MeshPhongMaterial({
  shininess: 5,
  map: textureLoader.load('./images/texture/earth/moon_1024.jpg'),
})
const moon = new THREE.Mesh(moonGeometry, monMaterial)
moon.position.set(10, 1, 0)
scene.add(moon)

// 根据数组生成曲线
const curve = new THREE.CatmullRomCurve3(
  [
    new THREE.Vector3(-10, 0, 10),
    new THREE.Vector3(-5, 5, 5),
    new THREE.Vector3(0, 0, 5),
    new THREE.Vector3(5, -5, 5),
    new THREE.Vector3(10, 0, 10),
  ],
  true
)
// 在曲线里面获取51个点 这里的50 是 间隔的线段数
const points = curve.getPoints(200)
const geometry = new THREE.BufferGeometry().setFromPoints(points)
const material = new THREE.LineBasicMaterial({ color: 0xff0000 })
// Create the final object to add to the scene
const curveObject = new THREE.Line(geometry, material)
scene.add(curveObject)

const clock = new THREE.Clock()

const render = () => {
  requestAnimationFrame(render)

  const elapsed = clock.getElapsedTime()
  const time = (elapsed / 10) % 1
  const point = curve.getPoint(time)
  // moon.position.set(Math.sin(elapsed) * 5, 0, Math.cos(elapsed) * 5)
  moon.position.copy(point)
  // camera.position.copy(point)
  // camera.lookAt(earth.position)

  renderer.render(scene, camera)
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
  // const axeshekper = new THREE.AxesHelper(5)
  // scene.add(axeshekper)

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

    labelRender.setSize(clientWidth, clientHeight)
  }
})
</script>
<style lang="scss">
.render-wrapper {
  width: 100%;
  height: 100%;

  .label {
    color: #fff;
  }

  .china {
    display: block;
    color: #fff;
  }

  .hidden {
    display: none;
  }

  #canvas {
    width: 100%;
    height: 100%;
  }
}
</style>
