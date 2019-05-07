using System.Collections;
using System.Collections.Generic;
//using NUnit.Framework.Constraints;
using UnityEngine;

public class ThirdPersonCameraController : MonoBehaviour {

    #region Internal References
    private Transform _app;
    private Transform _view;
    private Transform _cameraBaseTransform;
    private Transform _cameraTransform;
    private Transform _cameraLookTarget;
    private Transform _avatarTransform;
    private Rigidbody _avatarRigidbody;
    private Transform _cameraLocusTransform;
    #endregion

    #region Public Tuning Variables  
    public Vector3 avatarObservationOffset_Base;
    public float followDistance_Base;
    public float verticalOffset_Base;
    public float pitchGreaterLimit;
    public float pitchLowerLimit;
    public float fovAtUp;
    public float fovAtDown;
    public Vector3 cameraLOSOffset;
    #endregion

    #region Persistent Outputs
    //Positions
    private Vector3 _camRelativePostion_Auto;

    //Directions
    private Vector3 _avatarLookForward;

    //Scalars
    private float _followDistance_Applied;
    private float _verticalOffset_Applied;
    
    //States
    public enum CameraStates {Automatic, Manual, Idle}
    private CameraStates _currentState;
    #endregion

    private void Awake()
    {
        _app = GameObject.Find("Application").transform;
        _view = _app.Find("View");
        _cameraLocusTransform = _view.Find("AIThirdPersonController").Find("CameraLocus");
        _cameraBaseTransform = _cameraLocusTransform.Find("CameraBase");
        _cameraTransform = _cameraBaseTransform.Find("Camera");
        _cameraLookTarget = _cameraBaseTransform.Find("CameraLookTarget");

        _avatarTransform = _view.Find("AIThirdPersonController");
        _avatarRigidbody = _avatarTransform.GetComponent<Rigidbody>();
    }

    private void Start()
    {
        _currentState = CameraStates.Automatic;
    }

    private float _idleTimer;
    private void Update()
    {
        //_idleTimer += Time.deltaTime;
        if (Input.GetMouseButton(1))
        {
            _currentState = CameraStates.Manual;
            _idleTimer = 0;
        }
        else if (!Input.GetMouseButton(0) && _idleTimer > 10)
            _currentState = CameraStates.Idle;
        else if (Input.GetMouseButton(0))
        {
            _currentState = CameraStates.Automatic;
            _idleTimer = 0;
        }
        else
            _idleTimer += Time.deltaTime;
            

        if (_currentState == CameraStates.Automatic)
            _AutoUpdate();
        else if (_currentState == CameraStates.Manual)
            _ManualUpdate();
        else
            _IdleUpdate();
    }

    #region States 

    private float hillSlider = 0f;
    private void _AutoUpdate()
    {
        _ComputeData();
        
        
        if (_Helper_IsHillForward()) //R we facing a hill, if so lets go up
        {
            hillSlider = Mathf.MoveTowards(hillSlider, 1, Time.deltaTime);
            _cameraBaseTransform.position = _cameraTransform.position + Vector3.up * hillSlider;
        }
        else if (_Helper_IsThereLOSBlock())//let's move the camera if line of sight gets broken
        {
            _FollowAvatar();
            bool isRightBlock = _Helper_IsRightLOSBlock();
            bool isLeftBlock = _Helper_IsLeftLOSBlock();
            
            if (isRightBlock && isLeftBlock)
            {
                _cameraLocusTransform.Rotate(-1f, 0, 0);
            }
            else if (isRightBlock)
            {
                _cameraLocusTransform.Rotate(0, 1f, 0);
               
            }
            else{
                _cameraLocusTransform.Rotate(0, -1f, 0);
                
            }
            //Debug.Log(_cameraBaseTransform.rotation.eulerAngles);
        }
        else
        {
            hillSlider = 0f;
            _FollowAvatar();
            _LookAtAvatar();
        }
    }
    private void _ManualUpdate()
    {
        _FollowAvatar();
        _ManualControl();
    }

    private void _IdleUpdate()
    {
       if (_Helper_IsThereOOI())
           _LookAtObject(_Helper_ClosestOOI());
    }

    #endregion

    #region Internal Logic

    float _standingToWalkingSlider = 0;

