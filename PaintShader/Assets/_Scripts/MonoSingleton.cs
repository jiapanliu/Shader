using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonoSingleton<T> : MonoBehaviour where T : MonoBehaviour
{

    private static T _instance;

	public static T instance{
		get{
			if(_instance==null){
				GameObject obj=new GameObject(typeof(T).Name);
				_instance=obj.AddComponent<T>();
			}
			return _instance;
		}
	}

	protected virtual void Awake(){
		_instance=this as T;
	}
}
