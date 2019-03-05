using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk : MonoBehaviour
{
    #region Private Variables
    private MeshFilter _myMF; //Our Mesh filter
    private MeshRenderer _myMR; //Our Mesh renderer

    private Mesh _myMesh; //Our Mesh

    private Vector3[] _verts; //Our vertices
    private int[] _tris; //Our Tris
    private Vector2[] _uVs; //Our UVs
    private Vector3[] _normals; //Our Normals

    //Indices of vertices and tris
    private int _totalVertInd;
    private int _totalTrisInd;
    
    #endregion
    
    public static int SizeSquare = 8; //Square root of amount of quads of our chunk 
    
    private void Awake()
    {
        _myMF = gameObject.AddComponent<MeshFilter>();
        _myMR = gameObject.AddComponent<MeshRenderer>();

        _myMesh = new Mesh();
    }

    private void Start()
    {
        _Init();
        _CalcMesh();
        _ApplyMesh();
    }

    //Figure out how many things we need and make the variables
    private void _Init()
    {
        _totalVertInd = (SizeSquare + 1) * (SizeSquare + 1); 
        _totalTrisInd = (SizeSquare) * (SizeSquare) * 2 * 3;
        
        _verts = new Vector3[_totalVertInd];
        _tris = new int[_totalTrisInd];
        _uVs = new Vector2[_totalVertInd];
        _normals = new Vector3[_totalVertInd];
    }
      
    private void _CalcMesh()
    {
        //Assign our vertices UVs, giving a y based on transform position and noise
        for (int z = 0; z <= SizeSquare; z++)
        {
            for (int x = 0; x <= SizeSquare; x++)
            {
                _verts[z * (SizeSquare + 1) + x] = new Vector3(x
                    , 8 * Perlin.Noise((transform.position.x + (float)x)/SizeSquare , (transform.position.z + (float)z)/SizeSquare), z);
                _uVs[z * (SizeSquare + 1) + x] = new Vector2(x,z);
            }
        }
        
        CalcTris();
    }

    //Apply our vertices and such to the mesh
    private void _ApplyMesh()
    {
        _myMesh.vertices = _verts;
        _myMesh.triangles = _tris;
        _myMesh.uv = _uVs;
        _myMesh.RecalculateNormals();

        _myMF.mesh = _myMesh;

        _myMR.material = Resources.Load<Material>("MyMat");
    }

    public void RecalculateMesh()
    {
        _CalcMesh();
        _ApplyMesh();
    }

    //Calculate our tris
    private void CalcTris()
    {
        //Assign our tris
        int _triInd = 0;
        int bottomLeft, topLeft, bottomRight, topRight;      
        for (int j = 0; j < SizeSquare; j++)
        {
            for (int k = 0; k < SizeSquare; k++)
            {
                bottomLeft = k + (j * (SizeSquare + 1));
                topLeft = k + ((j + 1) *(SizeSquare + 1));
                bottomRight = bottomLeft + 1;
                topRight = topLeft + 1;

                _tris[_triInd] = bottomLeft;
                _triInd++;
                _tris[_triInd] = topLeft;
                _triInd++;
                _tris[_triInd] = bottomRight;
                _triInd++;
                _tris[_triInd] = topLeft;
                _triInd++;
                _tris[_triInd] = topRight;
                _triInd++;
                _tris[_triInd] = bottomRight;
                _triInd++;
            }
        }
    }
}
