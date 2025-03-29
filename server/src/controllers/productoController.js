import Productos from "../models/productoModel.js";
import Formulaciones from "../models/formulacionesModel.js";
import GestionFormulaciones from "../models/gestion_formulacionesModel.js";
import MateriaPrima from "../models/materiaPrimaModel.js";




const insertProducto = async (req, res) => {
  try {
    console.log("Datos recibidos:", req.body);

    const { nombre, precio, stock, formulaciones_id } = req.body;

    if (!nombre || !formulaciones_id) {
      return res.status(400).json({ message: "Nombre y Formulación son obligatorios" });
    }

    // Obtener la formulación correspondiente
    const formulacion = await Formulaciones.findByPk(formulaciones_id);
    if (!formulacion) {
      return res.status(404).json({ message: "La formulación seleccionada no existe" });
    }

    // Crear el producto en la base de datos
    const nuevoProducto = await Productos.create({
      nombre,
      precio,
      stock,
      formulaciones_id
    });

    // Obtener los ingredientes de la formulación
    const ingredientes = await GestionFormulaciones.findAll({
      where: { formulacion_id: formulaciones_id }
    });

    // Actualizar stock de materias primas basado en total_producir de la formulación
    for (const ingrediente of ingredientes) {
      const materiaPrima = await MateriaPrima.findByPk(ingrediente.materia_prima_id);
      if (materiaPrima) {
        const cantidadNecesaria = ingrediente.cantidad * formulacion.total_producir;
        if (materiaPrima.stock >= cantidadNecesaria) {
          materiaPrima.stock -= cantidadNecesaria;
          await materiaPrima.save();
        } else {
          console.warn(`No hay suficiente stock de ${materiaPrima.nombre}. Se intentó restar ${cantidadNecesaria}, pero solo hay ${materiaPrima.stock}.`);
          return res.status(400).json({ message: `Stock insuficiente para ${materiaPrima.nombre}` });
        }
      }
    }

    console.log("Producto creado con éxito y stock actualizado");
    res.redirect("/producto");
  } catch (error) {
    console.error("Error al crear el producto:", error);
    res.status(500).json({ message: "Error al agregar producto", error: error.message });
  }
};



// Método para obtener los productos
const getProducto = async (req, res) => {
  try {
    const productos = await Productos.findAll();

    if (productos.length > 0) {
      console.log(`Se encontraron ${productos.length} productos.`);
      res.render("productos/producto", {
        productos: productos,
        mensaje: null,
      });
    } else {
      console.log(`No se encontraron productos.`);
      res.render("productos/producto", {
        productos: [],
        mensaje: "No hay productos registrados.",
      });
    }
  } catch (error) {
    console.error("Error al obtener los productos:", error);
    res.render("productos/producto", {
      productos: [],
      mensaje: "Error al cargar los productos.",
    });
  }
};

// Método para actualizar un producto
const updateProducto = async (req, res) => {
  try {
    const { nombre, precio, stock } = req.body;
    const { id } = req.params;

    if (!id || !nombre) {
      return res.status(400).json({ message: "ID y Nombre son obligatorios" });
    }

    const producto = await Productos.findByPk(id);
    if (!producto) {
      return res.status(404).json({ message: "Producto no encontrado" });
    }

    await producto.update({
      nombre,
      precio,
      stock
    });

    console.log("Producto actualizado con éxito");
    res.redirect("/producto");

  } catch (error) {
    console.error("Error al actualizar el producto:", error);
    res.status(500).json({ message: "Error al actualizar producto", error: error.message });
  }
};

// Método para eliminar un producto
const deleteProducto = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({ message: "ID es obligatorio" });
    }

    const producto = await Productos.findByPk(id);

    if (!producto) {
      return res.status(404).json({ message: "Producto no encontrado" });
    }

    await producto.destroy();

    console.log("Producto eliminado con éxito");
    res.redirect("/producto");
  } catch (error) {
    console.error("Error al eliminar el producto:", error);
    res.status(500).json({ message: "Error al eliminar producto", error: error.message });
  }
};

// Método para renderizar la vista de edición de un producto
const rendUpdateProducto = async (req, res) => {
  try {
    console.log("ID recibido:", req.params.id);

    const producto = await Productos.findByPk(req.params.id);

    if (!producto) {
      console.log("Producto no encontrado en la base de datos");
      return res.status(404).send("Producto no encontrado");
    }

    console.log("Producto seleccionado:", JSON.stringify(producto, null, 2));

    res.render('productos/productoEditar', {
      producto: producto
    });

  } catch (error) {
    console.error("Error al obtener el producto:", error);
    res.status(500).send("Error interno del servidor");
  }
};

// Método para renderizar la vista de agregar un producto
const rendAgregarProducto = async (req, res) => {
    try {
        const formulaciones = await Formulaciones.findAll();
        res.render("productos/productoAgregar", { formulaciones });
    } catch (error) {
        console.error("Error al obtener las formulaciones:", error);
        res.render("productos/productoAgregar", { formulaciones: [], mensaje: "Error al cargar las formulaciones." });
    }
};


export { insertProducto, getProducto, updateProducto, deleteProducto, rendUpdateProducto, rendAgregarProducto };


