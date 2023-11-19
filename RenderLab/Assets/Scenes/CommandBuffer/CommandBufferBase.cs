using UnityEngine;
using UnityEngine.Rendering;

public class CommandBufferBase : MonoBehaviour
{

	private void OnEnable()
	{
		CommandBuffer buf = new CommandBuffer { name = "ayy cmd buf" };

		// Create RT
		int screenCopyID = Shader.PropertyToID("_ScreenCopyID");
		buf.GetTemporaryRT(screenCopyID, -1, -1, 0, FilterMode.Bilinear);
		buf.Blit(Camera.main.activeTexture, screenCopyID);
		buf.SetGlobalTexture("_Ayy_GrabTexture", screenCopyID);

		Camera.main.AddCommandBuffer(CameraEvent.AfterSkybox, buf);
		//_camera.AddCommandBuffer(CameraEvent.AfterForwardOpaque,buf);
	}
}