    private void _ComputeData()
    {
        _avatarLookForward = Vector3.Normalize(Vector3.Scale(_avatarTransform.forward, new Vector3(1, 0, 1)));

        if (_Helper_IsWalking())
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 1, Time.deltaTime * 3);
        }
        else
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 0, Time.deltaTime);
        }
        
        float _followDistance_Walking = followDistance_Base;
        float _followDistance_Standing = followDistance_Base * 2;

        float _verticalOffset_Walking = verticalOffset_Base;
        float _verticalOffset_Standing = verticalOffset_Base * 4;

        _followDistance_Applied = Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _standingToWalkingSlider);
        _verticalOffset_Applied = Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _standingToWalkingSlider);
    }

    private void _FollowAvatar()
    {
        _camRelativePostion_Auto = _avatarTransform.position;

        _cameraLookTarget.position = _avatarTransform.position + avatarObservationOffset_Base;
        _cameraTransform.position = _avatarTransform.position - _avatarLookForward * _followDistance_Applied + Vector3.up * _verticalOffset_Applied;
    }

    private void _LookAtAvatar()
    {
        _cameraTransform.LookAt(_cameraLookTarget);
    }

    private void _LookAtObject(Transform obj)
    {
        _cameraTransform.LookAt(obj);
    }
    
    private void _ManualControl()
    {
        Vector3 _camEulerHold = _cameraTransform.localEulerAngles;

        if (Input.GetAxis("Mouse X") != 0)
            _camEulerHold.y += Input.GetAxis("Mouse X");

        if (Input.GetAxis("Mouse Y") != 0)
        {
            float temp = _camEulerHold.x - Input.GetAxis("Mouse Y");
            temp = (temp + 360) % 360;

            if (temp < 180)
                temp = Mathf.Clamp(temp, 0, 80);
            else
                temp = Mathf.Clamp(temp, 360 - 80, 360);

            _camEulerHold.x = temp;
        }

        Debug.Log("The V3 to be applied is " + _camEulerHold);
        _cameraTransform.localRotation = Quaternion.Euler(_camEulerHold);
    }
    #endregion

    #region Helper Functions

    private Vector3 _lastPos;
    private Vector3 _currentPos;
    private bool _Helper_IsWalking()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;

        if (velInst > .15f)
            return true;
        else return false;
    }
    
    //OOI - Object of Interest
    private bool _Helper_IsThereOOI()
    {
        Collider[] stuffInSphere = Physics.OverlapSphere(_avatarTransform.position, 5);
        foreach (Collider thing in stuffInSphere)
        {
            if (thing.CompareTag("ObjectOfInterest"))
                return true;

        }
        return false;
    }

    private Transform _Helper_ClosestOOI()
    {
        Collider[] stuffInSphere = Physics.OverlapSphere(_avatarTransform.position, 5);
        Transform closestTransform = transform;
        float closestDistance = 5;
        float newDistance;
        foreach (Collider thing in stuffInSphere)
        {
            if (thing.CompareTag("ObjectOfInterest"))
            {
                newDistance = Vector3.Distance(_avatarTransform.position, thing.transform.position);
                if (newDistance < closestDistance)
                {
                    closestDistance = newDistance;
                    closestTransform = thing.transform;
                }
            }

        }
        return closestTransform;
    }

    //Gizmo for debugging
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        if (_cameraTransform != null)
        {
            Gizmos.DrawWireSphere(_cameraTransform.position + cameraLOSOffset, 2);
            Gizmos.DrawWireSphere(_cameraTransform.position - cameraLOSOffset, 2);
        }
    }

    //Find if obstacles 
    private bool _Helper_IsThereLOSBlock()
    {
        
        Collider[] rightOverlap = Physics.OverlapSphere(_cameraTransform.position + cameraLOSOffset, 1);
        Collider[] leftOverlap = Physics.OverlapSphere(_cameraTransform.position - cameraLOSOffset, 1);

        
        foreach (Collider collider in rightOverlap)
        {
            if (!collider.CompareTag("Player") && !collider.CompareTag("NavMesh"))
                return true;

        }
        
        foreach (Collider collider in leftOverlap)
        {
            if (!collider.CompareTag("Player") && !collider.CompareTag("NavMesh"))
                return true;

        }

        return false;
    }

    //Check if theres an object blocking line of sight on the right side
    private bool _Helper_IsRightLOSBlock()
    {
        Collider[] rightOverlap = Physics.OverlapSphere(_cameraTransform.position + cameraLOSOffset, 1);
        
        foreach (Collider collider in rightOverlap)
        {    
            //Don't check the player or the ground
            if (!collider.CompareTag("Player") && !collider.CompareTag("NavMesh"))
            {
                //If the object is too narrow we don't care
                if(collider.bounds.size.x > 1 || collider.bounds.size.z > 1)
                   return true; 
            }

        }

        return false;
    }
   
    //Check if theres an object blocking line of sight on the left side
    private bool _Helper_IsLeftLOSBlock()
    {
        Collider[] leftOverlap = Physics.OverlapSphere(_cameraTransform.position - cameraLOSOffset, 1);
        
        //Don't check the player or the ground
        foreach (Collider collider in leftOverlap)
        {
            if (!collider.CompareTag("Player") && !collider.CompareTag("NavMesh"))
            {
                //If the object is too narrow we don't care
                if(collider.bounds.size.x > 1 || collider.bounds.size.z > 1)
                    return true; 
            }

        }

        return false;
    }

    private bool _Helper_IsHillForward()
    {
        RaycastHit hit;
        // Does the ray intersect a hill
        if (Physics.Raycast(_cameraTransform.position, transform.TransformDirection(_cameraTransform.forward), out hit, 10f))
        {
            if(hit.collider.CompareTag("Hill"))
            {
                Debug.DrawRay(_cameraTransform.position, transform.TransformDirection(_cameraTransform.forward) * hit.distance, Color.green);
                return true;
            }
        }
        
        Debug.DrawRay(_cameraTransform.position, transform.TransformDirection(_cameraTransform.forward) * 1000, Color.red);
        return false;
    }
    
    #endregion
}
