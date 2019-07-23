using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public int hp;
    public int maxHp;
    public float speed;

    Rigidbody2D rigidbody2d;
    
    // Start is called before the first frame update
    void Start()
    {
        hp = maxHp = 100;
        speed = 5.0f;
        
        rigidbody2d = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        float horizontal = Input.GetAxisRaw("Horizontal");
        float vertical = Input.GetAxisRaw("Vertical");
        
//        Vector2 position = transform.position;
        Vector2 position = rigidbody2d.position;
        
        position.x = position.x + speed * horizontal * Time.deltaTime;
        position.y = position.y + speed * vertical * Time.deltaTime;
        
//        transform.position = position;
        rigidbody2d.MovePosition(position);
    }

    void changeHP(int amount)
    {
        hp = Mathf.Clamp(hp + amount, 0, maxHp);    //hp不会小于0且不会大于maxHp
    }
}
