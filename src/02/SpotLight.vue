<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
import * as dat from 'dat.gui'

onMounted(() => {
  // 灯光 & 阴影
  // 1. 材质要满足能够对光照有反应的
  // 2. 设置渲染器开启阴影的计算 renderer.shadowMap.enabled = true
  // 3. 设置光照投射阴影 directionalLight.castShadow = true
  // 4. 设置物体投射阴影 sphere.castShadow = true
  // 5. 设置物体接收阴影 plane.receiveShadow = true

  //创建场景
  const scene = new THREE.Scene()

  //创建物体
  //创建几何体
  const spherGeometry = new THREE.SphereGeometry(1, 20, 20)
  const material = new THREE.MeshStandardMaterial()

  const sphere = new THREE.Mesh(spherGeometry, material) // 将几何体和材质组合为物体
  sphere.castShadow = true
  scene.add(sphere)

  // 添加个平面
  const planeGeometry = new THREE.PlaneGeometry(50, 50)
  const plane = new THREE.Mesh(planeGeometry, material)
  plane.position.set(0, -1, 0)
  plane.rotation.x = -Math.PI / 2
  plane.receiveShadow = true
  scene.add(plane)

  //  环境光(颜色 强度)
  const light = new THREE.AmbientLight(0xffffff, 0.5)
  scene.add(light)
  // 聚灯光(颜色 强度 位置)
  const spotLight = new THREE.SpotLight(0xffffff, 0.5)
  spotLight.position.set(5, 5, 5)
  spotLight.castShadow = true
  // 设置阴影模糊度
  spotLight.shadow.radius = 20
  // // 设置阴影贴图的分辨率
  spotLight.shadow.mapSize.set(4096, 4096)
  // 等跟着球走
  spotLight.target = sphere
  // 灯的角度 最大 90度
  spotLight.angle = Math.PI / 6
  // 设置透视相机的属性 一般不用修改
  // spotLight.shadow.camera.near = 0.5 近端
  // spotLight.shadow.camera.far = 500 远端
  // spotLight.shadow.camera.fov = 5 角度

  // 从光源发出的最大距离 默认 0
  spotLight.distance = 0
  // 聚光锥的半影衰减百分比 默认 0
  spotLight.penumbra = 0
  // 光线随着距离增加变暗的衰减量。默认值为 2。在物理正确渲染的上下文中，不应更改默认值。
  // spotLight.decay = 1

  const gui = new dat.GUI()
  gui.add(sphere.position, 'x').min(-5).max(5).step(0.1)
  gui
    .add(spotLight, 'angle')
    .min(0)
    .max(Math.PI / 2)
    .step(0.01)
  gui.add(spotLight, 'distance').min(0).max(20).step(0.1)
  gui.add(spotLight, 'penumbra').min(0).max(1).step(0.1)
  // gui.add(spotLight, 'decay').min(0).max(5).step(0.1)

  scene.add(spotLight)

  const canvas = document.getElementById('canvas') as HTMLCanvasElement
  //初始化渲染器
  const renderer = new THREE.WebGLRenderer({ canvas })
  renderer.shadowMap.enabled = true
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)

  //创建相机
  const camera = new THREE.PerspectiveCamera(
    75,
    clientWidth / clientHeight,
    0.1,
    1000
  )
  //设置相机位置
  camera.position.set(0, 0, 10)

  // 渲染内容
  // renderer.render(scene, camera)

  //创建轨道控制器
  const controls = new OrbitControls(camera, renderer.domElement)

  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true

  //坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  function render() {
    controls.update()
    renderer.render(scene, camera)

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
