Shader "Faxime/Introduction/13. Diffuse Ambient Specular Pixel Texture Reflection (Blinn-Phong)"
{
	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
		_Cubemap ("Reflection Map", Cube) = "white" {}

		_DiffuseColor("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularStrength("Shininess", Range(1.0, 256.0)) = 0.5
	}

	SubShader
	{
		Pass
		{

			CGPROGRAM
									
			// =============================================================================
			// Pragma Directives
			// =============================================================================

			#pragma vertex vertex
			#pragma fragment fragment
						
			// =============================================================================
			// Include Directives
			// =============================================================================

			#include "UnityCG.cginc"

			// =============================================================================
			// Uniform Variables
			// =============================================================================

			uniform sampler2D _MainTexture;
			uniform samplerCUBE _Cubemap;

			uniform float4 _DiffuseColor;
			uniform float4 _SpecularColor;
			uniform float _SpecularStrength;
															
			// =============================================================================
			// Constants
			// =============================================================================

			static const float AmbientFactor = 0.2;
		
			// =============================================================================
			// Structures
			// =============================================================================

			struct vertexInput
			{
				float4 Vertex : POSITION;
				float3 Normal : NORMAL;
				float2 UV : TEXCOORD0;
			};
		
			struct vertexOutput
			{
				float4 Position : SV_POSITION;
				float2 UV : TEXCOORD0;
				float3 Normal : TEXCOORD1;
				float3 ViewDirection : TEXCOORD2;
			};
		
			// =============================================================================
			// Vertex Function
			// =============================================================================

			vertexOutput vertex(vertexInput input)
			{
				vertexOutput output;

				// Transforms the vertex position from object space to world space.
				output.Position = mul(UNITY_MATRIX_MVP, input.Vertex);

				output.UV = input.UV;

				// Calculates the vertex's surface normal in object space.
				output.Normal = normalize(mul(float4(input.Normal, 0.0), unity_WorldToObject).xyz);

				// Calculates the camera's view direction to the vertex.
				output.ViewDirection = normalize(mul(unity_ObjectToWorld, input.Vertex).xyz - _WorldSpaceCameraPos);

				return output;
			}
	
			// =============================================================================
			// Fragment Function
			// =============================================================================
	
			float4 fragment(vertexOutput input) : COLOR
			{
				float specularIntensity = 0.0;

				// Calculates the light's direction in world space.
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

				float3 normal = normalize(input.Normal);
				float3 viewDirection = normalize(input.ViewDirection);

				// Calculates the light's intensity on the vertex.
				float intensity = max(dot(normal, lightDirection), 0.0);

				if (intensity > 0) 
				{
					// Calculates the half vector between the light vector and the view vector.
					float3 h = normalize(lightDirection - viewDirection);

					// Calculates the specular intensity, based on the reflection direction and view direction.
					specularIntensity =  pow(max(dot(normal, h), 0.0), _SpecularStrength);
				}

				// Calculates the reflection's direction, based on the view direction and the surface normal.
				float3 reflectionDirection = reflect(viewDirection, normal);

				// Gets the color of the texture on the current UV coordinates.
				float4 textureColor = tex2D(_MainTexture, input.UV);
				// Gets the color of the cube texture on the current reflection coordinates.
				float4 reflectionColor = texCUBE(_Cubemap, reflectionDirection);

				// Applies a tint to the texture color, based on the passed Diffuse Color.
				fixed4 textureTint = textureColor * _DiffuseColor;
				// Applies a tint to the reflection color, based on the passed Specular Color.
				fixed4 reflectionTint = reflectionColor * _SpecularColor;

				// Calculates the vetex's ambient color, based on its texture tint color.
				fixed4 ambientColor = textureTint * AmbientFactor;

				return max(textureTint * intensity + reflectionTint * specularIntensity, ambientColor);
			}
		
			ENDCG
		}
	}
}
