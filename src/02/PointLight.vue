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

  const smallBall = new THREE.Mesh(
    new THREE.SphereGeometry(0.1, 20, 20),
    new THREE.MeshBasicMaterial({ color: 0xff0000 })
  )
  smallBall.position.set(4, 4, 4)

  //  环境光(颜色 强度)
  // const light = new THREE.AmbientLight(0xffffff, 0.5)
  // scene.add(light)
  // 聚灯光(颜色 强度 位置)
  const pointLight = new THREE.PointLight(0xff0000, 1)
  smallBall.add(pointLight)
  pointLight.position.set(5, 5, 5)
  pointLight.castShadow = true
  // 设置阴影模糊度
  pointLight.shadow.radius = 20
  // // 设置阴影贴图的分辨率
  pointLight.shadow.mapSize.set(1024, 1024)

  // 从光源发出的最大距离 默认 0
  pointLight.distance = 0

  const gui = new dat.GUI()
  gui.add(pointLight.position, 'x').min(-5).max(5).step(0.1)

  gui.add(pointLight, 'distance').min(0).max(20).step(0.1)

  scene.add(smallBall)

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
  scene.add(camera)

  // 渲染内容
  // renderer.render(scene, camera)

  //创建轨道控制器
  const controls = new OrbitControls(camera, renderer.domElement)

  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true

  //坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  const clock = new THREE.Clock()

  function render() {
    // 获取时钟运行的总时长
    let time = clock.getElapsedTime()
    smallBall.position.x = Math.sin(time) * 3 //(-3,3)
    smallBall.position.z = Math.cos(time) * 3 //(-3,3)
    // smallBall.position.y = 4 + Math.sin(time * 10)

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
