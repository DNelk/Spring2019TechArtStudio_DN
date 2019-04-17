using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AnimationParameterController : MonoBehaviour
{
    private float walkRun_Blend_X;
    private float walkRun_Blend_Y;
   
    [Header("Tuning Values")] 
    [Range(0.001f, 10.0f)] public float walkCycleTime;
    [Range(0.001f, 1.00f)] public float walkRunMagnitude;
    public float moveSpeed;
    public float currentVel;
    private float maxVel = 30f;
    [Range(0.000f, 1.0f)] public float walkRunBlendTotal;
    private Animator myAnimator;
    private Rigidbody myRB;
    private float time;

    private float idleTime;
    public Text velText;
    
    // Start is called before the first frame update
    void Start()
    {
        myAnimator = GetComponent<Animator>();
        myRB = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            myRB.velocity -= Vector3.forward * moveSpeed;             
        }

        currentVel = myRB.velocity.magnitude;
        currentVel = Mathf.Clamp(currentVel, 0f, maxVel - 5f);
        if(currentVel > 0.1f)
            myAnimator.SetBool("Idle_False_Move_True", true);
        else
            myAnimator.SetBool("Idle_False_Move_True", false);
        
        //Idle
        idleTime += Time.deltaTime * 6;
        myAnimator.SetFloat("Idle_TreeVal_X", (Mathf.Sin(idleTime) + 1)/2);

        //Walk n run
        walkRunBlendTotal = 1 * currentVel / maxVel;
        walkCycleTime = (1 - walkRunBlendTotal) + 0.001f;
        walkRunMagnitude = .25f + (.75f * walkRunBlendTotal);
        
        time += (Mathf.PI*2* Time.deltaTime) / walkCycleTime;
        
        walkRun_Blend_X = Mathf.Cos(time) * walkRunMagnitude;
        walkRun_Blend_Y = Mathf.Sin(time) * walkRunMagnitude;
        
        myAnimator.SetFloat("WalkRun_TreeVal_X", walkRun_Blend_X);
        myAnimator.SetFloat("WalkRun_TreeVal_Y", walkRun_Blend_Y);
        
        velText.text = "Current Velocity: " + currentVel.ToString("#.##");
    }
}
