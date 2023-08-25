### three.js 的渲染结构
Three.js 封装了场景、灯光、阴影、材质、纹理和三维算法，让你不必再直接用WebGL 开发项目。  
有的时候我们会间接用到WebGL，比如自定义着色器。     
three.js 在渲染三维场景时，需要创建很多对象，并将它们关联在一起。   

下图一个基本的three.js 渲染结构。    

 ![img](images/threejs-structure.svg)     

- Renderer 渲染器

  Renderer 是three.js 的主要对象。当你将一个场景Scene 和一个摄像机Camera 传递到渲染器的渲染方法中，渲染器便会将摄像机视椎体中的三维场景渲染成一个二维图像显示在canvas 画布中。

- Scene 场景对象

  场景对象是树状结构的，其中包含了三维对象Object3D 和灯光对象Light。

  Object3D 是可以被直接渲染出来的，Object3D是网格对象Mesh和集合对象Group的基类。

  场景对象可以定义场景的背景色和雾效。

  在场景对象的树状结构中，每个对象的变换信息都是相对的。

  比如汽车和汽车里的人，人的位置是相对于汽车而言的，当汽车移动了，人的本地坐标位坐标位虽然不变，但其世界坐标位已经变了。相关原理我们在WebGL 的三维世界里说过。

- Camera 相机对象

  按理说，相机对象是在场景里的，但是相机对象不在它所看的场景里，这就像我们自己看不见自己的眼睛一样。

  因此，相机对象可以独立于场景之外。

  相机对象是可以作为其它三维对象的子对象的，这样相机就会随其父对象同步变换。

- Mesh 网格对象

  网格对象由几何体Geometry和材质Material两部分组成，Geometry 负责塑形，Material 负责着色。

  Geometry 和Materia 是可以被多个Mesh 对象复用的。

  比如要绘制两个一模一样的立方体，那只需要实例化两个Mesh 即可，Geometry 和Materia可以使用一套。

- Geometry 几何体对象

  几何体对象负责塑形，存储了与顶点相关的数据，比如顶点点位、顶点索引、uv坐标等。

  Three.js 中内置了许多基本几何体，我们也可以自定义几何体，或者从外部的模型文件里加载几何体

- Material 材质对象

  材质对象负责着色，绘制几何体的表面属性，比如漫反射、镜面反射、光泽度、凹凸等。

  材质对象的许多属性都可以用纹理贴图表示，比如漫反射贴图、凹凸贴图等。

- Texture 纹理对象

  纹理对象就是一张图像。纹理图像的图像源可以是Image 图片、canvas 画布、Video 视频等。

- Light 光源对象

  Light 对象不像Object3D 那样依托于顶点，它更多的是像Object3D 里的材质Material 那样，作用于物体的样式。

  Light 对象可以理解为在为几何体添加了材质后，再利用光效配合材质对几何体的样式进行二次加工。


## webGL渲染管线
WebGL渲染管线是一种用于在Web浏览器中实现高性能3D图形渲染的技术。它基于OpenGL ES 2.0标准并使用JavaScript语言进行编程。

WebGL渲染管线包含以下几个阶段：

1. 顶点着色器阶段（Vertex Shader Stage）：此阶段用于处理输入的顶点数据。在每个顶点上进行计算，可以对顶点的位置、法线、纹理坐标等进行变换和其他操作。该阶段的输出包括变换后的顶点位置和其他可用于后续阶段的数据。

2. 图元装配阶段（Primitive Assembly Stage）：此阶段将顶点组装成几何图元，例如点、直线或三角形。图元装配后的数据包括图元的顶点属性和索引。

3. 几何着色器阶段（Geometry Shader Stage）：此阶段在每个图元上进行计算，可以对整个图元进行操作和变换。几何着色器可以生成新的几何图元，也可以丢弃不需要的图元。

4. 光栅化阶段（Rasterization Stage）：此阶段将图元转换为像素，确定在屏幕上的位置。它根据三角形的顶点属性插值生成每个像素的属性，如颜色和纹理坐标。

5. 片元着色器阶段（Fragment Shader Stage）：此阶段对每个像素进行计算，生成像素的颜色和其他属性。片元着色器可以根据需要使用纹理、光照、阴影等技术进行计算。

