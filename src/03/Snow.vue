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
    20
  )
  //设置相机位置
  camera.position.set(0, 0, 40)
  scene.add(camera)

  function createPoints(name: string, size = 0.5) {
    const particlesGeometry = new THREE.BufferGeometry()
    const count = 3000

    // 设置缓冲区数组
    const positions = new Float32Array(count * 3)
    // 设置粒子顶点颜色
    const colors = new Float32Array(count * 3)
    // 设置顶点
    for (let i = 0; i < count * 3; i++) {
      positions[i] = (Math.random() - 0.5) * 100
      colors[i] = Math.random()
    }
    particlesGeometry.setAttribute(
      'position',
      new THREE.BufferAttribute(positions, 3)
    )
    particlesGeometry.setAttribute(
      'color',
      new THREE.BufferAttribute(colors, 3)
    )

    // 设置点材质
    const pointsMaterial = new THREE.PointsMaterial()
    pointsMaterial.size = size
    pointsMaterial.color.set(0xfff000)
    // 相机深度而衰减
    pointsMaterial.sizeAttenuation = true

    // 载入纹理
    const textureLoader = new THREE.TextureLoader()
    const texture = textureLoader.load(`./images/snowflake${name}.png`)
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
    return points
  }

  const points = createPoints('1')

  const points1 = createPoints('2', 1)

  const points2 = createPoints('3', 2)

  const points3 = createPoints('4')

  const points4 = createPoints('5', 1)

  const controls = new OrbitControls(camera, renderer.domElement)

  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true

  // 坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  // 设置时钟
  const clock = new THREE.Clock()

  function render() {
    let time = clock.getElapsedTime()
    points.rotation.x = time * 0.1
    points.rotation.y = time * 0.1
    points1.rotation.x = time * 0.2
    points2.rotation.x = time * 0.3
    points3.rotation.x = time * 0.2
    points4.rotation.x = time * 0.1
    points4.rotation.y = time * 0.1

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
