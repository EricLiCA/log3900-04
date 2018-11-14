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
        public List<string> UsersIds;
        public CustomStrokeCollection Strokes;

        public EditionSocket()
        {
            this.UsersIds = new List<string>();
            this.Strokes = new CustomStrokeCollection();
            OnStrokeAdded();
            OnStrokeRemoved();
            OnStrokeUpdated();
        }

        public void AddStroke(string strignifiedStroke)
        {
            ServerService.instance.Socket.Emit("addStroke", strignifiedStroke);
        }

        public void RemoveStroke(string strokeId)
        {
            ServerService.instance.Socket.Emit("removeStroke", strokeId);
        }

        public void EditStroke(string strignifiedStroke)
        {
            ServerService.instance.Socket.Emit("editStroke", strignifiedStroke);
        }


        public void RequestAddPerson(string imageId)
        {
            ServerService.instance.Socket.Emit("joinImage", imageId);
        }

        public void RequestQuit(string person)
        {
            ServerService.instance.Socket.Emit("leaveImage");
        }

        public void LockStroke(List<string> strokesIds)
        {
            ServerService.instance.Socket.Emit("requestProtection");
        }

        public void AddPerson(string newId)
        {
            if (this.UsersIds.Any(id => id == newId)) return;

            Application.Current.Dispatcher.Invoke(() =>
            {
                this.UsersIds.Add(newId);
            });
        }

        public void RemovePerson(string idToRemove)
        {
            if (!this.UsersIds.Any(id => id == idToRemove)) return;

            Application.Current.Dispatcher.Invoke(() =>
            {
                this.UsersIds.Remove(idToRemove);
            });
        }

        public void OnStrokeAdded()
        {
            ServerService.instance.Socket.On("strokeAdded", new CustomListener((object[] server_params) =>
            {
                ShapeLoader.LoadShape((string)server_params[0], Strokes);
            }));
        }

        public void OnStrokeUpdated()
        {
            ServerService.instance.Socket.On("strokeUpdated", new CustomListener((object[] server_params) =>
            {
                dynamic shape = JObject.Parse((string)server_params[0]);
                Stroke updatedStroke = this.Strokes.First(stroke => ((CustomStroke)stroke).Id == shape["Id"]);
                this.Strokes.Remove(updatedStroke);
                ShapeLoader.LoadShape((string)server_params[0], Strokes);
            }));
        }

        public void OnStrokeRemoved()
        {
            ServerService.instance.Socket.On("strokeRemoved", new CustomListener((object[] server_params) =>
            {
                dynamic shape = JObject.Parse((string)server_params[0]);
                Stroke strokeToRemove = this.Strokes.First(stroke => ((CustomStroke)stroke).Id == shape["Id"]);
                this.Strokes.Remove(strokeToRemove);
            }));
        }
    }
}
