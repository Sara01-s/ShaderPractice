Shader "Sara/SubShader/Blending"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Enum(UnityEngine.Rendering.BlendMode)]
            _SrcBlend ("Source Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
            _DstBlend ("Destination Factor", Float) = 1
        
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" }
        // we can use AlphaMask On as an alternative to "RenderType=Transparent"
        // this will make the fourth color channel 'A' acquire the quality of the mask
        // AlphaMask will onle generate integer values (0, 1).
        
        // AlphaMask On
        Blend [_SrcBlend] [_DstBlend]
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
