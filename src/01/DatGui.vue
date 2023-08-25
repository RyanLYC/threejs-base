<template>
  <canvas id="canvas"></canvas>
</template>

<script setup lang="ts">
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { onMounted } from 'vue'
import gsap from 'gsap'
import * as dat from 'dat.gui'

onMounted(() => {
  //创建场景
  const scene = new THREE.Scene()

  //创建相机
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  )
  //设置相机位置
  camera.position.set(0, 0, 10)
  scene.add(camera)
  //创建物体
  //创建几何体
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
  //材质
  const mate = new THREE.MeshBasicMaterial({ color: 0xff0000 })
  //根据几何体和材质创建物体
  const cube = new THREE.Mesh(cubeGeometry, mate)
  // 移动物体
  // cube.position.set(5, 0, 0)
  // cube.position.x = 3

  //物体的缩放
  // cube.scale.set(3, 2, 5)

  // 物体旋转
  // cube.rotation.set(Math.PI / 4, 0, 0)

  scene.add(cube)

  const gui = new dat.GUI()
  gui
    .add(cube.position, 'x')
    .min(0)
    .max(5)
    .name('移动x轴')
    .onFinishChange((value: number) => {
      console.log('x轴值被修改：', value)
    })
  // .onChange((value: number) => {
  //   console.log('x轴值被修改：', value)
  // })
  // 修改物体颜色
  const params = {
    color: '#FF00FF',
    fn: () => {
      // 动画
      gsap.to(cube.position, {
        x: 5,
        duration: 3,
        ease: 'power1.inOut',
      })
    },
  }
  gui.addColor(params, 'color').onChange((value: string) => {
    console.log('x轴值被修改：', value)
    cube.material.color.set(value)
  })
  gui.add(cube, 'visible').name('是否显示')
  // 点击按钮触发事件
  gui.add(params, 'fn').name('点击移动')
  // 具有折叠功能
  const folder = gui.addFolder('设置立方体')
  folder.add(cube.material, 'wireframe')

  const canvas = document.getElementById('canvas') as HTMLCanvasElement
  // canvas.width = window.innerWidth
  // canvas.height = window.innerHeight
  //初始化渲染器
  const renderer = new THREE.WebGLRenderer({ canvas })
  //设置渲染器尺寸大小
  const { clientWidth, clientHeight } = renderer.domElement
  renderer.setSize(clientWidth, clientHeight)

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
  // const animate = gsap.to(cube.position, {
  //   x: 5,
  //   duration: 5,
  //   ease: 'power1.inOut',
  //   onComplete: () => {
  //     console.log('动画完成')
  //   },
  // })
  // window.addEventListener('dblclick', () => {
  //   if (animate.isActive()) {
  //     animate.pause()
  //   } else {
  //     animate.resume()
  //   }
  // })
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
