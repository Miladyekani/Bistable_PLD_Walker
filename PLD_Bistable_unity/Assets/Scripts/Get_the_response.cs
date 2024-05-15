using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections.Generic;


public class Get_the_response : MonoBehaviour
{
    public string response;
    public List<string> myList = new List<string>();
    private float RT = 0 ;
    public float Reaction_Time;
    public float Update_time = 0.02f;
    void FixedUpdate()
    {
        RT = RT + 1;
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            get_response_toward(); 
        }
        RT = RT + 1;
        if (Input.GetKey(KeyCode.RightArrow))
        {
            get_response_Away();
        }
    }
    public void get_response_toward ()
    {
        response = "Toward";
        Debug.Log(response);
        myList.Add(response);
        Data_Collector.Respose_List.Add(response);
        // calculate the reaction time 
        Reaction_Time = RT * Update_time;
        Data_Collector.RT.Add(Reaction_Time);
        // change the scene 
        SceneManager.LoadScene(0);
    }
    public void get_response_Away()
    {
        response = "Away";
        Debug.Log(response);
        myList.Add(response);
        Data_Collector.Respose_List.Add(response);
        // calculate the reaction time 
        Reaction_Time = RT * Update_time;
        Data_Collector.RT.Add(Reaction_Time);
        // change the scene 
        SceneManager.LoadScene(0);
    }







}