using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Services;
using System;
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
            if (!ServerService.instance.isOffline())
            ServerService.instance.Socket.Emit("addStroke", strignifiedStroke);
        }

        public static void RemoveStroke(string strokeId)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("removeStroke", strokeId);
        }

        public static void EditStroke(string strignifiedStroke)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("editStroke", strignifiedStroke);
        }
        
        public static void RequestAddPerson(string imageId)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("joinImage", imageId);
        }

        public static void RequestQuit(string person)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("leaveImage");
        }

        public static void LockStroke(List<string> strokesIds)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("requestProtection", JsonConvert.SerializeObject(strokesIds));
        }

        public static void UnlockStrokes()
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("removeProtection");
        }

        public static void ClearCanvas()
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("clearCanvas");
        }

        internal static void resizeCanvas(Size value)
        {
            if (!ServerService.instance.isOffline())
                ServerService.instance.Socket.Emit("resizeCanvas", value.Width, value.Height);
        }
    }
}
