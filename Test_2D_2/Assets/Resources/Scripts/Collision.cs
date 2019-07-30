using System;
using UnityEngine;
using XLua;

public class Collision : MonoBehaviour
{
    
    public Action<System.Object, string, System.Object> CollisionHandle;
    
    private void OnCollisionEnter2D(Collision2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "CollisionEnter2D", other);
    }

    private void OnCollisionStay2D(Collision2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "CollisionStay2D", other);
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "CollisionExit2D", other);
    }

    public void OnTriggerEnter2D(Collider2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "TriggerEnter2D", other);
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "TriggerStay2D", other);
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if(CollisionHandle != null)
            CollisionHandle(this, "TriggerExit2D", other);
    }
}
