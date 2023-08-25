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

  const canvas = document.getElementById('canvas') as HTMLCanvasElement

  //初始化渲染器
  const renderer = new THREE.WebGLRenderer({ canvas })
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

  //创建物体
  //创建几何体
  const spherGeometry = new THREE.SphereGeometry(3, 30, 30)
  // 材质
  // const material = new THREE.MeshBasicMaterial({
  //   color: 0xff0000,
  //   wireframe: true,
  // })
  // 根据几何体和材质创建物体
  // const mesh = new THREE.Mesh(spherGeometry, pointMaterial)
  const pointsMaterial = new THREE.PointsMaterial()
  pointsMaterial.size = 0.1
  pointsMaterial.color.set(0x00ff00)
  //指定点的大小是否因相机深度而衰减。（仅限透视摄像头。）默认为true。
  pointsMaterial.sizeAttenuation = true
  // 载入纹理
  // const textureLoader = new THREE.TextureLoader()
  // const texture = textureLoader.load('./images/disc.png')
  //  设置点材质纹理
  // pointsMaterial.map = texture
  // pointsMaterial.alphaMap = texture
  // pointsMaterial.transparent = true
  // pointsMaterial.depthWrite = false
  // pointsMaterial.blending = THREE.AdditiveBlending

  // 根据几何体和材质创建物体
  const points = new THREE.Points(spherGeometry, pointsMaterial)
  // points.position.set(0, 0, 0)

  scene.add(points)

  // 创建轨道控制器
  const controls = new OrbitControls(camera, renderer.domElement)

  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true

  // 坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  function render() {
    controls.update()
    renderer.render(scene, camera)

    // 浏览器自带的请求动画帧
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
