Shader "Ayy/CmdBufTest1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
                //圆形：半径   渐变   中心点偏移
        _Radius("Radius",Range(0,1.0))=0.1
        _Gradient("Gradient",Range(0,1.0))=0.1
        _CenterOffsetX("CenterOffsetX",Range(0,1.0))=0.1
        _CenterOffsetY("CenterOffsetY",Range(0,1.0))=0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent+100"}
        LOD 100

        Pass
        {
            ZWrite Off
            
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members screenPos)
// #pragma exclude_renderers d3d11
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


                float4 screenPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Radius;
            float _Gradient;
            float _CenterOffsetX;
            float _CenterOffsetY;

            
            sampler2D _Ayy_GrabTexture;

                        //圆形
            float CircleShape(fixed2 uv,fixed4 imgCol){
                float pointX=uv.x-_CenterOffsetX;
                float pointY=uv.y-_CenterOffsetY;
                float sq = sqrt(pointX * pointX + pointY * pointY);
                float blendFactor = smoothstep(_Radius,_Radius - _Gradient,sq);
                //return lerp(fixed4(1.0,1.0,1.0,1.0),imgCol, blendFactor);
                return blendFactor;
            }

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
                fixed4 col = tex2D(_Ayy_GrabTexture,i.uv);
                clip(CircleShape(i.uv,col)-0.1);
                return col;
            }
            ENDCG
        }
    }
}
