Shader "Sara/CG/Lerp" {

    Properties {
        _Tex01 ("Texture 1", 2D) = "white" {}
        _Tex02 ("Texture 2", 2D) = "white" {}
        _Lerp ("Lerp", Range(0, 1)) = 0.5
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
                float2 tex01UV : TEXCOORD0;
                float2 tex02UV : TEXCOORD1;
            };

            struct VertexOutput {
                float4 vertex : SV_POSITION;
                float2 tex01UV : TEXCOORD0;
                float2 tex02UV : TEXCOORD1;
                UNITY_FOG_COORDS(1)
            };

            sampler2D _Tex01;
            sampler2D _Tex02;
            float4 _Tex01_ST;
            float4 _Tex02_ST;
            float _Lerp;


            VertexOutput vert (VertexInput vertexInput) {
                VertexOutput vertexOutput;

                vertexOutput.vertex = UnityObjectToClipPos(vertexInput.vertex);
                vertexOutput.tex01UV = TRANSFORM_TEX(vertexInput.tex01UV, _Tex01);
                vertexOutput.tex02UV = TRANSFORM_TEX(vertexInput.tex02UV, _Tex02);

                UNITY_TRANSFER_FOG(vertexOutput,vertexOutput.vertex);
                
                return vertexOutput;
            }

            fixed4 frag (VertexOutput vertexData) : SV_Target {
                
                fixed4 tex01Color = tex2D(_Tex01, vertexData.tex01UV);
                fixed4 tex02Color = tex2D(_Tex02, vertexData.tex02UV);
                
                UNITY_APPLY_FOG(vertexData.fogCoord, textureColor);

                return fixed4(lerp(tex01Color, tex02Color, _Lerp));
            }
            
            ENDCG
        }
    }
}
