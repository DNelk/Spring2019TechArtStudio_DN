using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CrossProdCalc : MonoBehaviour
{
    public Vector3 vectorA;

    public Vector3 vectorB;

    public Vector3 ouputVectorACrossB;
    public Vector3 ouputVectorBCrossA;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        ouputVectorACrossB = Vector3.Cross(vectorA, vectorB);
        ouputVectorBCrossA = Vector3.Cross(vectorB, vectorA);
    }
}
