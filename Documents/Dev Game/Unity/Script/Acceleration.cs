﻿using UnityEngine;
using System.Collections;

public class Acceleration : MonoBehaviour {
	public float accSpeed;
	
	void Start () {
	}
	
	void Update () {
        Vector2 dir = Vector2.zero;
        dir.x = Input.acceleration.x;
        dir.y = Input.acceleration.y;
        if (dir.sqrMagnitude > 1)
            dir.Normalize();

        dir *= Time.deltaTime;
        transform.Translate(dir * accSpeed);
	}
}