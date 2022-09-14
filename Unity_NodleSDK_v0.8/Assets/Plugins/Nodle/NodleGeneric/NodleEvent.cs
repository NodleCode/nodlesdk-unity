using UnityEngine;
[System.Serializable]
public class NodleEvent
{
    public string message = "";
    public string device = "";
    public byte[] bytes;
    public string rssi = "";
    public int id = 0;
    public string name = "";
    public string status = "";
    public string version = "";

    public string accuracy = "";
    public string major = "";
    public string minor = "";
    public string proximity = "";

    public string identifier = "";
    public string timestamp = "";

    public static NodleEvent CreateFromJSON(string jsonString)
    {
        return JsonUtility.FromJson<NodleEvent>(jsonString);
    }
}