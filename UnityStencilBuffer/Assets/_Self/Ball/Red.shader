// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Red" {  
    SubShader {  
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass {  
            Stencil {  
                Ref 2                     //参考值为2，stencilBuffer值默认为0  
                Comp always               //stencil比较方式是永远通过  
                Pass replace              //pass的处理是替换，就是拿2替换buffer 的值  
                ZFail decrWrap            //ZFail的处理是溢出型减1  
            }  
        // stencil和Zbuffer都通过的话就执行。把点渲染成红色。  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            struct appdata {  
                float4 vertex : POSITION;  
            };  
            struct v2f {  
                float4 pos : SV_POSITION;  
            };  
            v2f vert(appdata v) {  
                v2f o;  
                o.pos = UnityObjectToClipPos(v.vertex);  
                return o;  
            }  
            half4 frag(v2f i) : SV_Target {  
                return half4(1,0,0,1);  
            }  
            ENDCG  
        }  
    }
}  