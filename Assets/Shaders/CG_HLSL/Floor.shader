Shader "Sara/CG/Floor" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Gamma ("Gamma", Range(0, 1)) = 0

        [IntRange] _Sections ("Sections", Range(2, 10)) = 5
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

            float _Sections;
            float _Gamma;

            VertexOutput vert (VertexInput vertexInput) {
                VertexOutput vertexOutput;

                vertexOutput.vertex = UnityObjectToClipPos(vertexInput.vertex);
                vertexOutput.uv = TRANSFORM_TEX(vertexInput.uv, _MainTex);
                UNITY_TRANSFER_FOG(vertexOutput,vertexOutput.vertex);
                
                return vertexOutput;
            }

            

            fixed4 frag (VertexOutput vertexData) : SV_Target {
                
                float flooredY = floor(vertexData.uv.y * _Sections) * (_Sections / 100.0);
                
                return float4(flooredY.xxx, 1) * _Gamma;
            }
            
            ENDCG
        }
    }
}
