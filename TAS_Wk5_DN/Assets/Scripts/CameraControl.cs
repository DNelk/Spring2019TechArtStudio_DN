using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControl : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        Vector2 input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        
        if (input.x != 0)
        {
            transform.position += transform.right * input.x;
        }
        
        if (input.y != 0)
        {
            transform.position += transform.forward * input.y;
        }
    }
}
