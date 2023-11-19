Shader "LaJiPan/BaseShapeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //圆形：半径   渐变   中心点偏移
        _Radius("Radius",Range(0,1.0))=0.1
        _Gradient("Gradient",Range(0,1.0))=0.1
        _CenterOffsetX("CenterOffsetX",Range(0,1.0))=0.1
        _CenterOffsetY("CenterOffsetY",Range(0,1.0))=0.1
        
        //圆形拓展——边缘扰动
        _MaxOffset("MaxOffset",Range(0,1.0))=0.1
        _CircleNoiseCount("CircleNoiseCount",Int)=5

       //环形：环的宽度  环之间的间距（这里的间距以UV为基础）   环移动的速度
       _RingWidth("RingWidth",Range(0,1.0))=0.1
       _RingCount("_RingCount",int)=1
       _RingMulMoveSpeed("RingMulMoveSpeed",float)=1.0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
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
            float _Radius;
            float _Gradient;
            float _CenterOffsetX;
            float _CenterOffsetY;
            float _MaxOffset;
            int _CircleNoiseCount;
            float _RingWidth;
            int _RingCount;
            float _RingMulMoveSpeed;
            float _CurRingDis;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }



            //圆形
            fixed4 CircleShape(fixed2 uv,fixed4 imgCol){
                float pointX=uv.x-_CenterOffsetX;
                float pointY=uv.y-_CenterOffsetY;
                float sq = sqrt(pointX * pointX + pointY * pointY);
                float blendFactor = smoothstep(_Radius,_Radius - _Gradient,sq);
                return lerp(fixed4(1.0,1.0,1.0,1.0),imgCol, blendFactor);
            }

            //圆形拓展——边缘扰动
            fixed4 CircleNoiseShape(fixed2 uv,fixed4 imgCol){
                float pointX=uv.x-_CenterOffsetX;
                float pointY=uv.y-_CenterOffsetY;
                float sq = sqrt(pointX * pointX + pointY * pointY);
                float rad = atan2(pointY,pointX);
                float offset = sin(rad * _CircleNoiseCount) * _MaxOffset;
                float blendFactor = smoothstep(_Radius + offset,_Radius - _Gradient + offset,sq);
                return lerp(imgCol,fixed4(1.0,1.0,1.0,1.0),blendFactor);
            }

            //环形(单个静态)
            fixed4 CircleRing(fixed2 uv,fixed4 imgCol){
                    half l = length(uv - 0.5);
                    float s1 = smoothstep(_Radius-_RingWidth/2, _Radius, l);
                    float s2 = smoothstep(_Radius, _Radius+_RingWidth/2, l);
                    return lerp(imgCol,fixed4(1.0,1.0,1.0,1.0), s1 - s2);
            }

            //环形（多个、动态）
            fixed4 CircleRingMulDynamics(fixed2 uv,fixed4 imgCol){
                float pointX=uv.x-_CenterOffsetX;
                float pointY=uv.y-_CenterOffsetY;
                float sq = sqrt(pointX * pointX + pointY * pointY);
                float aaa=abs(sin((sq-_Time.y*_RingMulMoveSpeed)*_RingCount));
                return lerp(fixed4(imgCol.xyz,1),fixed4(1.0,1.0,1.0,1.0),aaa);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                //return col;
                //圆形
                //return CircleShape(i.uv.xy,col);

                //圆形拓展——边缘扰动
                //return CircleNoiseShape(i.uv.xy,col);
            
                //环形(单个静态)
                //return CircleRing(i.uv.xy,col);
            
                //环形（多个动态）
                return CircleRingMulDynamics(i.uv.xy,col);
            }


            ENDCG
        }
    }
}