6. 输出合并阶段（Output Merger Stage）：此阶段将最终的像素颜色写入帧缓冲区，用于显示在屏幕上。

WebGL渲染管线通过以上几个阶段实现了高性能的3D图形渲染。开发者可以通过编写自定义的着色器程序来控制渲染管线的各个阶段，从而创造出各种复杂的图形效果。

## webGL渲染流程
WebGL渲染流程是指使用WebGL技术进行网页图形渲染的整个过程。它涉及到一系列的步骤和操作，包括准备数据、设置渲染环境、创建着色器、绑定和绘制顶点数据等。

以下是WebGL渲染流程的详细介绍：

1. 准备数据：首先，我们需要准备要渲染的图形数据。这通常包括顶点坐标、纹理坐标、顶点颜色等。这些数据可以通过JavaScript动态生成，也可以从外部文件加载。

2. 创建渲染环境：使用HTML5的canvas元素创建一个WebGL渲染上下文。通过获取canvas元素的上下文对象getContext，传入参数'webgl'来获取WebGL渲染上下文。

3. 设置渲染参数：在渲染之前，我们需要设置一些渲染的参数，如清除颜色、深度测试、背面剔除等。我们可以使用WebGL上下文的clearColor、clearDepth、enable等方法来设置这些参数。

4. 创建着色器：WebGL使用着色器来对图形进行渲染。我们需要创建两个类型的着色器：顶点着色器和片元着色器。顶点着色器用于处理顶点位置和顶点属性，片元着色器用于处理每个像素的颜色。我们需要使用WebGL上下文的createShader、shaderSource、compileShader等方法来创建和编译这些着色器。

5. 创建着色器程序：将顶点着色器和片元着色器链接为一个着色器程序。我们需要使用WebGL上下文的createProgram、attachShader、linkProgram等方法来创建和链接这个着色器程序。

6. 设置顶点数据：将数据绑定到WebGL的缓冲区对象中。我们需要使用WebGL上下文的createBuffer、bindBuffer、bufferData等方法来创建和绑定缓冲区对象，并将准备好的数据存入缓冲区。

7. 启用顶点属性：启用顶点着色器中定义的顶点属性。我们需要使用WebGL上下文的enableVertexAttribArray、vertexAttribPointer等方法来启用和绑定顶点属性。

8. 渲染：使用着色器程序和顶点数据进行渲染。我们需要使用WebGL上下文的useProgram、drawArrays、drawElements等方法来绑定着色器程序和顶点数据，并调用绘制命令来执行渲染。根据需求，可以选择以点、线或三角形的方式绘制。

9. 循环渲染：如果需要动画效果，可以使用循环来不断更新顶点数据并重新执行渲染步骤，以实现动画效果。

以上就是简要介绍了WebGL渲染流程的各个步骤。实际应用中可能涉及更复杂的操作，但以上步骤是一个基本的框架，可以帮助我们理解WebGL的渲染过程。


### 什么是GLSL
 OpenGL着色语言（OpenGL Shading Language）是用来在OpenGL中着色编程的语言，也即开发人员写的短小的自定义程序，他们是在图形卡的GPU （Graphic Processor Unit图形处理单元）上执行的，代替了固定的渲染管线的一部分，使渲染管线中不同层次具有可编程性。比如：视图转换、投影转换等。GLSL（GL Shading Language）的着色器代码分成2个部分：Vertex Shader（顶点着色器）和Fragment（片断着色器），有时还会有Geometry Shader（几何着色器）。负责运行顶点着色的是顶点着色器。它可以得到当前OpenGL 中的状态，GLSL内置变量进行传递。GLSL其使用C语言作为基础高阶着色语言，避免了使用汇编语言或硬件规格语言的复杂性。   

GLSL的变量命名方式与C语言类似。变量的名称可以使用字母，数字以及下划线，但变量名不能以数字开头，还有变量名不能以gl_作为前缀，这个是GLSL保留的前缀，用于GLSL的内部变量。当然还有一些GLSL保留的名称是不能够作为变量的名称的。   

### 顶点着色器和片元着色器
- WebGL的着色器代码分为顶点着色器代码和片元着色器代码两部分，
- 顶点着色器代码会在GPU的顶点着色器单元执行，
- 片元着色器代码会在GPU的片元着色器单元执行，
- 在WebGL渲染管线流程中，或者说GPU的渲染流程中，顶点着色器代码先执行处理顶点，得到一系列片元，然后再执行片元着色器代码处理片元。

