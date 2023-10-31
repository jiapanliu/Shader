// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Blue" {  
    SubShader {  
        Tags { "RenderType"="Opaque" "Queue"="Geometry+2"}  //��Ⱦ����ΪGeometry+2,��ǰ������shader֮��  
        Pass {  
            Stencil {  
                Ref 254          //�ο�ֵΪ254  
                Comp equal         //�ȽϷ�ʽ���Ƿ����,��ֻ����Ⱦ
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