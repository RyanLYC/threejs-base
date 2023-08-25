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

  // 开启场景中的阴影贴图
  renderer.shadowMap.enabled = true

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

  const particlesGeometry = new THREE.BufferGeometry()
  const count = 5000
  // 设置缓冲区数组
  const positions = new Float32Array(count * 3)
  // 设置粒子顶点颜色
  const colors = new Float32Array(count * 3)
  // 设置顶点
  for (let i = 0; i < count * 3; i++) {
    positions[i] = (Math.random() - 0.5) * 100 //-50~50
    colors[i] = Math.random() //0-1
  }
  particlesGeometry.setAttribute(
    'position',
    //console.log(positions),
    new THREE.BufferAttribute(positions, 3)
  )
  particlesGeometry.setAttribute('color', new THREE.BufferAttribute(colors, 3))

  // 设置点材质
  const pointsMaterial = new THREE.PointsMaterial()
  pointsMaterial.size = 0.5
  pointsMaterial.color.set(0xfff000)
  // 相机深度而衰减
  pointsMaterial.sizeAttenuation = true

  // 载入纹理
  const textureLoader = new THREE.TextureLoader()
  const texture = textureLoader.load('./images/snowflake2.png')
  // 设置点材质纹理
  pointsMaterial.map = texture
  pointsMaterial.alphaMap = texture
  pointsMaterial.transparent = true
  pointsMaterial.depthWrite = false
  pointsMaterial.blending = THREE.AdditiveBlending
  // 设置启动顶点颜色
  pointsMaterial.vertexColors = true

  const points = new THREE.Points(particlesGeometry, pointsMaterial)

  scene.add(points)

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
