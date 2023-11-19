Shader "Unlit/CommandBufferHotDistort"
{
      Properties
    {
        _NoiseTex ("Texture", 2D) = "white" {}       
        _DistortionFactor ("distorion factor", Range (0,1)) = 0.1
        _TimeScale ("time scale", Range (0,3)) = 0.2

        //圆形：半径   渐变   中心点偏移
        _Radius("Radius",Range(0,1.0))=0.1
        _Gradient("Gradient",Range(0,1.0))=0.1
        _CenterOffsetX("CenterOffsetX",Range(0,1.0))=0.1
        _CenterOffsetY("CenterOffsetY",Range(0,1.0))=0.1
        _ClipValue("ClipValue",Range(0,1.0))=0.1
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

            sampler2D _NoiseTex;
            float _DistortionFactor;
            float _TimeScale;
                    
            sampler2D _Ayy_GrabTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.vertex)/o.vertex.w;
                return o;
            }

            float _Radius;
            float _Gradient;
            float _CenterOffsetX;
            float _CenterOffsetY;
            float _ClipValue;
            
            //圆形
            float CircleShape(fixed2 uv,fixed4 imgCol){
                float pointX=uv.x-_CenterOffsetX;
                float pointY=uv.y-_CenterOffsetY;
                float sq = sqrt(pointX * pointX + pointY * pointY);
                float blendFactor = smoothstep(_Radius,_Radius - _Gradient,sq);
                return blendFactor;
            }
            
            // Testcase , final result
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.screenPos.xy; 
                float2 noiseUV = uv - frac(_Time.y * _TimeScale);
                float4 noiseCol = tex2D(_NoiseTex,noiseUV);
            
                float2 offset = (noiseCol - 0.5) * _DistortionFactor;
                float2 uv2 = uv + offset;
                fixed4 col = tex2D(_Ayy_GrabTexture,uv2);
                
                clip(CircleShape(uv2,col)-_ClipValue);

                return col;
            }
            ENDCG
        }
    }
}
