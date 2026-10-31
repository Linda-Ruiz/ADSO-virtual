// ============================================================
// BellaSoft - script.js
// Este archivo se carga en todas las páginas (al final del body).
// Parte 1: datos y lógica pura (se prueba por consola)
// Parte 2: conexión con el HTML (cada bloque solo corre si existe su formulario)
// ============================================================

// ------------------------------------------------------------
// 1. CONSTANTES Y DATOS (hoy "quemados"; luego vendrán de la BD)
// ------------------------------------------------------------
const NOMBRE_CLINICA = "BellaSoft";
const MODO_PRUEBA = true; // true = muestra pruebas en la consola (F12)

const categorias = { 1: "Facial", 2: "Corporal", 3: "Láser", 4: "Inyectables" };

// Mismos datos que ya muestran tratamientos.html y facturacion.html
const tratamientos = [
    { id: 1, nombre: "Facial",           idCategoria: 1, duracion: 60, precio: 120000, activo: true },
    { id: 2, nombre: "Botox",            idCategoria: 4, duracion: 45, precio: 650000, activo: true },
    { id: 3, nombre: "Depilación láser", idCategoria: 3, duracion: 45, precio: 180000, activo: true },
    { id: 4, nombre: "Peeling químico",  idCategoria: 1, duracion: 50, precio: 240000, activo: false }
];

const pacientes = [
    { id: 1, nombres: "Ana",    apellidos: "Ruiz",    documento: "1002456", estado: "Activo" },
    { id: 2, nombres: "Laura",  apellidos: "Díaz",    documento: "1009876", estado: "Activo" },
    { id: 3, nombres: "María",  apellidos: "López",   documento: "1012456", estado: "Inactivo" }
];

const citas = [
    { id: 1, paciente: "Laura Díaz",    idTratamiento: 1, fecha: "2026-07-19", inicio: "09:00", fin: "10:00", estado: "Confirmada" },
    { id: 2, paciente: "Miguel Molina", idTratamiento: 2, fecha: "2026-07-19", inicio: "10:30", fin: "11:15", estado: "Programada" },
    { id: 3, paciente: "Lola Lolita",   idTratamiento: 3, fecha: "2026-07-19", inicio: "11:45", fin: "12:30", estado: "Programada" }
];

// ------------------------------------------------------------
// 2. FUNCIONES (lógica reutilizable)
// ------------------------------------------------------------
function calcularTotal(precio, cantidad) {
    return precio * cantidad;
}

const formatoPesos = (valor) => "$" + Number(valor).toLocaleString("es-CO");

// Buscar (find) y filtrar (filter)
const buscarTratamiento = (id) => tratamientos.find(t => t.id === Number(id));
const tratamientosActivos = () => tratamientos.filter(t => t.activo);
const tratamientosPorCategoria = (idCategoria) =>
    tratamientos.filter(t => t.idCategoria === Number(idCategoria));

const buscarPacientes = (texto) => {
    const q = texto.trim().toLowerCase();
    return pacientes.filter(p =>
        (p.nombres + " " + p.apellidos).toLowerCase().includes(q) || p.documento.includes(q)
    );
};

// map y reduce
const nombresTratamientos = () => tratamientos.map(t => t.nombre);
const sumarPrecios = (lista) => lista.reduce((suma, item) => suma + item.precio, 0);

// Descuento según sesiones/cantidad (if / else if / else)
function descuentoPorCantidad(cantidad) {
    if (cantidad >= 5) {
        return 0.15;
    } else if (cantidad >= 3) {
        return 0.10;
    } else {
        return 0;
    }
}

// Edad a partir de la fecha de nacimiento (campo p-edad del formulario de pacientes)
function calcularEdad(fechaNacimiento) {
    const hoy = new Date();
    const nacimiento = new Date(fechaNacimiento);
    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const aunNoCumple =
        hoy.getMonth() < nacimiento.getMonth() ||
        (hoy.getMonth() === nacimiento.getMonth() && hoy.getDate() < nacimiento.getDate());
    if (aunNoCumple) {
        edad--;
    }
    return edad;
}

// "09:30" -> 570 (minutos). Sirve para comparar horas
const aMinutos = (hora) => {
    const [h, m] = hora.split(":").map(Number);
    return h * 60 + m;
};

// ¿La nueva cita choca con otra el mismo día? (usa un ciclo for...of)
function hayCruceDeHorario(fecha, inicio, fin) {
    for (const cita of citas) {
        if (cita.fecha !== fecha || cita.estado === "Cancelada") continue;
        const seCruza = aMinutos(inicio) < aMinutos(cita.fin) && aMinutos(fin) > aMinutos(cita.inicio);
        if (seCruza) return cita;
    }
    return null;
}

