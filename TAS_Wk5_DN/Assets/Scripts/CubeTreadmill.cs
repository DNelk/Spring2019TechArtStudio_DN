using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeTreadmill : MonoBehaviour
{
    public GameObject Cube;
    public List<GameObject> Cubes;
    
    public GameObject Target;

    private Vector3 intPos;
    private Vector3 currIntPos;
    private Vector3 oldIntPos;
    // Start is called before the first frame update
    void Start()
    {
        Cubes = new List<GameObject>();
        for (int j = 0; j < 2; j++)
        {
            for (int k = 0; k < 2; k++)
            {
                Cubes.Add(Instantiate(Cube, new Vector3(j, 0, k), Quaternion.identity));
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        intPos = new Vector3(Mathf.Floor(Target.transform.position.x), 0, Mathf.Floor(Target.transform.position.z));

        if (intPos != oldIntPos)
        {
            if (intPos.x > oldIntPos.x)
            {
                foreach (GameObject g in Cubes)
                {
                    g.transform.position += Vector3.right;
                }
            }
            
            if (intPos.x < oldIntPos.x)
            {
                foreach (GameObject g in Cubes)
                {
                    g.transform.position -= Vector3.right;
                }
            }
            
            if (intPos.z > oldIntPos.z)
            {
                foreach (GameObject g in Cubes)
                {
                    g.transform.position += Vector3.forward;
                }
            }
            
            if (intPos.z < oldIntPos.z)
            {
                foreach (GameObject g in Cubes)
                {
                    g.transform.position -= Vector3.forward;
                }
            }

            oldIntPos = intPos;
        }
    }
}
