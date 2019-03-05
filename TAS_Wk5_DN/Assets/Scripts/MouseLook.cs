using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/*Thx to IJM on UnityAnswers*/
public class MouseLook : MonoBehaviour {

	
	public enum RotationAxes {MouseXAndY = 0, MouseX = 1, MouseY = 2,} 

	public RotationAxes axes = RotationAxes.MouseXAndY;
	public float sensitivityX = 15f;
	public float sensitivityY = 15f;

	public float minimumX = -360f;
	public float maximumX = 360f;
	public float minimumY = -60f;
	public float maximumY = 60f;
	private float rotationX = 0f;
	private float rotationY = 0f;
	private Quaternion originalRotation;
	
	// Use this for initialization
	void Start ()
	{
		if (GetComponent<Rigidbody>())
			GetComponent<Rigidbody>().freezeRotation = true;
		originalRotation = transform.localRotation;
	}
	
	// Update is called once per frame
	void Update () {
		if (axes == RotationAxes.MouseXAndY) //Diagonal mouse movement
		{
			//Read Mouse input
			rotationX += Input.GetAxis("Mouse X") * sensitivityX;
			rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
			rotationX = ClampAngle(rotationX, minimumX, maximumX);
			rotationY = ClampAngle(rotationY, minimumY, maximumY);
			Quaternion xQuaternion = Quaternion.AngleAxis(rotationX, Vector3.up);
			Quaternion yQuaternion = Quaternion.AngleAxis(rotationY, -Vector3.right);

			transform.localRotation = originalRotation * xQuaternion * yQuaternion;
		}
		else if (axes == RotationAxes.MouseX) //Looking in x
		{
			rotationX += Input.GetAxis("Mouse X") * sensitivityX;
			rotationX = ClampAngle(rotationX, minimumX, maximumX);
			Quaternion xQuaternion = Quaternion.AngleAxis(rotationX, Vector3.up);
			
			transform.localRotation = originalRotation * xQuaternion;
		}
		else //Must be looking in y i guess
		{
			rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
			rotationY = ClampAngle(rotationY, minimumY, maximumY);
			Quaternion yQuaternion = Quaternion.AngleAxis(rotationY, -Vector3.right);

			transform.localRotation = originalRotation * yQuaternion;
		}
	}

	//keeps our numbers in readble range
	public static float ClampAngle(float angle, float min, float max)
	{
		if (angle < -360f)
			angle += 360f;
		if (angle > 360f)
			angle -= 360f;
		return Mathf.Clamp(angle, min, max);
	}
}
