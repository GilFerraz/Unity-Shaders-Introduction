﻿Shader "Faxime/Introduction/3. Diffuse Ambient"
{
	Properties
	{
		_DiffuseColor("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor("Ambient Color", Color) = (1.0, 1.0, 1.0, 1.0)
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

			uniform float4 _DiffuseColor;
			uniform float4 _AmbientColor;

			// =============================================================================
			// Structures
			// =============================================================================
	
			struct vertexInput 
			{
				float4 Vertex : POSITION;
				float3 Normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 Position : SV_POSITION;
				float4 Color : COLOR;
			};

			// =============================================================================
			// Vertex Function
			// =============================================================================

			vertexOutput vertex(vertexInput input)
			{
				vertexOutput output;

				// Transforms the vertex position from object space to world space.
				output.Position = mul(UNITY_MATRIX_MVP, input.Vertex);

				// Calculates the light's direction in world space.
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				// Calculates the vertex's surface normal in object space.
				float3 normal = normalize(mul(float4(input.Normal, 0.0), unity_WorldToObject).xyz);

				// Calculates the light's intensity on the vertex.
				float intensity = dot(normal, lightDirection);

				output.Color = max(float4(_DiffuseColor.xyz * intensity, 1.0), float4(_AmbientColor.xyz, 1.0));

				return output;
			}

			// =============================================================================
			// Fragment Function
			// =============================================================================

			float4 fragment(vertexOutput input) : COLOR
			{
				return input.Color;
			}

			ENDCG
		}
	}
}