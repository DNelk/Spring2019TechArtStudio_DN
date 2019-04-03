using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEngine;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;

public class AutoAgentBehavior : MonoBehaviour
{
    public Vector3 moveDir;

    public float maxMoveVelMag;
    public float maxDist = 10;
    public float velMag;
    public Transform myModelTransform;

    [Range(0.0f, 1.0f)] public float ClumpStrength; 
    [Range(0.0f, 1.0f)] public float AlignStrength; 
    [Range(0.0f, 1.0f)] public float AvoidStrength; 
    [Range(0.0f, 1.0f)] public float OriginStrength;

    private MeshRenderer myMR;
    
    // Start is called before the first frame update
    void Start()
    {
        myModelTransform = transform.GetChild(0);
        myMR = myModelTransform.GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        //MoveInDir(moveDir, moveVelMag);
    }
    
    void MoveInDir(Vector3 dir, float mag)
    {
        transform.position += dir * mag * Time.deltaTime;
        myModelTransform.rotation = Quaternion.LookRotation(dir);
    }

    public void PassContexts(Collider[] context)
    {
        List<Collider> contextWithoutMe = new List<Collider>();
        float nearestDist = float.MaxValue;
        foreach (Collider c in context)
        {
            if (c.gameObject != gameObject)
            {
                contextWithoutMe.Add(c);
                float dist = Vector3.Distance(c.transform.position, transform.position);
                if (dist < nearestDist)
                {
                    nearestDist = dist;
                }
            }
        }

        if (contextWithoutMe.Count == 0)
            velMag = 5;
        else
            velMag = (nearestDist / maxDist) * maxMoveVelMag;
        
        foreach (Material m in myMR.materials)
        {
            m.SetFloat("_Frequency", velMag);
        } 
       CalcDir(contextWithoutMe.ToArray());
       MoveInDir(moveDir, velMag);
    }

    private void CalcDir(Collider[] context)
    {
        moveDir = Vector3.Lerp(moveDir,
            Vector3.Normalize(
                ClumpDir(context) * ClumpStrength +
                Align(context) * AlignStrength +
                Avoidance(context) * AvoidStrength +
                MoveTowardsOrigin() * OriginStrength *
                Vector3.Magnitude(transform.position) / 500),
            0.05f);
    }

    Vector3 Align(Collider[] context)
    {
        Vector3 headings = Vector3.zero;

        foreach (Collider c in context)
        {
            headings += c.transform.GetChild(0).forward;
        }

        headings /= context.Length;
        return Vector3.Normalize(headings);
    }

    Vector3 ClumpDir(Collider[] context)
    {
        Vector3 midPoint = Vector3.zero;
        foreach (Collider c in context)
        {
            midPoint += c.transform.position;
        }

        midPoint /= context.Length;

        Vector3 nextDir = midPoint - transform.position;
        
        return Vector3.Normalize(nextDir);
    }

    Vector3 Avoidance(Collider[] context)
    {   
        Vector3 midpoint = Vector3.zero;
        foreach (Collider c in context)
        {
            midpoint += c.transform.position;
        }

        midpoint /= context.Length;

        Vector3 nextDir = midpoint - transform.position;
        
        return -Vector3.Normalize(nextDir);
    }

    Vector3 MoveTowardsOrigin()
    {
        return Vector3.zero - transform.position;
    }
}
