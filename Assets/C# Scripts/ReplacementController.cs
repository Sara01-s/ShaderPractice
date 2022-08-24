using UnityEngine;

namespace SaraShaders {

    [ExecuteInEditMode]
    public class ReplacementController : MonoBehaviour {
        
        // replacement shader
        [SerializeField] private Shader _replacementShader;

        private void OnEnable() {

            if (_replacementShader != null) {
                
                GetComponent<Camera>().SetReplacementShader(
                    _replacementShader, "RenderType"
                );                
            }
        }

        private void OnDisable() {
            GetComponent<Camera>().ResetReplacementShader();
        }
    }
}
