using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateCube : MonoBehaviour
{
    public float speed = 30;

    void Start()
    {
        
    }

    void Update()
    {
        transform.Rotate(speed * Time.deltaTime, speed * Time.deltaTime, -speed * Time.deltaTime);
    }
}
