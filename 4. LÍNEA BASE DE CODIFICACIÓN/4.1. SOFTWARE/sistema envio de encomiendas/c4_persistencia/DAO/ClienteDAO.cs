using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
using c3_dominio.contratos;
using System.Data.SqlClient;
using System.Data;
namespace c4_persistencia.DAO
{
    public class ClienteDAO : IClienteDAO
    {
        private GestorDAOSQL gestorDAOSQL;
        public ClienteDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }

        //Capcha ---

        public List<Cliente> ListarClientes()
        {
            List<Cliente> Lista = new List<Cliente>();
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;

            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spListarCliente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Cliente c = new Cliente();
                    c.idCliente = Convert.ToInt32(dr["idCliente"]);
                    c.nombresCliente = dr["nombresCliente"].ToString();
                    c.apellidosCliente = dr["apellidosCliente"].ToString();
                    c.documentoIdentidad = dr["documentoIdentidad"].ToString();
                    c.direccion = dr["direccion"].ToString();
                    c.telefono = dr["telefono"].ToString();
                    c.activo = Convert.ToBoolean(dr["activo"]);
                    Lista.Add(c);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Lista;
        }

        public Cliente BuscarCliente(Int32 IdCliente)
        {
            Cliente c = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spBuscarCliente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdCliente", IdCliente);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    c = new Cliente();
                    c.idCliente = Convert.ToInt32(dr["idCliente"]);
                    c.nombresCliente = dr["nombresCliente"].ToString();
                    c.apellidosCliente = dr["apellidosCliente"].ToString();
                    c.documentoIdentidad = dr["documentoIdentidad"].ToString();
                    c.direccion = dr["direccion"].ToString();
                    c.telefono = dr["telefono"].ToString();

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return c;
        }

        public int RegistrarCliente(Cliente c)
        {
            int a;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spRegistrarCliente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@nombres", c.nombresCliente);
                cmd.Parameters.AddWithValue("@apellidos", c.apellidosCliente);
                cmd.Parameters.AddWithValue("@documento", c.documentoIdentidad);
                cmd.Parameters.AddWithValue("@direccion", c.direccion);
                cmd.Parameters.AddWithValue("@Telefono", c.telefono);
                a = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return a;
        }

        public int ActualizarCliente(Cliente c)
        {
            int a;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spActualizarCliente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idCliente", c.idCliente);
                cmd.Parameters.AddWithValue("@nombres", c.nombresCliente);
                cmd.Parameters.AddWithValue("@apellidos", c.apellidosCliente);
                cmd.Parameters.AddWithValue("@documento", c.documentoIdentidad);
                cmd.Parameters.AddWithValue("@direccion", c.direccion);
                cmd.Parameters.AddWithValue("@Telefono", c.telefono);
                a = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return a;
        }

        public int EliminarCliente(Int32 IdCliente)
        {
            int a;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spEliminarCliente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idCliente", IdCliente);

                a = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return a;


        }

        //Jacinto ---
        public Cliente buscarClientePorDocIdentidad(String documentoIdentidad)
        {
            Cliente objCliente = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spBuscarClientePorDocumento", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("prmDocumentoIdentidad", documentoIdentidad);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    objCliente = obtenerCliente(dr);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return objCliente;
        }

        public Cliente obtenerCliente(SqlDataReader dr)
        {
            Cliente objCliente = new Cliente();
            objCliente.idCliente = Convert.ToInt32(dr["idCliente"]);
            objCliente.nombresCliente = Convert.ToString(dr["nombresCliente"]);
            objCliente.apellidosCliente = Convert.ToString(dr["apellidosCliente"]);
            objCliente.documentoIdentidad = Convert.ToString(dr["documentoIdentidad"]);
            objCliente.direccion = Convert.ToString(dr["direccion"]);
            objCliente.telefono = Convert.ToString(dr["telefono"]);
            objCliente.activo = Convert.ToBoolean(dr["activo"]);

            return objCliente;
        }

        //Narro ---
        public Cliente buscarPorId(int id)
        {
            Cliente cliente = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_buscarClientePorId", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("idCliente", id);
                dr = cmd.ExecuteReader();
                if(dr.Read())
                {
                    cliente = GetDatos(dr);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return cliente;
        }
        Cliente GetDatos(SqlDataReader dr)
        {
            Cliente objCliente = new Cliente();
            objCliente.idCliente = Convert.ToInt32(dr["idCliente"]);
            objCliente.nombresCliente = dr["nombresCliente"].ToString();
            objCliente.apellidosCliente = dr["apellidosCliente"].ToString();
            objCliente.documentoIdentidad = dr["documentoIdentidad"].ToString();
            objCliente.direccion = dr["direccion"].ToString();
            objCliente.telefono = dr["telefono"].ToString();
            objCliente.activo = Convert.ToBoolean(dr["activo"].ToString());
            return objCliente;
        }
    }
}
