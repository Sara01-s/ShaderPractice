Shader "Sara/SubShader/ZTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        // ZTest controls how  Despth Testing is done, and is generally used in multi-pass
        // shader to generate differences in colors and depths. This property has 7 values:

        // Less      (<)   (Draw obj in front, ignores objects with same Z or behind)
        // Greater   (>)   (Draws the objects behind, doesn't draw objects with same Z or in front)
        // LEqual    (<=)  (DEFAULT VALUE, draws objects in front or same Z, but doesn't draw objects behind)
        // GEqual    (>=)  (Draws objects behind or at the same distance, doesn't draw objects in front)
        // Equal     (==)  (Draws objects at the same distance)
        // Not Equal (!=)  (Draws objects that are not at the same distance)
        // Always          (Draw all pixels, always).

        // This values correspond to a comparision operation.

        // ZTest LEqual (Default value)

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
