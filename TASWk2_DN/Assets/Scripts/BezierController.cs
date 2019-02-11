using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
//[ExecuteInEditMode]
public class BezierController : MonoBehaviour
{
    //Our stuff in the scene
    //public GameObject Marker; //The marker for each point
    //public BezierModel Bezier; // Our Bezier
    public Transform Model; //The Model
    public Transform View; //The View

    /*Flyover stuff*/
    public Transform flyingCamera; //The camera we're gonna fly
    private float distance; //How far are we 
    private float percentage; //How much have we come
    private Vector3 lastPos; //Last position of the camera
    public float speed; //Camera speed
    private int curveIndex; //What curve we're on
    private float t; //Current scalar position 
    //Where we store our beziers
    public List<BezierModel> curves = new List<BezierModel>();
   
    //Move the camera around
    void Update()
    {
        distance = Time.deltaTime * speed;
        percentage = curves[curveIndex].GetPercentageByDistance(distance);
        //Overtravel check
        if (t + percentage > 1)
        {
            float percentageLeft = 1 - t;
            float distanceLeft = curves[curveIndex].GetDistanceByPercentage(percentageLeft);
            float distanceCarryover = distance - distanceLeft;

            curveIndex++;
            if (curveIndex > curves.Count - 1)
                curveIndex = 0;

            t = curves[curveIndex].GetPercentageByDistance(distanceCarryover);
        }
        else
            t += percentage;

        Vector3 placeOnTrack = curves[curveIndex].GetPositionOnPath(t); //Where are we on the curve
        lastPos = flyingCamera.position; //Save position
        flyingCamera.position = placeOnTrack; //Move cam
        flyingCamera.rotation = Quaternion.Slerp(flyingCamera.rotation, Quaternion.LookRotation((placeOnTrack - lastPos), Vector3.up), 0.05f );
        

    }
/*
    private void createCurve()
    {
        //Put a marker on all our points in the curve
        for (int i = 0; i < curves.Count; i++)
        {
            float t = (float) i / 100;
            Vector3 points = CalculateBezier(Bezier, t);
            Instantiate(Marker, points, Quaternion.identity, View);
        }
    }*/

    Vector3 CalculateBezier(BezierModel curve, float t)
    {
        //Lerp between a bunch of points and segments to get the bezier between them
        Vector3 a = curve.startPoint;
        Vector3 b = curve.startTangent;
        Vector3 c = curve.endTangent;
        Vector3 d = curve.endPoint;

        Vector3 ab = Vector3.Lerp(a, b, t);
        Vector3 bc = Vector3.Lerp(b, c, t);
        Vector3 cd = Vector3.Lerp(c, d, t);

        Vector3 abc = Vector3.Lerp(ab, bc, t);
        Vector3 bcd = Vector3.Lerp(bc, cd, t);

        return Vector3.Lerp(abc, bcd, t);
    }
}
