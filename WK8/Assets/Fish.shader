// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fish"
{
	Properties
	{
		_Amplitude("Amplitude", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_Frequency("Frequency", Float) = 0
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_PositionalOffset("Positional Offset", Float) = 0
		_PositionalAmplitudeScalar("Positional Amplitude Scalar", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _Amplitude;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float _PositionalOffset;
		uniform float _PositionalAmplitudeScalar;
		uniform float _AmplitudeOffset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult12 = (float4(( ( _Amplitude * sin( ( ( _Time.y * _Frequency ) + _TimeOffset + ( ase_vertex3Pos.y * _PositionalOffset ) ) ) * ( ase_vertex3Pos.y * _PositionalAmplitudeScalar ) ) + _AmplitudeOffset ) , 0.0 , 0.0 , 0.0));
			v.vertex.xyz += appendResult12.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
0;23;1440;788;1337.928;525.0458;1.718241;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-775.615,-538.9823;Float;False;902.428;980.7135;Scale and offset y axis;4;5;7;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-706.7142,-422.0816;Float;False;467.7064;402.8171;Scale and Offset Time Input;4;6;8;2;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-701.8564,38.34902;Float;False;514.89;333.3265;Scale Vertex Y Position;3;14;13;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-602.8963,-217.7071;Float;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;False;0;0;9.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-586.3873,-375.5594;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-664.998,89.88829;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-571.7284,264.7465;Float;False;Property;_PositionalOffset;Positional Offset;4;0;Create;True;0;0;False;0;0;6.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-473.5751,461.6302;Float;False;587.3693;301.67;Uses Distance from origin as scalar multiplier;2;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-338.9048,112.5385;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-415.8798,-283.7942;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-565.1608,-116.9545;Float;False;Property;_TimeOffset;Time Offset;1;0;Create;True;0;0;False;0;0;3.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;163.4336,-335.1456;Float;False;449.459;483.6917;Scale and offset sin output;4;3;4;11;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-200.3759,-153.6379;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-444.6251,659.9894;Float;False;Property;_PositionalAmplitudeScalar;Positional Amplitude Scalar;5;0;Create;True;0;0;False;0;0;8.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;200.7349,-282.5024;Float;False;Property;_Amplitude;Amplitude;0;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-42.33767,-153.836;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-90.61417,586.8554;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;276.575,36.92902;Float;False;Property;_AmplitudeOffset;Amplitude Offset;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;290.7121,-134.089;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;655.322,-405.1113;Float;False;473.5026;470.9959;Apply to x axis;2;0;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;482.5098,-141.0891;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;681.7183,-221.4827;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;872.7758,-362.0261;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Fish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;2
WireConnection;15;1;14;0
WireConnection;9;0;2;0
WireConnection;9;1;8;0
WireConnection;7;0;9;0
WireConnection;7;1;6;0
WireConnection;7;2;15;0
WireConnection;5;0;7;0
WireConnection;22;0;13;2
WireConnection;22;1;21;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;22;0
WireConnection;11;0;4;0
WireConnection;11;1;10;0
WireConnection;12;0;11;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=E571292AE06A4C87B99656098C155AFBDB5505E6