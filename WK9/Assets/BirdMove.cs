using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BirdMove : MonoBehaviour
{
    public float velMag;

    private MeshRenderer myMeshR;
    
 // Start is called before the first frame update
    void Start()
    {
        myMeshR = GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        foreach (Material m in myMeshR.materials)
        {
            m.SetFloat("_Cutoff", Mathf.Sin(Time.time));
        }
    }
}
