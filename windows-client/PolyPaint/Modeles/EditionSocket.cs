using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Services;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Ink;

namespace PolyPaint.Modeles
{
    public class EditionSocket
    {
        public static void AddStroke(string strignifiedStroke)
        {
            ServerService.instance.Socket.Emit("addStroke", strignifiedStroke);
        }

        public static void RemoveStroke(string strokeId)
        {
            ServerService.instance.Socket.Emit("removeStroke", strokeId);
        }

        public static void EditStroke(string strignifiedStroke)
        {
            ServerService.instance.Socket.Emit("editStroke", strignifiedStroke);
        }
        
        public static void RequestAddPerson(string imageId)
        {
            ServerService.instance.Socket.Emit("joinImage", imageId);
        }

        public static void RequestQuit(string person)
        {
            ServerService.instance.Socket.Emit("leaveImage");
        }

        public static void LockStroke(List<string> strokesIds)
        {
            ServerService.instance.Socket.Emit("requestProtection", JsonConvert.SerializeObject(strokesIds));
        }

        public static void UnlockStrokes()
        {
            ServerService.instance.Socket.Emit("removeProtection");
        }
    }
}
