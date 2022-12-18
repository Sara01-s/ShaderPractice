Shader "Sara/CG/Abs" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Rotation ("Rotation", Float) = 0.0
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

            void RotateDegrees_float(float2 uv, float2 center, float rotation, out float2 Out) {
                rotation *= UNITY_PI / 180.0f;
                uv -= center;

                float s = sin(rotation);
                float c = cos(rotation);
                float2x2 rotationMatrix = float2x2(c, -s, s, c);

                rotationMatrix *= 0.5; 
                rotationMatrix += 0.5;
                rotationMatrix = rotationMatrix * 2 - 1;

                uv.xy = mul(uv.yx, rotationMatrix);
                uv += center;

                Out = uv;
            }

            float _Rotation;

            /*
                abs(n) retuns absolute value of n 

                (e.g.):
                    abs(-2) = 2
                    abs(-6) = 6 
                    abs(7) = 7
            */

            fixed4 frag (VertexOutput vertexData) : SV_Target {
                
                float  u = abs(vertexData.uv.x - 0.5);
                float  v = abs(vertexData.uv.y - 0.5);
                float  center = 0.5;
                float2 uv = 0;

                RotateDegrees_float(float2(u, v), center, _Rotation, uv);

                fixed4 textureColor = tex2D(_MainTex, uv);
                UNITY_APPLY_FOG(vertexData.fogCoord, textureColor);

                return textureColor;
            }
            
            ENDCG
        }
    }
}
