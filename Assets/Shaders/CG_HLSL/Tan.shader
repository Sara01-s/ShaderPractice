Shader "Sara/CG/Tan" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _Sections ("Sections", Range(2, 10)) = 10
    }

    SubShader {

        // Added transparency
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent" 
        }

        Blend SrcAlpha OneMinusSrcAlpha
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

            float4 _Color;
            float _Sections;

            fixed4 frag (VertexOutput vertexData) : SV_Target {
                
                fixed4 tanColor = clamp(0, abs(tan((vertexData.uv.y - _Time) * _Sections)), 1);
                tanColor *= _Color;

                fixed4 textureColor = tex2D(_MainTex, vertexData.uv) * tanColor;

                UNITY_APPLY_FOG(vertexData.fogCoord, textureColor);

                return textureColor;
            }
            
            ENDCG
        }
    }
}
