using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BezierModel : MonoBehaviour
{
   public Vector3 startPoint;
   public Vector3 endPoint;
   public Vector3 startTangent;
   public Vector3 endTangent;

   public float linearDist; //The linear distance of the curve
   
   //Figure out where a point is at t
   public Vector3 GetPositionOnPath(float t)
   {
      Vector3 a = Vector3.Lerp(startPoint, startTangent, t);
      Vector3 b = Vector3.Lerp(startTangent, endTangent, t);
      Vector3 c = Vector3.Lerp(endTangent, endPoint, t);

      Vector3 ab = Vector3.Lerp(a, b, t);
      Vector3 bc = Vector3.Lerp(b, c, t);

      return Vector3.Lerp(ab, bc, t);
   }

   //Figure out what percentage of the curve a distance is
   public float GetPercentageByDistance(float dist)
   {
      return dist / linearDist;
   }
   
   //Figure out what distance of the curve a a percentage is
   public float GetDistanceByPercentage(float percentage)
   {
      return percentage * linearDist;
   }
   
   //Calculate the linear distance of the curve
   public void RecalculateLinearDist ()
   {
      float dist = 0;

      for (float i = 0; i < 1; i += .01f)
      {
         dist += Vector3.Distance(GetPositionOnPath(i), GetPositionOnPath(i + .01f));
      }

      linearDist = dist;
   }
}
