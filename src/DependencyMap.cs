using System;
using System.Collections.Specialized;

namespace DependsOn
{
    public class DependencyMap
    {
        private OrderedDictionary map = new OrderedDictionary();
        private System.Collections.Queue Queue;

        public DependencyMap()
        {
            var comparer = StringComparer.InvariantCultureIgnoreCase;
            map = new OrderedDictionary(comparer);
        }

        public void Add(System.Object inputObject, string key, string[] dependsOn)
        {
            var container = new Container(inputObject,key,dependsOn);
            Add(container);
        }
        internal void Add(Container container)
        {
            if(map.Contains(container.Key))
            {
                throw new System.InvalidOperationException( $"Key [{container.Key}] already exists in this collection and must be unique");
            }
            map.Add(container.Key,container);
        }

        public System.Object[] ToArray()
        {
            CreateQueue();
            return Queue.ToArray();
        }

        private void CreateQueue()
        {
            Queue = new System.Collections.Queue();
            foreach (string key in map.Keys)
            {
                QueueObject(key);
            }
        }

        private void QueueObject(string key)
        {
            Container node = (Container) map[key];
            if(null != node && !node.IsQueued)
            {
                node.IsQueued = true;
                if(null != node.DependsOn)
                {
                    foreach(string childNode in node.DependsOn)
                    {
                        QueueObject(childNode);
                    }
                }
                Queue.Enqueue(node.Object);
            }
        }
    }
}
