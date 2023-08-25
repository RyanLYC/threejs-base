<template>
  <div
    class="app-wrapper"
    :style="{ overflowY: activeKey !== '3D全屏滚动页面' ? 'hidden' : 'auto' }"
  >
    <div class="left" v-if="activeKey !== '3D全屏滚动页面'">
      <div
        v-for="(_, key) in componentsList"
        :key="key"
        :class="{
          'name-bx-act': activeKey === key,
          'name-bx': true,
        }"
        @click="chosePage(key)"
      >
        {{ key }}
      </div>
    </div>
    <div class="right">
      <template v-for="(value, key) in componentsList" :key="key">
        <component :is="value" v-if="activeKey === key"></component>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

import Basic01 from '@/01/Basic01.vue'
import RequestAnimationFrame from '@/01/RequestAnimationFrame.vue'
import Clock from '@/01/Clock.vue'
import Gsap from '@/01/Gsap.vue'
import SelfAdaption from '@/01/SelfAdaption.vue'
import DatGui from '@/01/DatGui.vue'

import Geometry from '@/02/Geometry.vue'
import Plane from '@/02/Plane.vue'
import BufferGeometryDemo from '@/02/BufferGeometryDemo.vue'
import MeshBasicMaterial from '@/02/MeshBasicMaterial.vue'
import MeshStandardMaterial from '@/02/MeshStandardMaterial.vue'
import EnvironmentMap from '@/02/EnvironmentMap.vue'
import LightingShadow from '@/02/LightingShadow.vue'
import SpotLight from '@/02/SpotLight.vue'
import PointLight from '@/02/PointLight.vue'

import Points from '@/03/Points.vue'
import Starts from '@/03/Starts.vue'
import Snow from '@/03/Snow.vue'
import ComplexShapes from '@/03/ComplexShapes.vue'

import Raycaster from '@/04/Raycaster.vue'

import FullScreenScrolling from '@/05/FullScreenScrolling.vue'

import WebGL from '@/06/WebGL.vue'
import ShaderMaterial from '@/06/ShaderMaterial.vue'
import RawShaderMaterial from '@/06/RawShaderMaterial.vue'
import WaveAnimation from '@/06/WaveAnimation.vue'

import HTML3D from '@/07/HTML3D.vue'
import Physics from '@/07/Physics.vue'
import CANNON from '@/07/CANNON.vue'
import Curve from '@/07/Curve.vue'

const componentsList = {
  'basic-01': Basic01,
  requestAnimationFrame: RequestAnimationFrame,
  clock: Clock,
  gsap补间动画: Gsap,
  随canvas自适应大小: SelfAdaption,
  'dat.gui修改物体属性': DatGui,
  几何体attributes: Geometry,
  画一个面: Plane,
  随机三角形BufferGeometryDemo: BufferGeometryDemo,
  '基础材质-纹理属性': MeshBasicMaterial,
  '基于物理的渲染(PBR)-纹理-灯光': MeshStandardMaterial,
  环境贴图: EnvironmentMap,
  灯光与阴影: LightingShadow,
  聚灯光: SpotLight,
  点光源: PointLight,
  'Points-显示点的类': Points,
  星河: Starts,
  雪花: Snow,
  复杂形状: ComplexShapes,
  '交互-光线投射': Raycaster,
  '3D全屏滚动页面': FullScreenScrolling,
  WebGL绘画三角形: WebGL,
  '着色器材质(ShaderMaterial)': ShaderMaterial,
  '原始着色器材质(RawShaderMaterial)': RawShaderMaterial,
  旗帜波浪动画: WaveAnimation,
  HTML混合3D: HTML3D,
  '物理引擎-Cannon.js': Physics,
  弹出立方体: CANNON,
  物体沿着曲线运动: Curve,
}
const activeKey = ref('物体沿着曲线运动')
const chosePage = (key: string) => {
  activeKey.value = key
}
</script>
<style scoped lang="scss">
.app-wrapper {
  display: flex;
  height: 100%;
  overflow: hidden;

  .left {
    display: flex;
    flex-direction: column;
    width: 200px;
    height: calc(100% - 10px);
    padding: 10px;
    overflow: auto;
    font-size: 14px;
    background: #f0f1f5;
    border: solid 1px #eaeaee;

    .name-bx {
      padding: 10px 20px;
      cursor: pointer;
    }

    .name-bx-act {
      color: blue;
    }
  }

  .right {
    flex: 1;
  }
}
</style>
