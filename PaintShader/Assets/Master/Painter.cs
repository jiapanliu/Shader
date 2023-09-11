using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Painter : MonoBehaviour
{
    public Camera cam;
    [Space]
    public bool mouseSingleClick;
    [Space]
    public Color paintColor;

    [Min(0.5f)]
    public float radius = 1;
    public float strength = 1;
    public float hardness = 1;
}

