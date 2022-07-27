using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient.Utils
{
    class Constants
    {
        //Errors:
        public const string CONECCTION_ERROR = "Error de conexión, revise su red";
        public const string CREDENTIAL_ERROR = "Correo o Contraseña Incorrectos";
        public const string USER_TYPE_ERROR = "El usuario debe ser administrador";

        // Map
        public const double INITIAL_LATITUDE = -1.3460634739251633;
        public const double INITIAL_LONGITUDE = -78.56483353462201;
        public const int MAX_ZOOM = 18;
        public const int MIN_ZOOM = 7;
        public const int MAP_ZOOM = 13;

        //TITLE
        public const string COMPANIES = "LOCALIZACIÓN SUCURSALES";
        public const string NOTIFICATIONS = "HISTORIAL DE NOTIFICACIONES";
        public const string USERS = "USUARIOS";

        //ALERT
        public const string DELETE_BRANCH = "¿Esta seguro que desea eliminar la sucursal? Si existen usuarios asignados a esta sucursal tendrá que reasignarlos manualmente después";
    }
}
