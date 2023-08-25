<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
import gsap from 'gsap'

onMounted(() => {
  //创建场景
  const scene = new THREE.Scene()

  //创建物体
  //创建几何体
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
  // 材质
  const mate = new THREE.MeshBasicMaterial({ color: 0xff0000 })
  //根据几何体和材质创建物体
  const cube = new THREE.Mesh(cubeGeometry, mate)

  scene.add(cube)

  // console.log('物体：', cube)
  // .attributes : Object 通过 hashmap 存储该几何体相关的属性，hashmap 的 id 是当前 attribute 的名称，值是相应的 buffer。
  console.log('几何体 - attributes：', cube.geometry.attributes)
  // normal  法向 面的朝向
  // position 点的位置
  // uv 平台图位置 类似于 盒子 贴图 贴上 正方体 在平面的位置

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

  // 设置动画 默认匀速运动
  const animate = gsap.to(cube.position, {
    x: 5,
    duration: 5,
    ease: 'power1.inOut',
    onComplete: () => {
      console.log('动画完成')
    },
  })
  window.addEventListener('dblclick', () => {
    if (animate.isActive()) {
      animate.pause()
    } else {
      animate.resume()
    }
  })
  // repeat - 1  无限次
  // yoyo：true 往返运动
  // delay： 延时
  gsap.to(cube.rotation, { x: 2 * Math.PI, duration: 5, repeat: 2 })

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
