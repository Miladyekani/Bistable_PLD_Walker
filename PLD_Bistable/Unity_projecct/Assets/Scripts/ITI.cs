using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;


public class ITI : MonoBehaviour
{
    private int frame_count     = 0;
    private int trail_duration  = 0;
    private int next_scene_dice = 1;
    private int next_scene_num  = 1;
    // specify the destiny of the file 



    // Start is called before the first frame update
    void Start()
    {


        Data_Collector.trial_number = Data_Collector.trial_number + 1;
        Debug.Log(Data_Collector.trial_number);
        if (Data_Collector.trial_number > 6) 
        {
            // save the responses
            string filePath = Application.dataPath + "/resp.csv";
            StreamWriter writer = new StreamWriter(filePath);
            writer.WriteLine("reaction_time, response");
            for (int i = 0; i < Mathf.Min(Data_Collector.RT.Count, Data_Collector.Respose_List.Count); i++)
            {
                writer.WriteLine(Data_Collector.RT[i].ToString() + "," + Data_Collector.Respose_List[i]);
            }
            writer.Close();
            //end the experiment 
            Time.timeScale = 0; 
        }
        trail_duration  = Random.Range(110, 210);
        // decide what will be the next scene 
        next_scene_dice = Random.Range(0, 6);
        Debug.Log(next_scene_dice); 
        if (next_scene_dice == 1)
        {
            next_scene_num = 3 ; 
        }
        if (next_scene_dice == 2)
        {
            next_scene_num = 4;
        }
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        Time.fixedDeltaTime = 1.0f / 120.0f;
        frame_count = frame_count + 1;
        if (frame_count > trail_duration)
        {
            //change the scene 
            SceneManager.LoadScene (next_scene_num);
        }
    }
}
