Shader "Unlit/Quad"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StencilRefValue("StencilRefValue",Range(0,255))=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        LOD 100

        ZWrite Off

        Pass
        {
            Stencil {  
                Ref [_StencilRefValue]                    //参考值为2，stencilBuffer值默认为0  
                Comp always               //stencil比较方式是永远通过  
                Pass replace              //pass的处理是替换，就是拿2替换buffer 的值  
                //ZFail decrWrap            //ZFail的处理是溢出型减1  
            }  

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
