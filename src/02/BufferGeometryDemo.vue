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

  //  通过顶点设置创建几何体矩形
  for (let index = 0; index < 50; index++) {
    //随机创建50个三角形
    const geometry = new THREE.BufferGeometry()
    const positionArr = new Float32Array(9)
    for (let ind = 0; ind < 9; ind++) {
      //每一个三角形需要三个顶点   每个顶点需要三个值
      positionArr[ind] = Math.random() * 10 - 5
    }
    geometry.setAttribute('position', new THREE.BufferAttribute(positionArr, 3))

    let color = new THREE.Color(Math.random(), Math.random(), Math.random())
    const Material = new THREE.MeshBasicMaterial({
      color: color,
      transparent: true,
      opacity: 0.5,
    }) // 添加材质

    const mesh = new THREE.Mesh(geometry, Material) // 将几何体和材质组合为物体

    // console.log(mesh);
    scene.add(mesh) //在场景中添加物体
  }

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
