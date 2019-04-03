// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bird"
{
	Properties
	{
		_Amplitude("Amplitude", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_Frequency("Frequency", Float) = 0
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_PositionalOffset("Positional Offset", Float) = 0
		_PositionalAmplitudeScalar("Positional Amplitude Scalar", Float) = 0
		_RedColorMult("Red Color Mult", Float) = 50
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
		uniform float _RedColorMult;
		uniform float _AmplitudeOffset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_27_0 = abs( ase_vertex3Pos.x );
			float4 appendResult12 = (float4(0.0 , ( ( _Amplitude * sin( ( ( ( _Time.y * -1 ) * _Frequency ) + _TimeOffset + ( temp_output_27_0 * _PositionalOffset ) ) ) * ( temp_output_27_0 * _PositionalAmplitudeScalar ) * ( v.color.r * temp_output_27_0 * _RedColorMult ) ) + _AmplitudeOffset ) , 0.0 , 0.0));
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
-422;478;1440;505;2184.048;702.3344;2.233628;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-775.615,-538.9823;Float;False;902.428;980.7135;Scale and offset y axis;4;5;7;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-700.0963,38.34902;Float;False;514.89;333.3265;Scale Vertex Y Position;4;14;13;15;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-706.7142,-422.0816;Float;False;467.7064;402.8171;Scale and Offset Time Input;4;6;8;2;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-686.6871,89.88829;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-693.6014,-342.0548;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-569.9683,264.7465;Float;False;Property;_PositionalOffset;Positional Offset;4;0;Create;True;0;0;False;0;0;13.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;27;-477.3175,92.22993;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-602.8963,-217.7071;Float;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;False;0;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;29;-526.6963,-336.0193;Float;False;-1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-362.2726,-337.4015;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-565.1608,-116.9545;Float;False;Property;_TimeOffset;Time Offset;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-317.4038,112.5385;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-503.3469,628.9109;Float;False;587.3693;301.67;Uses Distance from origin as scalar multiplier;2;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;227.0433,-339.5325;Float;False;449.459;483.6917;Scale and offset sin output;4;3;4;11;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-200.3759,-153.6379;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;185.013,-655.6965;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;211.0273,-480.5156;Float;False;Property;_RedColorMult;Red Color Mult;6;0;Create;True;0;0;False;0;50;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-474.3973,827.2699;Float;False;Property;_PositionalAmplitudeScalar;Positional Amplitude Scalar;5;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;264.3447,-286.8893;Float;False;Property;_Amplitude;Amplitude;0;0;Create;True;0;0;False;0;0;3.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-42.33767,-153.836;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-120.3867,754.1359;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;429.0273,-593.9736;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;354.3219,-138.4759;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;340.1848,32.54214;Float;False;Property;_AmplitudeOffset;Amplitude Offset;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;546.1197,-145.476;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;914.1478,-409.4982;Float;False;473.5026;470.9959;Apply to x axis;2;0;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;940.5441,-225.8696;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1131.602,-366.413;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Bird;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;13;1
WireConnection;29;0;2;0
WireConnection;9;0;29;0
WireConnection;9;1;8;0
WireConnection;15;0;27;0
WireConnection;15;1;14;0
WireConnection;7;0;9;0
WireConnection;7;1;6;0
WireConnection;7;2;15;0
WireConnection;5;0;7;0
WireConnection;22;0;27;0
WireConnection;22;1;21;0
WireConnection;25;0;24;1
WireConnection;25;1;27;0
WireConnection;25;2;26;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;22;0
WireConnection;4;3;25;0
WireConnection;11;0;4;0
WireConnection;11;1;10;0
WireConnection;12;1;11;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=DE01E6E4059FFEEE3A4E235CF36BFBA2BBEE4E48