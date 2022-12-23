Shader "Sara/CG/Frac" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size", Float) = 0
        _Sections ("Sections", Float) = 0
    }

    SubShader {

        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM

            #pragma multi_compile_fog
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Size;
            float _Sections;

            VertexOutput vert (VertexInput vertexInput) {
                VertexOutput vertexOutput;

                vertexOutput.vertex = UnityObjectToClipPos(vertexInput.vertex);
                vertexOutput.uv = TRANSFORM_TEX(vertexInput.uv, _MainTex);
                UNITY_TRANSFER_FOG(vertexOutput,vertexOutput.vertex);
                
                return vertexOutput;
            }

            fixed4 frag (VertexOutput vertexData) : SV_Target {

                vertexData.uv *= _Sections;

                float2 fracUV = frac(vertexData.uv);
                float circle = length(fracUV - 0.5);
                float flooredCircle = floor(_Size / circle);

                return float4(flooredCircle.xxx, 1);
            }
            
            ENDCG
        }
    }
}
