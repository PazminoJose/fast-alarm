using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient.Utils
{
    public static class Constants
    {
        //Errors:
        public static readonly string CONECCTION_ERROR = "Error de conexión, revise su red";
        public static readonly string CREDENTIAL_ERROR = "Correo o Contraseña Incorrectos";
        public static readonly string USER_TYPE_ERROR = "El usuario debe ser administrador";
               
        // Map 
        public static readonly double INITIAL_LATITUDE = -1.3460634739251633;
        public static readonly double INITIAL_LONGITUDE = -78.56483353462201;
        public static readonly int MIN_ZOOM = 7;
        public static readonly int MAX_ZOOM = 15;
               
        //TITLE
        public static readonly string ALARMS = "LOCALIZACIÓN ALARMAS";
        public static readonly string NOTIFICATIONS = "HISTORIAL DE NOTIFICACIONES";
        public static readonly string USERS = "USUARIOS";
        public static readonly string DASHBOARD = "USUARIOS";
               
        //MESSAGES
        public static readonly string DELETE_BRANCH = "¿Esta seguro que desea eliminar la sucursal? Si existen usuarios asignados a esta sucursal tendrá que reasignarlos manualmente después";
    }
}
