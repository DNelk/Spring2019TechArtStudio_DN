using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class FlockManager : MonoBehaviour
{
    public GameObject myAutoAgentPrefab;

    [Range(1, 500)] public int numberOfSpawns;

    public float spacing = 2f;

    private List<GameObject> _agents = new List<GameObject>();
    // Start is called before the first frame update
    void Start()
    {
        float rCubed = 3 * numberOfSpawns / (4 * Mathf.PI * 0.5f);
        float r = Mathf.Pow(rCubed, 0.33f);
        for (int i = 0; i < numberOfSpawns; i++)
        {
            _agents.Add(Instantiate(myAutoAgentPrefab, Random.insideUnitSphere * numberOfSpawns * spacing, Quaternion.identity, transform));
        }
        
    }
    Collider[] colsInRad = new Collider[1];
    // Update is called once per frame
    void Update()
    {
        foreach (GameObject g in _agents)
        {
            AutoAgentBehavior a = g.GetComponent<AutoAgentBehavior>();
            Physics.OverlapSphereNonAlloc(g.transform.position, 20, colsInRad);
            a.PassContexts(colsInRad);
        }
    }
}
