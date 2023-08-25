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
// 射线
const raycaster = new THREE.Raycaster()

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

// 添加标签
const earthDiv = document.createElement('div')
earthDiv.className = 'label'
earthDiv.innerHTML = '地球'
const earthLabel = new CSS2DObject(earthDiv)
earthLabel.position.set(0, 1, 0) //相对于父级元素的位置
earth.add(earthLabel)

// 中国
const chinaDiv = document.createElement('div')
chinaDiv.className = 'china'
chinaDiv.innerHTML = '中国'
const chinaLabel = new CSS2DObject(chinaDiv)
chinaLabel.position.set(-0.3, 0.5, -0.9)
earth.add(chinaLabel)

const moonDiv = document.createElement('div')
moonDiv.className = 'label'
moonDiv.innerHTML = '月球'
const moonLabel = new CSS2DObject(moonDiv)
moonLabel.position.set(0, 0.3, 0)
moon.add(moonLabel)

// 实例化 css2d 的渲染器
const labelRender = new CSS2DRenderer()

const clock = new THREE.Clock()

const render = () => {
  requestAnimationFrame(render)

  const elapsed = clock.getElapsedTime()

  moon.position.set(Math.sin(elapsed) * 5, 0, Math.cos(elapsed) * 5)

  // 通过射线设置标签隐藏
  const chinaPosition = chinaLabel.position.clone()
  // 计算出标签跟摄像机的距离
  const labelDistance = chinaPosition.distanceTo(camera.position)
  // 检测射线的碰撞
  // chinaLabel.position
  // 向量(坐标)从世界空间投影到相机的标准化设备坐标 (NDC) 空间。
  chinaPosition.project(camera)
  raycaster.setFromCamera(
    new THREE.Vector2(chinaPosition.x, chinaPosition.y),
    camera
  )

  const intersects = raycaster.intersectObjects(scene.children, true)

  // 如果没有碰撞到任何物体，那么让标签显示
  if (intersects.length == 0) {
    chinaLabel.element.classList.remove('hidden')
  } else {
    const minDistance = intersects[0].distance
    // console.log(minDistance, labelDistance)
    if (minDistance < labelDistance) {
      chinaLabel.element.classList.add('hidden')
    } else {
      chinaLabel.element.classList.remove('hidden')
    }
  }

  // 标签渲染器渲染
  labelRender.render(scene, camera)

  renderer.render(scene, camera)
}

onMounted(() => {
  canvas = document.getElementById('canvas') as HTMLCanvasElement
  //初始化渲染器
  renderer = new THREE.WebGLRenderer({ canvas })
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)

  labelRender.setSize(clientWidth, clientHeight)
  const renderWrapper = document.querySelector('.render-wrapper')
  renderWrapper?.appendChild(labelRender.domElement)
  labelRender.domElement.style.position = 'fixed'
  labelRender.domElement.style.top = '0px'
  labelRender.domElement.style.left = '220px'
  labelRender.domElement.style.zIndex = '10'

  camera.aspect = clientWidth / clientHeight //更新相机
  camera.updateProjectionMatrix() //更新相机投影矩阵

  // 创建轨道控制器
  controls = new OrbitControls(camera, labelRender.domElement)
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
