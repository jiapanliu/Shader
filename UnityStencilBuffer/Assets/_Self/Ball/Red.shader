// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Red" {  
    SubShader {  
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass {  
            Stencil {  
                Ref 2                     //�ο�ֵΪ2��stencilBufferֵĬ��Ϊ0  
                Comp always               //stencil�ȽϷ�ʽ����Զͨ��  
                Pass replace              //pass�Ĵ������滻��������2�滻buffer ��ֵ  
                ZFail decrWrap            //ZFail�Ĵ���������ͼ�1  
            }  
        // stencil��Zbuffer��ͨ���Ļ���ִ�С��ѵ���Ⱦ�ɺ�ɫ��  
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