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

  // 纹理 3个图的作用
  // map： wenliColorTexture 正常贴图
  // alphaMap：  wenliAplhaTexture 纹理的透明贴图 - 控制表面透明度(黑色完全透明 白色完全不透明  灰阶代表不透明度)
  //  transparent: true, //允许透明
  // aoMap: wenliAoTexture, //环境遮挡贴图 aoMap需要第二组UV。 - 控制表面透明度(黑色完全透明 白色完全不透明  灰阶代表不透明度)
  // aoMapIntensity : Float 环境遮挡效果的强度。默认值为1。零是不遮挡效果。

  // 纹理与材质
  // 导入纹理 通过图片加载
  const textureLoader = new THREE.TextureLoader()
  const wenliColorTexture = textureLoader.load('./images/texture/basecolor.jpg') //纹理加载器

  // 偏移
  // wenliColorTexture.offset.x = 0.5
  // wenliColorTexture.offset.y = 0.5
  //设置中心点
  wenliColorTexture.center.set(0.5, 0.5)
  // 旋转 默认左下角顶点
  wenliColorTexture.rotation = Math.PI / 4
  // 设置重复
  wenliColorTexture.repeat.set(2, 3)
  // 设置纹理重复模式
  wenliColorTexture.wrapS = THREE.RepeatWrapping //  无限重复 水平方向
  wenliColorTexture.wrapT = THREE.MirroredRepeatWrapping // 镜像重复  垂直方向

  // 纹理的显示算法
  // wenliColorTexture.minFilter = THREE.NearestFilter;//一纹素小于一像素时，贴图如何采样
  // wenliColorTexture.magFilter = THREE.NearestFilter;//一纹素大于一像素时，贴图如何采样
  // wenliColorTexture.minFilter = THREE.LinearFilter;//默认值
  // wenliColorTexture.magFilter = THREE.LinearFilter;//默认值

  // 纹理的透明
  const wenliAplhaTexture = textureLoader.load('./images/texture/opacity.jpg') //纹理加载器加载不透明度灰阶图片
  // 纹理的环境遮挡
  const wenliAoTexture = textureLoader.load(
    './images/texture/ambientOcclusion.jpg'
  ) //纹理加载器

  //创建物体
  //创建几何体
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1)
  const basicMate = new THREE.MeshBasicMaterial({
    color: 0xffff00,
    map: wenliColorTexture,
    side: THREE.DoubleSide, //双面 默认渲染前面
    alphaMap: wenliAplhaTexture, //控制表面透明度(黑色完全透明 白色完全不透明  灰阶代表不透明度)
    transparent: true, //允许透明
    aoMap: wenliAoTexture, //环境遮挡贴图 aoMap需要第二组UV。
  }) // 这种材质不受光照的影响。
  //根据几何体和材质创建物体
  const cube = new THREE.Mesh(cubeGeometry, basicMate)

  scene.add(cube)

  // 给 cube 添加第二组 UV
  cubeGeometry.setAttribute(
    'uv2',
    new THREE.BufferAttribute(cubeGeometry.attributes.uv.array, 2)
  )

  // 添加个平面
  const planeGeometry = new THREE.PlaneGeometry(1, 1)
  const plane = new THREE.Mesh(planeGeometry, basicMate)
  plane.position.set(3, 0, 0)
  scene.add(plane)

  // 给平面设置第二组 UV
  planeGeometry.setAttribute(
    'uv2',
    new THREE.BufferAttribute(planeGeometry.attributes.uv.array, 2)
  )

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
