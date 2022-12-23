using UnityEngine;

namespace SaraShaders {

    public class ColorCompute : MonoBehaviour {

        [SerializeField] private ComputeShader _colorComputeShader;
        [SerializeField] private Texture _sampleTexture;

        private RenderTexture _mainTexture;
        private int _textureSize = 256;
        private Renderer _renderer;

        private void Awake() {
            _mainTexture = new RenderTexture(_textureSize, _textureSize, 0, RenderTextureFormat.ARGB32);

            _mainTexture.enableRandomWrite = true;  // Allow random pre-write
            _mainTexture.Create();                  // creates the texture in advance since Unity creates it once it's called

            _renderer = GetComponent<Renderer>();
            _renderer.enabled = true;

            var kernelIndex = 0;                    // CSMain is the first declared function, therefore it's kernelIndex is 0
            var RWTexture = "ComputeResult";        // float4 Read-Write Texture2D in CShader is declared as "Result"
            _colorComputeShader.SetTexture(kernelIndex, RWTexture, _mainTexture);   // Send texture to CShader
            _colorComputeShader.SetTexture(kernelIndex, "TextureColor", _sampleTexture);
            _renderer.material.SetTexture("_MainTex", _mainTexture);                // Send texture back to renderer

            // Actually generate thread group (see: numthreads in CShader) (tex / 8 = 32)
            // We will use a thread grid of 32x32x1
            _colorComputeShader.Dispatch(kernelIndex, _textureSize / 8, _textureSize / 8, 1);

        }
    }
}
