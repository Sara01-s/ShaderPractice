Shader "Sara/SubShader/Cull"
{
    Properties
    {
        _FrontTex ("Front Texture", 2D) = "white" {}
        _BackTex ("Back Texture", 2D) = "red" {}

        [Enum(UnityEngine.Rendering.CullMode)]
            _Cull ("Cull mode", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        // We can use Cull to control which face of a polygon is goint to be removed
        // in the pixel depth processing 

        // Cull Off (Both faces of the polygon are rendered (Back and Front))
        // Cull Back (The back faces of the polygon are renderer)
        // Cull Front (The front faces of the polygon are renderer)

        // Example of cull using a property
        Cull [_Cull]

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

            sampler2D _FrontTex;
            sampler2D _BackTex;
            float4 _FrontTex_ST;
            float4 _BackTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _FrontTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // using a boolean SV_isFrontFace we can project different colors and textures
            // on both faces
            fixed4 frag (v2f i, bool face : SV_IsFrontFace) : SV_Target
            {
                // sample the texture
                fixed4 frontColor = tex2D(_FrontTex, i.uv);
                fixed4 backColor = tex2D(_BackTex, i.uv);
                
                return face ? frontColor : backColor;
            }
            ENDCG
        }
    }
}
