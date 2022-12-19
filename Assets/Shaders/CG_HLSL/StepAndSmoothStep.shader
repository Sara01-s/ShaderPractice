Shader "Sara/CG/StepAndSmoothStep" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
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

            fixed4 frag (VertexOutput vertexData) : SV_Target {
                // values below the edge return 0, values above the edge return 1
                float edge = 0.5;     // Color edge
                fixed3 stepValue = 0; // Return to RGB
                float smooth = 0.1;

                //stepValue = step(edge, vertexData.uv.y);
                stepValue = smoothstep((vertexData.uv.y - smooth), (vertexData.uv.y + smooth), edge);

                return fixed4(stepValue, 1);;
            }
            
            ENDCG
        }
    }
}
