<template>
  <div class="render-wrapper">
    <canvas id="canvas"></canvas>
  </div>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
// 导入connon引擎
// @ts-ignore
import * as CANNON from 'cannon'

/**
1.物理引擎介绍（Physics）
在我们日常生活中，物体之间是存在相互作用力的，他们之间存在弹力、摩擦力等相关系数，物体自身也存在重力等属性，因此并不是简单的碰撞。在Three中，物理引擎主要依赖于第三方插件进行实现，例如Cannon.js,Ammo.js,Oimo.js。
2.二维库
当使用时，仅涉及水平方向时，可以将三维交互转换为二维交互，使用以下二维类库进行实现。
Matter.js
P2.js
Planck.js
Box2D.js

1.2 实现原理
使用中，我们会创建一个Three.js世界和一个Physics物理世界，虽然我们看不见后者但它是真实存在的，每当我们往Three.js世界添加对象时，相应的物理世界也会添加相同对象。物理世界在每一帧更新时都会相应更新到Three.js世界中（通过实体的.position.copy方法获取物理世界实体的位置）。
例如物理世界中的球体在平面上进行真实弹跳效果时，我们会取其每一帧更新后的坐标并将坐标应用到Three.js世界中的对应球体。

2. Cannon.js物理引擎
2.1 Cannon安装
1）安装
cnpm install cannon --save
2）导入
 import * as CANNON from "cannon";
 */

// 创建场景
const scene = new THREE.Scene()
// 渲染器
let renderer: THREE.WebGLRenderer
//创建相机
const camera = new THREE.PerspectiveCamera(
  75,
  window.innerWidth / window.innerHeight,
  0.1,
  300
)
//设置相机位置
camera.position.set(0, 0, 18)

scene.add(camera)
// 轨道控制器
let controls: OrbitControls
// canvas
let canvas: HTMLCanvasElement

//添加环境光和平行光
const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
scene.add(ambientLight)
const dirLight = new THREE.DirectionalLight(0xffffff, 0.5)
dirLight.castShadow = true
scene.add(dirLight)

// 创建球和平面
const sphereGeometry = new THREE.SphereGeometry(1, 20, 20)
const sphereMaterial = new THREE.MeshStandardMaterial()
const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
sphere.castShadow = true
scene.add(sphere)

const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(20, 20),
  new THREE.MeshStandardMaterial()
)

floor.position.set(0, -5, 0)
floor.rotation.x = -Math.PI / 2
floor.receiveShadow = true
scene.add(floor)

// 创建物理世界
const world = new CANNON.World()
world.gravity.set(0, -9.8, 0)
// 创建物理小球形状
const sphereShape = new CANNON.Sphere(1)

//设置物体材质
const sphereWorldMaterial = new CANNON.Material()

// 创建物理世界的物体
const sphereBody = new CANNON.Body({
  shape: sphereShape,
  position: new CANNON.Vec3(0, 0, 0),
  //   小球质量
  mass: 1,
  //   物体材质
  material: sphereWorldMaterial,
})

// 将物体添加至物理世界
world.addBody(sphereBody)

// 物理世界创建地面
const floorShape = new CANNON.Plane()
const floorBody = new CANNON.Body()
// 当质量为0的时候，可以使得物体保持不动
floorBody.mass = 0
floorBody.addShape(floorShape)
// 地面位置
floorBody.position.set(0, -5, 0)
// 旋转地面的位置
floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2) //按x轴旋转
world.addBody(floorBody)

const clock = new THREE.Clock()

const render = () => {
  let deltaTime = clock.getDelta()
  // 更新物理引擎里世界的物体
  world.step(1 / 120, deltaTime)

  sphere.position.copy(sphereBody.position)

  renderer.render(scene, camera)
  //   渲染下一帧的时候就会调用render函数
  requestAnimationFrame(render)
}

onMounted(() => {
  canvas = document.getElementById('canvas') as HTMLCanvasElement
  //初始化渲染器
  renderer = new THREE.WebGLRenderer({ canvas })
  // 开启场景中的阴影贴图
  renderer.shadowMap.enabled = true
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
