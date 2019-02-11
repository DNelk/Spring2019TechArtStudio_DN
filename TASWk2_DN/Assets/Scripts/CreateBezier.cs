using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(BezierController))]
public class CreateBezier : Editor
{
    //Create a custom GUI that allows us to create new points on our curve
    public override void OnInspectorGUI()
    {
        BezierController controller = (BezierController) target; //What we're GUI for

        DrawDefaultInspector();

        //Our make curve button
        if (GUILayout.Button("Make Curve"))
        {
            BezierModel newBezier = controller.Model.gameObject.AddComponent<BezierModel>(); //Our new curve

            if (controller.curves.Count > 0) //If our curve list isnt empty
            {
                BezierModel lastBezier = controller.curves[controller.curves.Count - 1]; //Our last curve that we need to link to
                
                //Link the curves
                newBezier.startPoint = lastBezier.endPoint;
                newBezier.endPoint = lastBezier.endPoint;
                newBezier.startTangent = lastBezier.endPoint;
                newBezier.endTangent = lastBezier.endPoint;

            }
            newBezier.RecalculateLinearDist();
            controller.curves.Add(newBezier); //Add it to our list
        }
        
        if (GUILayout.Button("Recalculate linear distance"))
            foreach (BezierModel b in controller.curves)
                b.RecalculateLinearDist();
    }
}
