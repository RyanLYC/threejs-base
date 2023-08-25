<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader'

onMounted(() => {
  //创建场景
  const scene = new THREE.Scene()

  // 环境贴图
  const cubeTextureLoader = new THREE.CubeTextureLoader()
  const envMapTetxture = cubeTextureLoader.load([
    './images/px.jpg',
    './images/nx.jpg',
    './images/py.jpg',
    './images/ny.jpg',
    './images/pz.jpg',
    './images/nz.jpg',
  ])

  //创建物体
  //创建几何体
  const spherGeometry = new THREE.SphereGeometry(1, 20, 20)
  const material = new THREE.MeshStandardMaterial({
    metalness: 0.7, // 金属度  0-1 数值越小越不像金属
    roughness: 0.1, //  粗糙度  0-1 数值越小越光滑
    // envMap: envMapTetxture, //   物体环境贴图
  })

  const sphere = new THREE.Mesh(spherGeometry, material) // 将几何体和材质组合为物体
  scene.add(sphere)

  //  给场景添加背景
  // scene.background = envMapTetxture
  //   给场景所有物体添加默认的环境贴图
  // scene.environment = envMapTetxture

  const rgbeLoader = new RGBELoader()
  rgbeLoader.loadAsync('./images/sky.hdr').then((texture) => {
    texture.mapping = THREE.EquirectangularReflectionMapping
    scene.background = texture
    scene.environment = texture
  })

  //  环境光(颜色 强度)
  const light = new THREE.AmbientLight(0xffffff, 0.5)
  scene.add(light)
  // 直线平行光(颜色 强度 位置)
  // const directionLight = new THREE.DirectionalLight(0xffffff, 0.5)
  // directionLight.position.set(10, 10, 10)
  // scene.add(directionLight)

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
