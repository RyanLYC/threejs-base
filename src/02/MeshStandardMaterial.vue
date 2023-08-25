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

  let event: any = {}
  event.onLoad = function () {
    console.log('所有资源图片加载完成')
  }
  event.onProgress = function (url: string, num: number, total: number) {
    console.log(url + '加载完成')
    console.log('加载进度：' + num)
    console.log('资源总数：' + total)
    console.log('加载进度百分比：' + ((num / total) * 100).toFixed(2) + '%')
  }
  event.onError = function (e: any) {
    console.log(e)
    console.log('图片加载错误')
  }
  const loadingManager = new THREE.LoadingManager(
    event.onLoad,
    event.onProgress,
    event.onError
  )

  // 纹理与材质
  // 导入纹理 通过图片加载
  const textureLoader = new THREE.TextureLoader(loadingManager)
  const wenliColorTexture = textureLoader.load('./images/texture/basecolor.jpg') //纹理加载器
  // 设置重复
  // wenliColorTexture.repeat.set(2, 2)

  // wenliColorTexture.wrapS = THREE.RepeatWrapping //  无限重复 水平方向
  // wenliColorTexture.wrapT = THREE.RepeatWrapping //  无限重复 垂直方向

  // 纹理的显示算法
  wenliColorTexture.minFilter = THREE.NearestFilter //一纹素小于一像素时，贴图如何采样
  wenliColorTexture.magFilter = THREE.NearestFilter //一纹素大于一像素时，贴图如何采样

  // 纹理的透明
  const wenliAplhaTexture = textureLoader.load('./images/texture/opacity.jpg') //纹理加载器加载不透明度灰阶图片
  // 纹理的环境遮挡
  const wenliAoTexture = textureLoader.load(
    './images/texture/ambientOcclusion.jpg'
  ) //纹理加载器
  // 置换贴图 - 点位移贴图
  const wenliHeightTexture = textureLoader.load('./images/texture/height.png')
  // 粗糙度贴图
  const roughnessTexture = textureLoader.load('./images/texture/roughness.jpg')
  // 材质的金属度
  const metallicTexture = textureLoader.load('./images/texture/metallic.jpg')
  // 法线贴图
  const normalTexture = textureLoader.load('./images/texture/normal.jpg')

  //创建物体
  //创建几何体
  const cubeGeometry = new THREE.BoxGeometry(1, 1, 1, 100, 100, 100)
  const meshMate = new THREE.MeshStandardMaterial({
    // color: 0xffff00,
    map: wenliColorTexture,
    side: THREE.DoubleSide, //双面 默认渲染前面
    alphaMap: wenliAplhaTexture, //控制表面透明度(黑色完全透明 白色完全不透明  灰阶代表不透明度)
    transparent: true, //允许透明
    aoMap: wenliAoTexture, //环境遮挡贴图 aoMap需要第二组UV。
    displacementMap: wenliHeightTexture, // 位移贴图会影响网格顶点的位置 // Geometry几何体需要增加点数
    displacementScale: 0.02, // 位移贴图对网格的影响程度
    roughness: 1, //材质的粗糙程度。0.0表示平滑的镜面反射，1.0表示完全漫反射。默认值为1.0，如果还提供roughnessMap，则两个值相乘。
    roughnessMap: roughnessTexture,
    metalness: 1, // 材质与金属的相似度。如果还提供了metalnessMap，则两个值相乘
    metalnessMap: metallicTexture,
    normalMap: normalTexture,
  }) // 这种材质不受光照的影响。
  //根据几何体和材质创建物体
  const cube = new THREE.Mesh(cubeGeometry, meshMate)

  scene.add(cube)

  // 给 cube 添加第二组 UV
  cubeGeometry.setAttribute(
    'uv2',
    new THREE.BufferAttribute(cubeGeometry.attributes.uv.array, 2)
  )

  // 添加个平面
  const planeGeometry = new THREE.PlaneGeometry(1, 1, 200, 200)
  const plane = new THREE.Mesh(planeGeometry, meshMate)
  plane.position.set(1.5, 0, 0)
  scene.add(plane)

  // 给平面设置第二组 UV
  planeGeometry.setAttribute(
    'uv2',
    new THREE.BufferAttribute(planeGeometry.attributes.uv.array, 2)
  )

  //  环境光(颜色 强度)
  const light = new THREE.AmbientLight(0xffffff, 0.5)
  scene.add(light)
  // 直线平行光(颜色 强度 位置)
  const directionLight = new THREE.DirectionalLight(0xffffff, 0.5)
  directionLight.position.set(10, 10, 10)
  scene.add(directionLight)

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
