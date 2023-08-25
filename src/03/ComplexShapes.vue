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
  camera.position.set(0, 0, 10)
  scene.add(camera)

  // 载入纹理
  const textureLoader = new THREE.TextureLoader()
  const texture = textureLoader.load('./images/disc.png')

  const params = {
    count: 10000,
    size: 0.1,
    radius: 5,
    branch: 6, //分支数
    color: '#ff6030',
    rotateScale: 0.3,
    endColor: '#1b3984',
  }
  let geometry = null
  let material = null
  let points = null
  const generateGalaxy = () => {
    geometry = new THREE.BufferGeometry()
    // 生成点
    const positions = new Float32Array(params.count * 3)
    // 设置订单颜色
    const colors = new Float32Array(params.count * 3)
    const centerColor = new THREE.Color(params.color)
    const endColor = new THREE.Color(params.endColor)

    // 循环生成点
    for (let i = 0; i < params.count; i++) {
      // 当前点 再那一条分支 的角度上
      const branchAngel = (i % params.branch) * ((2 * Math.PI) / params.branch)
      // 当前点 距离圆心的距离
      const distance =
        Math.random() * params.radius * Math.pow(Math.random(), 3)

      const current = i * 3
      const randomX =
        (Math.pow(Math.random() * 2 - 1, 3) * (params.radius - distance)) / 5
      const randomY =
        (Math.pow(Math.random() * 2 - 1, 3) * (params.radius - distance)) / 5
      const randomZ =
        (Math.pow(Math.random() * 2 - 1, 3) * (params.radius - distance)) / 5

      positions[current] =
        Math.cos(branchAngel + distance * params.rotateScale) * distance +
        randomX
      positions[current + 1] = randomY
      positions[current + 2] =
        Math.sin(branchAngel + distance * params.rotateScale) * distance +
        randomZ

      // 混合颜色 形成渐变颜色
      const mixColor = centerColor.clone()
      mixColor.lerp(endColor, distance / params.radius)
      colors[current] = mixColor.r
      colors[current + 1] = mixColor.g
      colors[current + 2] = mixColor.b
    }
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.BufferAttribute(positions, 3))
    // 设置点材质
    material = new THREE.PointsMaterial({
      // color: new THREE.Color(params.color),
      size: params.size,
      sizeAttenuation: true,
      depthWrite: false,
      blending: THREE.AdditiveBlending,
      map: texture,
      alphaMap: texture,
      transparent: true,
      vertexColors: true,
    })

    points = new THREE.Points(geometry, material)
    scene.add(points)
  }

  generateGalaxy()

  const controls = new OrbitControls(camera, renderer.domElement)

  // 设置控制器阻尼 更真实  需要在每一帧重新生成时调用controls.update();
  controls.enableDamping = true

  // 坐标标尺
  const axeshekper = new THREE.AxesHelper(5)
  scene.add(axeshekper)

  // 设置时钟
  // const clock = new THREE.Clock()

  function render() {
    // let time = clock.getElapsedTime()

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
