using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoadTimer : MonoBehaviour
{
    private float startTime; // Time when the scene starts loading
    private bool keyPressed; // Flag to indicate if a key has been pressed

    void Awake()
    {
        startTime = Time.timeSinceLevelLoad; // Capture start time upon scene load
    }

    void Update()
    {
        if (!keyPressed && Input.anyKeyDown) // Check for any key press
        {
            float elapsedTime = (Time.timeSinceLevelLoad - startTime) * 1000f; // Get time in milliseconds
            Debug.Log("Time taken to press a key: " + elapsedTime.ToString("F2") + " milliseconds"); // Log with 2 decimal places
            keyPressed = true; // Prevent multiple time calculations
        }
    }
}
