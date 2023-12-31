// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Blue" {  
    SubShader {  
        Tags { "RenderType"="Opaque" "Queue"="Geometry+2"}  //渲染次序为Geometry+2,在前面两个shader之后  
        Pass {  
            Stencil {  
                Ref 254          //参考值为254  
                Comp equal         //比较方式是是否相等,即只会渲染
            }  

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
                return half4(0,0,1,1);  
            }  
            ENDCG  
        }  
    }
}  