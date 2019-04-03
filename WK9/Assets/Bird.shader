// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bird"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Amplitude("Amplitude", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_Frequency("Frequency", Float) = 0
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_PositionalOffset("Positional Offset", Float) = 0
		_PositionalAmplitudeScalar("Positional Amplitude Scalar", Float) = 0
		_positionScale("positionScale", Float) = 0
		_Albedo("Albedo", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Amplitude;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float _PositionalOffset;
		uniform float _PositionalAmplitudeScalar;
		uniform float _AmplitudeOffset;
		uniform float4 _Albedo;
		uniform float _positionScale;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_27_0 = abs( ase_vertex3Pos.x );
			float4 appendResult12 = (float4(0.0 , ( ( _Amplitude * sin( ( ( ( _Time.y * -1 ) * _Frequency ) + _TimeOffset + ( temp_output_27_0 * _PositionalOffset ) ) ) * ( temp_output_27_0 * _PositionalAmplitudeScalar ) ) + _AmplitudeOffset ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult12.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Albedo.rgb;
			o.Alpha = 1;
			float3 objToWorld36 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform37 = mul(unity_ObjectToWorld,float4( ( ase_vertex3Pos * _positionScale ) , 0.0 ));
			float simplePerlin2D32 = snoise( ( float4( objToWorld36 , 0.0 ) + transform37 ).xy );
			clip( simplePerlin2D32 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
395;397;1440;393;993.3525;27.57903;1.759243;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-775.615,-538.9823;Float;False;902.428;980.7135;Scale and offset y axis;4;5;7;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-700.0963,38.34902;Float;False;514.89;333.3265;Scale Vertex Y Position;4;14;13;15;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-706.7142,-422.0816;Float;False;467.7064;402.8171;Scale and Offset Time Input;5;6;8;2;9;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-686.6871,89.88829;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-693.6014,-342.0548;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-569.9683,264.7465;Float;False;Property;_PositionalOffset;Positional Offset;5;0;Create;True;0;0;False;0;0;13.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;27;-477.3175,92.22993;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-602.8963,-217.7071;Float;False;Property;_Frequency;Frequency;3;0;Create;True;0;0;False;0;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;29;-526.6963,-336.0193;Float;False;-1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-315.7918,-1062.401;Float;False;1147.84;440.1756;Noise Filter;6;32;35;37;31;30;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-362.2726,-337.4015;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-565.1608,-116.9545;Float;False;Property;_TimeOffset;Time Offset;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-317.4038,112.5385;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-162.965,486.1701;Float;False;587.3693;301.67;Uses Distance from origin as scalar multiplier;2;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-268.6816,-811.1736;Float;False;Property;_positionScale;positionScale;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-200.3759,-153.6379;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;227.0433,-339.5325;Float;False;449.459;483.6917;Scale and offset sin output;4;3;4;11;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-134.0154,684.5293;Float;False;Property;_PositionalAmplitudeScalar;Positional Amplitude Scalar;6;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;264.3447,-286.8893;Float;False;Property;_Amplitude;Amplitude;1;0;Create;True;0;0;False;0;0;3.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-42.33767,-153.836;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;219.9951,611.3954;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-34.84803,-854.6229;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;36;138.0826,-1008.785;Float;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;37;116.2562,-831.479;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;368.2339,-138.4759;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;340.1848,32.54214;Float;False;Property;_AmplitudeOffset;Amplitude Offset;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;914.1478,-409.4982;Float;False;473.5026;470.9959;Apply to x axis;2;0;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;446.4106,-878.9567;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;559.1714,-145.476;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;940.5441,-225.8696;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;642.0102,-841.5441;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;930.6917,-814.0979;Float;False;Property;_Albedo;Albedo;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1131.602,-366.413;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Bird;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;30;0;13;0
WireConnection;30;1;31;0
WireConnection;37;0;30;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;22;0
WireConnection;35;0;36;0
WireConnection;35;1;37;0
WireConnection;11;0;4;0
WireConnection;11;1;10;0
WireConnection;12;1;11;0
WireConnection;32;0;35;0
WireConnection;0;0;39;0
WireConnection;0;10;32;0
WireConnection;0;11;12;0
ASEEND*/
//CHKSM=A3399206AB7A038F572135A999103A99CEDC699C