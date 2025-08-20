// GET / - Página de inicio pública (landing)
export const publicHome = async (req, res) => {
    try {
        // Verificar si el usuario ya está autenticado
        if (req.usuario) {
            // Si está autenticado, redirigir al dashboard interno
            return res.redirect('/dashboard');
        }

        // Renderizar la landing page pública
        res.render('home/index', { 
            layout: false // No usar el layout principal para la landing
        });
    } catch (error) {
        console.error('Error al cargar página de inicio:', error);
        res.render('home/index', { 
            layout: false 
        });
    }
};

// GET /dashboard - Página interna para usuarios autenticados
export const dashboard = async (req, res) => {
    try {
        // Renderizar el dashboard interno (la página index.ejs existente)
        res.redirect('/'); // Por ahora redirigir a la ruta existente del indexRoutes
    } catch (error) {
        console.error('Error al cargar dashboard:', error);
        res.redirect('/login');
    }
};
