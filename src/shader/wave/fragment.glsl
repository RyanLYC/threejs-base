 precision lowp float;
 varying vec2 vUv;
 varying float vElevation;

 // 传入的纹理
uniform sampler2D uTexture;

 void main(){
    // gl_FragColor = vec4(vUv,0.0,1.0);
    float deep = vElevation + 0.05 * 20.0;
    // gl_FragColor = vec4(deep * 1.0,0.0,0.0,1.0);

    // 根据uv取出对应的颜色
    vec4 textureColor = texture2D(uTexture, vUv);
    textureColor.rgb *= deep;
    gl_FragColor = textureColor;
}