// ------------------------------------------------------------
// 3. PRUEBAS POR CONSOLA (reto de la sesión 2)
// ------------------------------------------------------------
if (MODO_PRUEBA) {
    console.log("=== " + NOMBRE_CLINICA + ": pruebas de lógica ===");
    console.log("Tratamientos activos:", tratamientosActivos().map(t => t.nombre));
    console.log("Categoría Facial:", tratamientosPorCategoria(1).map(t => t.nombre));
    console.log("Primer tratamiento de 45 min:", tratamientos.find(t => t.duracion === 45).nombre);
    console.log("Nombres:", nombresTratamientos());
    console.log("Suma de precios (todos):", sumarPrecios(tratamientos));
    console.log("Subtotal 2 x Facial:", calcularTotal(120000, 2));
    console.log("Descuento por 3 sesiones:", descuentoPorCantidad(3));
    console.log("Buscar 'laura':", buscarPacientes("laura"));
    console.log("Cruce 10:00-10:45 el 19/07:", hayCruceDeHorario("2026-07-19", "10:00", "10:45"));
    console.log("Tipo de precio:", typeof tratamientos[0].precio, "| tipo de activo:", typeof tratamientos[0].activo);
}

// ============================================================
// PARTE 2: CONEXIÓN CON EL HTML (solo corre en el navegador)
// ============================================================
if (typeof document !== "undefined") {

    // ---------- FACTURACIÓN: líneas, subtotal y total ----------
    const formFactura = document.getElementById("form-factura");
    if (formFactura) {
        const tabla = document.getElementById("detalle-factura");
        const campoDescuento = document.getElementById("descuento");

        const recalcular = () => {
            let subtotal = 0;
            tabla.querySelectorAll(".linea").forEach(linea => {
                const opcion = linea.querySelector("select").selectedOptions[0];
                const precio = Number(opcion.dataset.precio) || 0;
                const cantidad = Number(linea.querySelector("input[name='cantidad[]']").value) || 0;
                linea.querySelector("input[name='precio_unitario[]']").value = precio;
                const subtotalLinea = calcularTotal(precio, cantidad);
                linea.querySelector(".subtotal-linea").textContent = formatoPesos(subtotalLinea);
                subtotal += subtotalLinea;
            });
            const descuento = Number(campoDescuento.value) || 0;
            const total = Math.max(subtotal - descuento, 0);
            document.getElementById("resumen-subtotal").textContent = formatoPesos(subtotal);
            document.getElementById("resumen-total").textContent = formatoPesos(total);
            return { subtotal, descuento, total };
        };

        tabla.addEventListener("change", recalcular);
        tabla.addEventListener("input", recalcular);
        campoDescuento.addEventListener("input", recalcular);

        tabla.addEventListener("click", (e) => {
            if (!e.target.classList.contains("quitar-linea")) return;
            const lineas = tabla.querySelectorAll(".linea");
            if (lineas.length > 1) {
                e.target.closest(".linea").remove();
            } else {
                alert("La factura debe tener al menos una línea.");
            }
            recalcular();
        });

        document.getElementById("btn-agregar-linea").addEventListener("click", () => {
            const nueva = tabla.querySelector(".linea").cloneNode(true);
            nueva.querySelector("select").selectedIndex = 0;
            nueva.querySelector("input[name='cantidad[]']").value = 1;
            tabla.querySelector("tbody").appendChild(nueva);
            recalcular();
        });

        formFactura.addEventListener("reset", () => setTimeout(recalcular, 0));

        formFactura.addEventListener("submit", (e) => {
            e.preventDefault();
            const paciente = document.getElementById("f-paciente").value.trim();
            const fecha = document.getElementById("f-fecha").value;
            const resumen = recalcular();
            if (!paciente || !fecha) {
                alert("Completa paciente y fecha de emisión.");
            } else if (resumen.total <= 0) {
                alert("Agrega al menos un tratamiento a la factura.");
            } else {
                console.log("Factura lista para enviar al servidor:", { paciente, fecha, ...resumen });
                alert("Factura válida. Total: " + formatoPesos(resumen.total));
            }
        });

        recalcular();
    }

    // ---------- CITAS: validar y agregar a la tabla ----------
    const formCita = document.getElementById("form-cita");
    if (formCita) {
        formCita.addEventListener("submit", (e) => {
            e.preventDefault();
            const paciente = document.getElementById("paciente").value.trim();
            const idTratamiento = document.getElementById("tratamiento").value;
            const fecha = document.getElementById("fecha").value;
            const inicio = document.getElementById("hora-inicio").value;
            const fin = document.getElementById("hora-fin").value;
            const estado = document.getElementById("estado").value;

            if (!paciente || !idTratamiento || !fecha || !inicio || !fin) {
                alert("Completa todos los campos obligatorios.");
                return;
            }
            if (aMinutos(fin) <= aMinutos(inicio)) {
                alert("La hora de fin debe ser posterior a la hora de inicio.");
                return;
            }
            const choque = hayCruceDeHorario(fecha, inicio, fin);
            if (choque) {
                alert("Ese horario se cruza con la cita de " + choque.paciente + " (" + choque.inicio + " - " + choque.fin + ").");
                return;
            }

            citas.push({ id: citas.length + 1, paciente, idTratamiento: Number(idTratamiento), fecha, inicio, fin, estado });

            const tratamiento = buscarTratamiento(idTratamiento);
            const fila = document.createElement("tr");
            [inicio + " – " + fin, paciente, tratamiento ? tratamiento.nombre : "", estado].forEach(texto => {
                const td = document.createElement("td");
                td.textContent = texto;
                fila.appendChild(td);
            });
            const tdAcciones = document.createElement("td");
            tdAcciones.innerHTML = '<div class="acciones"><button class="btn-editar" type="button">Editar</button><button class="btn-cancelar" type="button">Cancelar</button></div>';
            fila.appendChild(tdAcciones);
            document.querySelector("table.citas tbody").appendChild(fila);

            console.log("Citas agendadas:", citas);
            formCita.reset();
        });
    }

    // ---------- TRATAMIENTOS: validar y agregar ----------
    const formTratamiento = document.getElementById("form-tratamiento");
    if (formTratamiento) {
        formTratamiento.addEventListener("submit", (e) => {
            e.preventDefault();
            const nombre = document.getElementById("t-nombre").value.trim();
            const idCategoria = Number(document.getElementById("t-categoria").value);
            const duracion = Number(document.getElementById("t-duración").value);
            const precio = Number(document.getElementById("t-precio").value);
            const activo = document.getElementById("t-activo").value === "1";

            if (!nombre || !idCategoria || duracion < 5 || precio < 0 || document.getElementById("t-precio").value === "") {
                alert("Revisa nombre, categoría, duración (mín. 5 min) y precio.");
                return;
            }
            if (tratamientos.some(t => t.nombre.toLowerCase() === nombre.toLowerCase())) {
                alert("Ya existe un tratamiento con ese nombre.");
                return;
            }

            tratamientos.push({ id: tratamientos.length + 1, nombre, idCategoria, duracion, precio, activo });

            const fila = document.createElement("tr");
            [nombre, categorias[idCategoria], document.getElementById("t-descripción").value, duracion + " min", formatoPesos(precio)].forEach((texto, i) => {
                const td = document.createElement("td");
                td.textContent = texto;
                if (i === 4) td.className = "num";
                fila.appendChild(td);
            });
            const tdEstado = document.createElement("td");
            tdEstado.innerHTML = activo ? '<span class="badge badge-activo">Activo</span>' : '<span class="badge badge-inactivo">Inactivo</span>';
            fila.appendChild(tdEstado);
            const tdAcc = document.createElement("td");
            tdAcc.className = "acciones-tabla";
            tdAcc.innerHTML = '<button class="editar" type="button">Editar</button><button class="eliminar" type="button">Desactivar</button>';
            fila.appendChild(tdAcc);
            document.querySelector(".tabla-datos tbody").appendChild(fila);

            console.log("Tratamientos:", tratamientos);
            formTratamiento.reset();
        });
    }

    // ---------- PACIENTES: edad automática y buscador ----------
    const campoNacimiento = document.getElementById("p-nacimiento");
    if (campoNacimiento) {
        campoNacimiento.addEventListener("change", () => {
            const edad = calcularEdad(campoNacimiento.value);
            document.getElementById("p-edad").value = edad >= 0 ? edad : "";
        });
    }

    const campoBuscar = document.getElementById("buscar-paciente");
    if (campoBuscar) {
        campoBuscar.addEventListener("input", () => {
            const q = campoBuscar.value.trim().toLowerCase();
            document.querySelectorAll(".tabla-pacientes tbody tr").forEach(fila => {
                fila.style.display = fila.textContent.toLowerCase().includes(q) ? "" : "none";
            });
        });
    }
}