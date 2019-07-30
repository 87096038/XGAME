using System;
using UnityEngine;
using XLua;
using Object = System.Object;

public class Collision : MonoBehaviour
{

    public Action<string, Object> CollisionHandle;

    private void Awake()
    {
        
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        CollisionHandle("CollisionEnter2D", other);
    }

    private void OnCollisionStay2D(Collision2D other)
    {
        CollisionHandle("CollisionStay2D", other);
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        CollisionHandle("CollisionExit2D", other);
    }

    public void OnTriggerEnter2D(Collider2D other)
    {
        CollisionHandle("TriggerEnter2D", other);
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        CollisionHandle("TriggerStay2D", other);
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        CollisionHandle("TriggerExit2D", other);
    }
}
