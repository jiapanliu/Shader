// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Green" {  
    SubShader {  
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}  //��Ⱦ����ΪGeometry+1���ں���֮��  
        Pass {  
            Stencil {  
                Ref 2                 //�ο�ֵΪ2  
                Comp equal            //stencil�ȽϷ�ʽ����ͬ��ֻ�е���2�Ĳ���ͨ��  
                Pass keep           //stencil��Zbuffer������ͨ��ʱ��ѡ�񱣳�  
                Fail decrWrap        //stencilûͨ����ѡ������ͼ�1�����Ա�ƽ�浲ס���ǲ�stencilֵ�ͱ��254  
                ZFail keep           //stencilͨ������Ȳ���ûͨ��ʱ��ѡ�񱣳�  
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
                return half4(0,1,0,1);  
            }  
            ENDCG  
        }  
    }
}  