#### 顶点着色器Vertex shaders
 - 顶点着色器(Vertex Shader)的作用是定位几何体的顶点。其思想是发送顶点位置、网格变换（如定位position、旋转rotation和缩放scale）、摄影机信息（如定位position、旋转rotation和视野fov）。然后，GPU将按照顶点着色器中的指示处理所有这些信息，以便将顶点投影到2D空间，该空间将成为我们的渲染render，也就是我们的画布canvas。

 * 顶点着色器首先运行; 它接收attributes， 计算/操纵每个单独顶点的位置，并将其他数据（varyings）传递给片元着色器。

#### 片元着色器fragment shaders
- 片元着色器的作用是为几何体的每个可见片元(像素)进行着色。我们会创建片元着色器,可以通过使用uniform将数据（像是颜色）和着色器发送至GPU，之后GPU就会按照指令对每个片元进行着色。

 * 片元（或像素）着色器后运行; 它设置渲染到屏幕的每个单独的“片元”（像素）的颜色。

#### shaders着色器主要工作流程
1. 顶点着色器收到系统传递给它的模型数据。
2. 顶点着色器把模型数据处理成我们后续需要的数据进行输出（这些数据还包括纹理的UV坐标以及其他需要传递给片元着色器的数据）。
3. 系统对顶点着色器输出的顶点数据进行插值，并将插值结果传递给片元着色器。
4. 片元着色器根据这些插值结果计算最后屏幕上的像素颜色。

### 什么是着色器材质
- 着色器材质（ShaderMaterial）是一个用GLSL编写的小程序 ，在GPU上运行。它能够提供 materials 之外的效果，也可以将许多对象组合成单个Geometry或BufferGeometry以提高性能。
- shader中有三种类型的变量: uniforms, attributes, 和 varyings
- attribute	javascript——>顶点着色器	       声明顶点数据变量
- uniform	  javascript——>顶点、片元着色器	  声明非顶点数据变量
- varying	  顶点着色器——>片元着色器	        声明需要插值计算的顶点变量

* Uniforms是所有顶点都具有相同的值的变量。 比如灯光，雾，和阴影贴图就是被储存在uniforms中的数据。 uniforms可以通过顶点着色器和片元着色器来访问。
* Attributes 与每个顶点关联的变量。例如，顶点位置，法线和顶点颜色都是存储在attributes中的数据。attributes 只 可以在顶点着色器中访问。
* Varyings 是从顶点着色器传递到片元着色器的变量。对于每一个片元，每一个varying的值将是相邻顶点值的平滑插值。
* 
`注意`：在shader 内部，uniforms和attributes就像常量；你只能使用JavaScript代码通过缓冲区来修改它们的值。
```js
var geom = new THREE.SphereGeometry(10, 30, 20);
var mate = new THREE.ShaderMaterial({
    vertexShader: `
    varying vec3 vNormal;
    void main() {
                //将attributes的normal通过varying赋值给了向量vNormal
        vNormal = normal;
                //projectionMatrix是投影变换矩阵 modelViewMatrix是相机坐标系的变换矩阵 最后我们将y值乘以1.4得到了一个形如鸡蛋的几何体
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position.x, position.y * 1.4, position.z, 1.0 );
    }
    `,
    fragmentShader: `
        //片元着色器同样需要定义varying vec3 vNormal；
    varying vec3 vNormal;
    void main() {
                //vNormal是一个已经归一化的三维向量
        float pr = (vNormal.x + 1.0) / 2.0; //pr红色通道值范围为0~1
        float pg = (vNormal.y + 1.0) / 2.0; //pg绿色通道值范围为0~1
        float pb = (vNormal.z + 1.0) / 2.0; //pb蓝色通道值范围为0~1
        gl_FragColor=vec4(pr, pg, pb, 1.0); //最后设置顶点颜色，点与点之间会自动插值
    }
    `
})
var mesh = new THREE.Mesh(geom, mate);
scene.add(mesh)
```

### 着色器学习资源推荐（glsl）
https://thebookofshaders.com/02/?lan=ch
https://www.wenjiangs.com/docs/webgl-introduction
