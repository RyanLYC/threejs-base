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

const cubeArr: any[] = []
//设置物体材质
const cubeWorldMaterial = new CANNON.Material('cube')

const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(20, 20),
  new THREE.MeshStandardMaterial()
)

floor.position.set(0, -5, 0)
floor.rotation.x = -Math.PI / 2
floor.receiveShadow = true
scene.add(floor)

// 创建物理世界
// const world = new CANNON.World({ gravity: 9.8 });
const world = new CANNON.World()
world.gravity.set(0, -9.8, 0)

// 创建击打声音
// const hitSound = new Audio('assets/metalHit.mp3')

// 物理世界创建地面
const floorShape = new CANNON.Plane()
const floorBody = new CANNON.Body()
const floorMaterial = new CANNON.Material('floor')
floorBody.material = floorMaterial
// 当质量为0的时候，可以使得物体保持不动
floorBody.mass = 0
floorBody.addShape(floorShape)
// 地面位置
floorBody.position.set(0, -5, 0)
// 旋转地面的位置
floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2)
world.addBody(floorBody)

// 设置2种材质碰撞的参数
const defaultContactMaterial = new CANNON.ContactMaterial(
  cubeWorldMaterial,
  floorMaterial,
  {
    //   摩擦力
    friction: 0.1,
    // 弹性
    restitution: 0.7,
  }
)

// 将材料的关联设置添加的物理世界
world.addContactMaterial(defaultContactMaterial)

// 设置世界碰撞的默认材料，如果材料没有设置，都用这个
world.defaultContactMaterial = defaultContactMaterial

function createCube() {
  // 创建立方体和平面
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
  const cubeMaterial = new THREE.MeshStandardMaterial()
  const cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
  cube.castShadow = true
  scene.add(cube)
  // 创建物理cube形状
  const cubeShape = new CANNON.Box(new CANNON.Vec3(0.5, 0.5, 0.5))

  // 创建物理世界的物体
  const cubeBody = new CANNON.Body({
    shape: cubeShape,
    position: new CANNON.Vec3(0, 0, 0),
    //   小球质量
    mass: 1,
    //   物体材质
    material: cubeWorldMaterial,
  })
  cubeBody.applyLocalForce(
    new CANNON.Vec3(300, 0, 0), //添加的力的大小和方向
    new CANNON.Vec3(0, 0, 0) //施加的力所在的位置
  )

  // 将物体添加至物理世界
  world.addBody(cubeBody)
  // 添加监听碰撞事件
  function HitEvent(e) {
    // 获取碰撞的强度
    //   console.log("hit", e);
    const impactStrength = e.contact.getImpactVelocityAlongNormal()
    if (impactStrength > 2) {
      //   重新从零开始播放
      // hitSound.currentTime = 0
      // hitSound.volume = impactStrength / 12
      // hitSound.play()
    }
  }
  cubeBody.addEventListener('collide', HitEvent)
  cubeArr.push({
    mesh: cube,
    body: cubeBody,
  })
}

window.addEventListener('click', createCube)

//添加环境光和平行光
const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
scene.add(ambientLight)
const dirLight = new THREE.DirectionalLight(0xffffff, 0.5)
dirLight.castShadow = true
scene.add(dirLight)

const clock = new THREE.Clock()

const render = () => {
  let deltaTime = clock.getDelta()
  // 更新物理引擎里世界的物体
  world.step(1 / 120, deltaTime)

  //   cube.position.copy(cubeBody.position);
  cubeArr.forEach((item) => {
    item.mesh.position.copy(item.body.position)
    // 设置渲染的物体跟随物理的物体旋转
    item.mesh.quaternion.copy(item.body.quaternion)
  })

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
