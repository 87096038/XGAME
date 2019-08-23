using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HHC_Test : MonoBehaviour
{
    public Slider s;

    public Text t;
    
    // Start is called before the first frame update
    void Start()
    {
        t.text = "hello";
        s.value = 1;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
