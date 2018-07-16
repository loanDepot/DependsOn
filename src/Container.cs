using System;

namespace DependsOn
{
    internal class Container
    {
        public System.Object Object;
        public String Key;
        public String[] DependsOn;

        public Boolean IsQueued = false;

        public Container ()
        {
            Object = null;
            Key = "";
            DependsOn = new string[] { };
        }
        public Container (System.Object inputObject, string key, string[] dependsOn)
        {
            Object = inputObject;
            Key = key;
            DependsOn = dependsOn;
        }
    }
}