using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePainter : Painter
{
    void Update()
    {
        bool click;
        click = mouseSingleClick ? Input.GetMouseButtonDown(0) : Input.GetMouseButton(0);

        if (click)
        {
            Vector3 position = Input.mousePosition;
            Ray ray = cam.ScreenPointToRay(position);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 100.0f))
            {
                Debug.DrawRay(ray.origin, hit.point - ray.origin, Color.red);
                transform.position = hit.point;
                Paintable p = hit.collider.GetComponent<Paintable>();
                if (p != null)
                {
                    PaintManager.instance.Paint(p, hit.point, radius, hardness, strength, paintColor);
                }
            }
        }

    }
}


