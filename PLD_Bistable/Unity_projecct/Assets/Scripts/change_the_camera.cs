using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class change_the_camera : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject Camera_Front;
    public GameObject Camera_Back;
    public GameObject Knee_L;
    private MeshRenderer Knee_L_Mesh_renderer; // Declare as a class member

    private int Space_conuter = 0 ;
    private int Direction = 0;
    private int frame_count = 0; 
    void Start()
    {
        int currentSceneNumber = SceneManager.GetActiveScene().buildIndex;
        MeshRenderer Knee_L_Mesh_renderer = Knee_L.GetComponent<MeshRenderer>();
        Direction = 1; //  Random.Range(0, 2);
        if (Direction == 1 & currentSceneNumber == 1)
        {
            //Knee_L.SetActive(true);

            Camera_Front.SetActive(true);
            Camera_Back.SetActive(false);
         
        }

        /*
        if (Direction == 1)
        {
            //Knee_L.SetActive(false);

            Camera_Front.SetActive(false);
            Camera_Back.SetActive(true);
   
        }
        */

    }
    void Awake() 
    {
        MeshRenderer Knee_L_Mesh_renderer = Knee_L.GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        

        Debug.Log(Direction);
        frame_count = frame_count + 1;
            if (frame_count > 100)
        {
            Debug.Log("it reaches to 100 frame");
            //change the scene here
            SceneManager.LoadScene(2);
        }




    }
}
