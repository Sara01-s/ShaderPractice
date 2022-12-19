Shader "Sara/CG/SinAndCos" {

    Properties {
        _MainTex ( "Texture", 2D ) = "white" {}
        _RotationSpeed ( "Rotation Speed", Range( 0, 3 ) ) = 1

        [KeywordEnum(X, Y, Z)]
        _RotationAxis ( "Rotation Axis", Float ) = 0
    }

    SubShader {

        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass {
            CGPROGRAM

            #pragma multi_compile_fog
            #pragma multi_compile _ROTATIONAXIS_X _ROTATIONAXIS_Y ROTATIONAXIS_Z
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
            float _RotationSpeed;

            float3 SinCosRotation ( float3 vertex ) {

                float c = cos( _Time.y * _RotationSpeed );
                float s = sin( _Time.y * _RotationSpeed );

                #if _ROTATIONAXIS_X
                    float3x3 mtrix = float3x3 (
                        1,  0,  0,
                        0,  c, -s,
                        0,  s,  c
                    );
                #elif _ROTATIONAXIS_Y
                    float3x3 mtrix = float3x3 (
                        c,  0,  s,
                        0,  1,  0,
                       -s,  0,  c
                    );
                #elif _ROTATIONAXIS_Z
                    float3x3 mtrix = float3x3 (
                        c, -s,  0,
                        s,  c,  0,
                        0,  0,  1
                    );
                #endif

                return mul(mtrix, vertex);
            }

            VertexOutput vert ( VertexInput vertexInput ) {
                VertexOutput vertexOutput;

                float3 rotationVertex = SinCosRotation( vertexInput.vertex );

                vertexOutput.vertex = UnityObjectToClipPos( rotationVertex );
                vertexOutput.uv = TRANSFORM_TEX( vertexInput.uv, _MainTex );
                UNITY_TRANSFER_FOG( vertexOutput, vertexOutput.vertex );
                
                return vertexOutput;
            }

            fixed4 frag ( VertexOutput vertexData ) : SV_Target {
                
                fixed4 textureColor = tex2D( _MainTex, vertexData.uv );
                UNITY_APPLY_FOG( vertexData.fogCoord, textureColor );

                return textureColor;
            }
            
            ENDCG
        }
    }
}
