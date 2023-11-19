Shader "Unlit/CommandBufferBaseShader"
{
        Properties
    {
        _NoiseTex ("Texture", 2D) = "white" {}
        
        _DistortionFactor ("distorion factor", Range (0,1)) = 0.1
        _TimeScale ("time scale", Range (0,3)) = 0.2
    }
    SubShader
    {
        Tags { "Queue"="Transparent"}
        LOD 100

        Pass
        {
            ZWrite Off
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };
            
            sampler2D _Ayy_GrabTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.vertex)/o.vertex.w;
                return o;
            }

             fixed4 frag (v2f i) : SV_Target
             {
                 float2 screenUV = i.screenPos.xy;
                 fixed4 col = tex2D(_Ayy_GrabTexture,screenUV);
                 col *= fixed4(1.0,0.0,0.0,0.5);
                 return col;
             }

            ENDCG
        }
    }
}
