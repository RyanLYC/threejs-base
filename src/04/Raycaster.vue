<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted, onUnmounted } from 'vue'

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

const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
const material = new THREE.MeshBasicMaterial({
  wireframe: true,
})
const redMaterial = new THREE.MeshBasicMaterial({
  color: '#ff0000',
})

// 1000立方体
let cubeArr: THREE.Mesh<THREE.BoxGeometry, THREE.MeshBasicMaterial>[] = []
for (let i = -5; i < 5; i++) {
  for (let j = -5; j < 5; j++) {
    for (let z = -5; z < 5; z++) {
      const cube = new THREE.Mesh(cubeGeometry, material)
      cube.position.set(i, j, z)
      scene.add(cube)
      cubeArr.push(cube)
    }
  }
}

// 创建投射光线对象
const raycaster = new THREE.Raycaster()

const render = () => {
  controls.update()
  renderer.render(scene, camera)

  //浏览器自带的请求动画帧
  requestAnimationFrame(render)
}

// 鼠标的位置对象
const mouse = new THREE.Vector2()
let renderWidth = 0
let renderHeight = 0
const onClickHandler = (event: MouseEvent) => {
  // console.log(event)
  // offsetX、offsetY ：事件属性返回触发事件时 鼠标相对于事件源元素 的X,Y坐标，标准事件没有对应的属性。

  // clientX、clientY ： 事件属性返回当事件被触发时鼠标指针相对于浏览器页面（或客户区）的水平坐标、垂直坐标。
  mouse.x = (event.offsetX / renderWidth) * 2 - 1
  mouse.y = -((event.offsetY / renderHeight) * 2 - 1)
  raycaster.setFromCamera(mouse, camera)
  let result: any = raycaster.intersectObjects(cubeArr)
  //   console.log(result);
  //   result[0].object.material = redMaterial;
  result.forEach((item: any) => {
    item.object.material = redMaterial
  })
}

onMounted(() => {
  canvas = document.getElementById('canvas') as HTMLCanvasElement
  canvas.addEventListener('click', onClickHandler)
  //初始化渲染器
  renderer = new THREE.WebGLRenderer({ canvas })
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)
  renderWidth = clientWidth
  renderHeight = clientHeight

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

onUnmounted(() => {
  canvas.removeEventListener('click', onClickHandler)
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
    renderWidth = clientWidth
    renderHeight = clientHeight
  }
})
</script>
<style scoped>
#canvas {
  width: 100%;
  height: 100%;
}
</style>
