Shader "Sara/CG/Ceil" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Zoom ("Zoom", Range(0, 1)) = 0
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

            VertexOutput vert (VertexInput vertexInput) {
                VertexOutput vertexOutput;

                vertexOutput.vertex = UnityObjectToClipPos(vertexInput.vertex);
                vertexOutput.uv = TRANSFORM_TEX(vertexInput.uv, _MainTex);
                UNITY_TRANSFER_FOG(vertexOutput,vertexOutput.vertex);
                
                return vertexOutput;
            }

            /*
                ceil returns highest round value, it can be used to create a zoom
                (e.g.):
                    ceil(0.1) = 1
                    ceil(0.3) = 1
                    ceil(1.7) = 2
                    ceil(1.1) = 2
            */

            float _Zoom;

            fixed4 frag (VertexOutput vertexData) : SV_Target {

                float u = ceil(vertexData.uv.x) * 0.5; // uv.x center
                float v = ceil(vertexData.uv.y) * 0.5; // uv.y center

                float uLerp = lerp(u, vertexData.uv.x, _Zoom);
                float vLerp = lerp(v, vertexData.uv.y, _Zoom);
                
                fixed4 textureColor = tex2D(_MainTex, float2(uLerp, vLerp));
                UNITY_APPLY_FOG(vertexData.fogCoord, textureColor);

                return textureColor;
            }
            
            ENDCG
        }
    }
}
