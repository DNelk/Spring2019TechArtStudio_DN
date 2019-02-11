using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(BezierModel))]
public class DrawBezier : Editor
{
    //Draw the Bezier
    private void OnSceneViewGUI(SceneView sv)
    {
        BezierModel b = target as BezierModel;
        b.startPoint = Handles.PositionHandle(b.startPoint, Quaternion.identity);
        b.endPoint = Handles.PositionHandle(b.endPoint, Quaternion.identity);
        b.startTangent = Handles.PositionHandle(b.startTangent, Quaternion.identity);
        b.endTangent = Handles.PositionHandle(b.endTangent, Quaternion.identity);
        
        Handles.DrawBezier(b.startPoint, b.endPoint, b.startTangent, b.endTangent, Color.red, null, 2f);
    }

    private void OnEnable()
    {
        SceneView.onSceneGUIDelegate += OnSceneViewGUI; //Make our GUI part of the scene
    }

    private void OnDisable()
    {
        SceneView.onSceneGUIDelegate -= OnSceneViewGUI; //Remove our GUI
    }
}
