/* =====================================================
   BellaSoft - Lógica de la interfaz (JavaScript + DOM)
   Se carga en todas las páginas; cada módulo comprueba que
   existan sus elementos antes de ejecutarse.
   Temas vistos: querySelector / querySelectorAll, eventos
   (click, submit, input, change) y validaciones.
   ===================================================== */

/* ---------- Utilidades ---------- */
const $ = (selector, ambito = document) => ambito.querySelector(selector);
const $$ = (selector, ambito = document) => [...ambito.querySelectorAll(selector)];

/* Muestra un aviso (error o éxito) al inicio de un formulario.
   Se crea con createElement y se reemplaza el anterior si ya existía. */
function mostrarAviso(formulario, texto, tipo = "error") {
    let aviso = $(".aviso", formulario);
    if (!aviso) {
        aviso = document.createElement("div");
        aviso.className = "aviso";
        aviso.setAttribute("role", "alert");
        formulario.prepend(aviso);
    }
    aviso.className = "aviso aviso-" + tipo;
    aviso.textContent = texto;
}

function quitarAviso(formulario) {
    const aviso = $(".aviso", formulario);
    if (aviso) aviso.remove();
}

/* Marca un campo como inválido, lo enfoca y devuelve false (para usar con return) */
function marcarInvalido(formulario, campo, texto) {
    $$(".invalido", formulario).forEach((c) => c.classList.remove("invalido"));
    campo.classList.add("invalido");
    mostrarAviso(formulario, texto, "error");
    campo.focus();
    return false;
}

/* Al escribir o cambiar un campo se limpia su marca de error */
function limpiarInvalidoAlEscribir(formulario) {
    ["input", "change"].forEach((tipo) =>
        formulario.addEventListener(tipo, (evento) => evento.target.classList.remove("invalido"))
    );
}

/* ===================================================== 
   1. INICIO DE SESIÓN (inicio-sesion.html)
   Valida: correo no vacío y con formato válido, contraseña de mínimo 6 caracteres.
   BD: la comparación real con usuarios.password_hash se hará en el servidor.
   ===================================================== */
function iniciarLogin() {
    const formulario = $("#form-login");
    if (!formulario) return;

    const campoEmail = $("#login-email");
    const campoPassword = $("#login-password");
    const cajaError = $("#login-error");
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    function mostrarError(texto, campo) {
        cajaError.textContent = texto;
        cajaError.hidden = false;
        campo.classList.add("invalido");
        campo.focus();
    }

    formulario.addEventListener("submit", (evento) => {
        evento.preventDefault();
        cajaError.hidden = true;
        campoEmail.classList.remove("invalido");
        campoPassword.classList.remove("invalido");

        const email = campoEmail.value.trim();
        const password = campoPassword.value;

        if (email === "") return mostrarError("Escribe tu correo electrónico.", campoEmail);
        if (!regexEmail.test(email)) return mostrarError("El correo no tiene un formato válido.", campoEmail);
        if (password === "") return mostrarError("Escribe tu contraseña.", campoPassword);
        if (password.length < 6) return mostrarError("La contraseña debe tener al menos 6 caracteres.", campoPassword);

        // Validaciones superadas: se continúa al panel principal
        window.location.href = "index.html";
    });

    // Al escribir se quita el aviso de error
    [campoEmail, campoPassword].forEach((campo) =>
        campo.addEventListener("input", () => {
            campo.classList.remove("invalido");
            cajaError.hidden = true;
        })
    );
}

/* =====================================================
   2. FACTURACIÓN (facturacion.html)
   Cada línea: cantidad x precio unitario (data-precio del tratamiento).
   Se recalculan subtotales, subtotal general y total.
   BD: el servidor debe recalcular todo antes de guardar en facturas / factura_detalle.
   ===================================================== */
function formatoPesos(valor) {
    return "$" + Math.round(valor).toLocaleString("es-CO");
}

function iniciarFacturacion() {
    const formulario = $("#form-factura");
    if (!formulario) return;

    const cuerpo = $("#detalle-factura tbody");
    const campoDescuento = $("#descuento");
    const textoSubtotal = $("#resumen-subtotal");
    const textoTotal = $("#resumen-total");

    function recalcular() {
        let subtotal = 0;

        $$(".linea", cuerpo).forEach((linea) => {
            const cantidad = Number($("[name='cantidad[]']", linea).value) || 0;
            const precio = Number($("[name='precio_unitario[]']", linea).value) || 0;
            const subtotalLinea = cantidad * precio;
            $(".subtotal-linea", linea).textContent = formatoPesos(subtotalLinea);
            subtotal += subtotalLinea;
        });

        // El descuento no puede ser negativo ni mayor al subtotal (el total nunca baja de 0)
        let descuento = Math.max(Number(campoDescuento.value) || 0, 0);
        if (descuento > subtotal) {
            descuento = subtotal;
            campoDescuento.value = subtotal;
        }
        textoSubtotal.textContent = formatoPesos(subtotal);
        textoTotal.textContent = formatoPesos(subtotal - descuento);
    }

    // Al elegir un tratamiento se carga su precio; al cambiar la cantidad se recalcula
    cuerpo.addEventListener("change", (evento) => {
        if (evento.target.matches("select")) {
            const linea = evento.target.closest(".linea");
            const opcion = evento.target.selectedOptions[0];
            $("[name='precio_unitario[]']", linea).value = opcion.dataset.precio || 0;
        }
        recalcular();
    });
    cuerpo.addEventListener("input", recalcular);
    campoDescuento.addEventListener("input", recalcular);

    // Agregar línea: se clona la primera y se deja en blanco
    $("#btn-agregar-linea").addEventListener("click", () => {
        const nueva = $(".linea", cuerpo).cloneNode(true);
        $("select", nueva).selectedIndex = 0;
        $("[name='cantidad[]']", nueva).value = 1;
        $("[name='precio_unitario[]']", nueva).value = 0;
        cuerpo.appendChild(nueva);
        recalcular();
    });

    // Quitar línea (siempre debe quedar al menos una)
    cuerpo.addEventListener("click", (evento) => {
        if (!evento.target.matches(".quitar-linea")) return;
        if ($$(".linea", cuerpo).length > 1) {
            evento.target.closest(".linea").remove();
            recalcular();
        }
    });

    // Validaciones al guardar la factura
    limpiarInvalidoAlEscribir(formulario);
    formulario.addEventListener("submit", (evento) => {
        evento.preventDefault();
        const paciente = $("#f-paciente");
        const fecha = $("#f-fecha");
        const lineas = $$(".linea", cuerpo);
        const sinTratamiento = lineas.find((l) => $("select", l).value === "");

        if (paciente.value.trim() === "") return marcarInvalido(formulario, paciente, "Indica el paciente de la factura.");
        if (fecha.value === "") return marcarInvalido(formulario, fecha, "Selecciona la fecha de emisión.");
        if (sinTratamiento) return marcarInvalido(formulario, $("select", sinTratamiento), "Selecciona un tratamiento en cada línea o quita la línea vacía.");
        if (lineas.some((l) => Number($("[name='cantidad[]']", l).value) < 1)) {
            return marcarInvalido(formulario, $("[name='cantidad[]']", lineas.find((l) => Number($("[name='cantidad[]']", l).value) < 1)), "La cantidad mínima es 1.");
        }

        $$(".invalido", formulario).forEach((c) => c.classList.remove("invalido"));
        mostrarAviso(formulario, "Factura válida. Total a cobrar: " + textoTotal.textContent + ".", "exito");
    });

    // Al limpiar el formulario (botón "Nueva") se deja una sola línea y se recalcula
    formulario.addEventListener("reset", () => {
        $$(".linea", cuerpo).slice(1).forEach((l) => l.remove());
        quitarAviso(formulario);
        setTimeout(recalcular, 0);
    });

    recalcular();
}

/* =====================================================
   3. CITAS (citas.html)
   - Valida el formulario (campos, horas, fecha no pasada)
   - Agrega la cita a la tabla, permite editar y cancelar
   - Filtra la tabla por estado y selecciona días del calendario
   BD: citas (INSERT / UPDATE estado = 'Cancelada')
   ===================================================== */
function claseEstado(estado) {
    // "No asistió" -> estado-noasistio (coincide con estilos.css)
    return "estado-" + estado.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/\s+/g, "");
}

function iniciarCitas() {
    const formulario = $("#form-cita");
    if (!formulario) return;

    const cuerpo = $("table.citas tbody");
    const filtro = $("#filtro-estado");
    const botonEnviar = $("button[type='submit']", formulario);
    let filaEnEdicion = null;

    // No se permiten citas en fechas pasadas
    const hoy = new Date();
    const hoyTexto = `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, "0")}-${String(hoy.getDate()).padStart(2, "0")}`;
    $("#fecha").min = hoyTexto;

    const textoSeleccionado = (select) => select.selectedOptions[0].textContent;

    function crearCelda(texto, clase) {
        const td = document.createElement("td");
        td.textContent = texto;
        if (clase) td.className = clase;
        return td;
    }

    function crearFila(datos) {
        const tr = document.createElement("tr");
        tr.append(
            crearCelda(`${datos.inicio} – ${datos.fin}`),
            crearCelda(datos.paciente),
            crearCelda(datos.tratamiento),
            crearCelda(datos.estado, claseEstado(datos.estado))
        );
        const acciones = document.createElement("td");
        acciones.innerHTML = `<div class="acciones">
            <button class="btn-editar" type="button">Editar</button>
            <button class="btn-cancelar" type="button">Cancelar</button></div>`;
        tr.appendChild(acciones);
        return tr;
    }

    function limpiarFormulario() {
        filaEnEdicion = null;
        botonEnviar.textContent = "Agendar cita";
        formulario.reset();
    }

    formulario.addEventListener("submit", (evento) => {
        evento.preventDefault();
        const paciente = $("#paciente");
        const tratamiento = $("#tratamiento");
        const profesional = $("#profesional");
        const fecha = $("#fecha");
        const inicio = $("#hora-inicio");
        const fin = $("#hora-fin");
        const estado = $("#estado");

        if (paciente.value.trim().length < 3) return marcarInvalido(formulario, paciente, "Escribe el nombre o documento del paciente (mínimo 3 caracteres).");
        if (tratamiento.value === "") return marcarInvalido(formulario, tratamiento, "Selecciona un tratamiento.");
        if (profesional.value === "") return marcarInvalido(formulario, profesional, "Selecciona un profesional.");
        if (fecha.value === "") return marcarInvalido(formulario, fecha, "Selecciona la fecha de la cita.");
        if (fecha.value < hoyTexto && !filaEnEdicion) return marcarInvalido(formulario, fecha, "La fecha no puede estar en el pasado.");
        if (inicio.value === "") return marcarInvalido(formulario, inicio, "Indica la hora de inicio.");
        if (fin.value === "") return marcarInvalido(formulario, fin, "Indica la hora de fin.");
        if (fin.value <= inicio.value) return marcarInvalido(formulario, fin, "La hora de fin debe ser posterior a la de inicio.");

        const nueva = crearFila({
            inicio: inicio.value,
            fin: fin.value,
            paciente: paciente.value.trim(),
            tratamiento: textoSeleccionado(tratamiento),
            estado: estado.value,
        });

        if (filaEnEdicion) {
            filaEnEdicion.replaceWith(nueva);
            mostrarAviso(formulario, "Cita actualizada correctamente.", "exito");
        } else {
            cuerpo.appendChild(nueva);
            mostrarAviso(formulario, "Cita agendada correctamente.", "exito");
        }
        limpiarFormulario();
        $$(".invalido", formulario).forEach((c) => c.classList.remove("invalido"));
        aplicarFiltro();
    });

    limpiarInvalidoAlEscribir(formulario);

    // Editar y cancelar (delegación de eventos sobre el tbody)
    cuerpo.addEventListener("click", (evento) => {
        const fila = evento.target.closest("tr");
        if (!fila) return;

        if (evento.target.matches(".btn-cancelar")) {
            if (!confirm("¿Cancelar esta cita?")) return;
            const celdaEstado = fila.children[3];
            celdaEstado.textContent = "Cancelada";
            celdaEstado.className = claseEstado("Cancelada");
            $$("button", fila).forEach((b) => (b.disabled = true));
            aplicarFiltro();
        }

        if (evento.target.matches(".btn-editar")) {
            const [horas, pacienteTxt, tratamientoTxt, estadoTxt] = [...fila.children].map((td) => td.textContent.trim());
            const [inicio, fin] = horas.split("–").map((h) => h.trim());
            $("#paciente").value = pacienteTxt;
            const opcion = [...$("#tratamiento").options].find((o) => o.textContent === tratamientoTxt);
            $("#tratamiento").value = opcion ? opcion.value : "";
            $("#hora-inicio").value = inicio;
            $("#hora-fin").value = fin;
            $("#estado").value = estadoTxt;
            filaEnEdicion = fila;
            botonEnviar.textContent = "Guardar cambios";
            mostrarAviso(formulario, "Editando cita de " + pacienteTxt + ". Completa fecha y profesional y guarda.", "exito");
            formulario.scrollIntoView({ behavior: "smooth" });
        }
    });

    // Filtro por estado
    function aplicarFiltro() {
        if (!filtro) return;
        const elegido = filtro.value;
        $$("tr", cuerpo).forEach((fila) => {
            const estado = fila.children[3].textContent.trim();
            fila.hidden = elegido !== "" && estado !== elegido;
        });
    }
    if (filtro) filtro.addEventListener("change", aplicarFiltro);

    // Calendario: al hacer clic se selecciona el día
    $(".calendar tbody").addEventListener("click", (evento) => {
        const dia = evento.target.closest(".day");
        if (!dia) return;
        $$(".calendar .day.selected").forEach((d) => d.classList.remove("selected"));
        dia.classList.add("selected");
    });
}

/* =====================================================
   4. TRATAMIENTOS (tratamientos.html)
   - Filtra la tabla por texto y por categoría
   - Activa / desactiva un tratamiento con el botón de la fila
   - Valida el formulario y agrega el tratamiento a la tabla
   BD: tratamientos (INSERT / UPDATE activo)
   ===================================================== */
function iniciarTratamientos() {
    const formulario = $("#form-tratamiento");
    if (!formulario) return;

    const cuerpo = $(".tabla-datos tbody");
    const buscador = $("#buscar-tratamiento");
    const filtroCategoria = $("#filtro-categoria");

    function filtrar() {
        const texto = buscador.value.trim().toLowerCase();
        const categoria = filtroCategoria.value;
        let visibles = 0;
        $$("tr", cuerpo).forEach((fila) => {
            const nombre = fila.children[0].textContent.toLowerCase();
            const cat = fila.children[1].textContent;
            const coincide = nombre.includes(texto) && (categoria === "" || cat === categoria);
            fila.hidden = !coincide;
            if (coincide) visibles++;
        });
        $("#conteo-tratamientos").textContent = visibles + (visibles === 1 ? " tratamiento" : " tratamientos");
    }
    buscador.addEventListener("input", filtrar);
    filtroCategoria.addEventListener("change", filtrar);

    // Desactivar / Activar
    cuerpo.addEventListener("click", (evento) => {
        if (!evento.target.matches(".eliminar")) return;
        const fila = evento.target.closest("tr");
        const insignia = $(".badge", fila);
        const activo = insignia.classList.contains("badge-activo");
        insignia.textContent = activo ? "Inactivo" : "Activo";
        insignia.classList.toggle("badge-activo", !activo);
        insignia.classList.toggle("badge-inactivo", activo);
        evento.target.textContent = activo ? "Activar" : "Desactivar";
    });

    // Validar y agregar
    limpiarInvalidoAlEscribir(formulario);
    formulario.addEventListener("submit", (evento) => {
        evento.preventDefault();
        const nombre = $("#t-nombre");
        const categoria = $("#t-categoria");
        const duracion = $("#t-duracion");
        const precio = $("#t-precio");
        const sesiones = $("#t-sesiones");

        if (nombre.value.trim().length < 3) return marcarInvalido(formulario, nombre, "El nombre debe tener al menos 3 caracteres.");
        if (categoria.value === "") return marcarInvalido(formulario, categoria, "Selecciona una categoría.");
        if (!(Number(duracion.value) >= 5)) return marcarInvalido(formulario, duracion, "La duración mínima es de 5 minutos.");
        if (precio.value === "" || Number(precio.value) < 0) return marcarInvalido(formulario, precio, "Escribe un precio base válido (no negativo).");
        if (!(Number(sesiones.value) >= 1)) return marcarInvalido(formulario, sesiones, "Las sesiones recomendadas son mínimo 1.");

        const activo = $("#t-activo").value === "1";
        const fila = document.createElement("tr");
        const datos = [
            nombre.value.trim(),
            categoria.selectedOptions[0].textContent,
            $("#t-descripcion").value.trim() || "—",
            duracion.value + " min",
            formatoPesos(Number(precio.value)),
        ];
        datos.forEach((texto, i) => {
            const td = document.createElement("td");
            td.textContent = texto;
            if (i === 4) td.className = "num";
            fila.appendChild(td);
        });
        fila.insertAdjacentHTML("beforeend", `
            <td><span class="badge ${activo ? "badge-activo" : "badge-inactivo"}">${activo ? "Activo" : "Inactivo"}</span></td>
            <td class="acciones-tabla"><button class="editar" type="button">Editar</button><button class="eliminar" type="button">${activo ? "Desactivar" : "Activar"}</button></td>`);
        cuerpo.appendChild(fila);

        formulario.reset();
        mostrarAviso(formulario, "Tratamiento agregado a la lista.", "exito");
        filtrar();
    });

    // El botón "Nuevo" limpia avisos
    formulario.addEventListener("reset", () => quitarAviso(formulario));

    filtrar();
}

/* =====================================================
   5. PACIENTES (pacientes.html)
   - Busca en la tabla por nombre o documento (al escribir y con el botón)
   - Calcula la edad a partir de la fecha de nacimiento
   - Valida el formulario y agrega el paciente a la tabla
   BD: pacientes (INSERT); la edad NO se guarda, se calcula
   ===================================================== */
function iniciarPacientes() {
    const formulario = $("#form-paciente");
    if (!formulario) return;

    const cuerpo = $(".tabla-pacientes tbody");
    const buscador = $("#buscar-paciente");
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // Búsqueda
    function buscar() {
        const texto = buscador.value.trim().toLowerCase();
        $$("tr", cuerpo).forEach((fila) => {
            const nombre = fila.children[0].textContent.toLowerCase();
            const documento = fila.children[1].textContent.toLowerCase();
            fila.hidden = !(nombre.includes(texto) || documento.includes(texto));
        });
    }
    buscador.addEventListener("input", buscar);
    $(".busqueda button").addEventListener("click", buscar);

    // Edad
    const nacimiento = $("#p-nacimiento");
    const edad = $("#p-edad");
    nacimiento.addEventListener("change", () => {
        if (!nacimiento.value) { edad.value = ""; return; }
        const hoy = new Date();
        const nac = new Date(nacimiento.value);
        let anios = hoy.getFullYear() - nac.getFullYear();
        const faltaCumple = hoy.getMonth() < nac.getMonth() || (hoy.getMonth() === nac.getMonth() && hoy.getDate() < nac.getDate());
        if (faltaCumple) anios--;
        edad.value = anios >= 0 ? anios : "";
    });

    // Validar y agregar
    limpiarInvalidoAlEscribir(formulario);
    formulario.addEventListener("submit", (evento) => {
        evento.preventDefault();
        const nombres = $("#p-nombres");
        const apellidos = $("#p-apellidos");
        const tipoDoc = $("#p-tipo-doc");
        const documento = $("#p-documento");
        const email = $("#p-email");
        const telefono = $("#p-telefono");
        const acepta = $("#p-acepta");

        if (nombres.value.trim() === "") return marcarInvalido(formulario, nombres, "Escribe los nombres del paciente.");
        if (apellidos.value.trim() === "") return marcarInvalido(formulario, apellidos, "Escribe los apellidos del paciente.");
        if (tipoDoc.value === "") return marcarInvalido(formulario, tipoDoc, "Selecciona el tipo de documento.");
        if (!/^\d{5,20}$/.test(documento.value.trim())) return marcarInvalido(formulario, documento, "El documento debe tener solo números (mínimo 5).");
        if (nacimiento.value === "") return marcarInvalido(formulario, nacimiento, "Indica la fecha de nacimiento.");
        if (edad.value === "") return marcarInvalido(formulario, nacimiento, "La fecha de nacimiento no puede ser futura.");
        if (email.value.trim() !== "" && !regexEmail.test(email.value.trim())) return marcarInvalido(formulario, email, "El correo no tiene un formato válido.");
        if (telefono.value.trim() !== "" && !/^\d{7,15}$/.test(telefono.value.trim())) return marcarInvalido(formulario, telefono, "El teléfono debe tener entre 7 y 15 números.");
        if (!acepta.checked) return marcarInvalido(formulario, acepta, "Debe aceptarse el tratamiento de datos personales.");

        // Evita registrar dos veces el mismo documento
        const repetido = $$("tr", cuerpo).some((f) => f.children[1].textContent === documento.value.trim());
        if (repetido) return marcarInvalido(formulario, documento, "Ya existe un paciente con ese documento.");

        const fila = document.createElement("tr");
        const hoy = new Date().toLocaleDateString("es-CO");
        [
            `${nombres.value.trim()} ${apellidos.value.trim()}`,
            documento.value.trim(),
            telefono.value.trim() || "—",
            email.value.trim() || "—",
            hoy,
        ].forEach((texto) => {
            const td = document.createElement("td");
            td.textContent = texto;
            fila.appendChild(td);
        });
        const activo = $("#p-estado").value === "Activo";
        fila.insertAdjacentHTML("beforeend", `
            <td><span class="badge ${activo ? "badge-activo" : "badge-inactivo"}">${activo ? "Activo" : "Inactivo"}</span></td>
            <td class="acciones-tabla"><button class="editar" type="button">Editar</button><button class="eliminar" type="button">Eliminar</button></td>`);
        cuerpo.prepend(fila);

        formulario.reset();
        mostrarAviso(formulario, "Paciente registrado correctamente.", "exito");
    });

    // Eliminar fila (con confirmación)
    cuerpo.addEventListener("click", (evento) => {
        if (evento.target.matches(".eliminar") && confirm("¿Eliminar este paciente de la lista?")) {
            evento.target.closest("tr").remove();
        }
    });

    formulario.addEventListener("reset", () => { quitarAviso(formulario); edad.value = ""; });
}

/* ---------- Arranque ---------- */
document.addEventListener("DOMContentLoaded", () => {
    iniciarLogin();
    iniciarFacturacion();
    iniciarCitas();
    iniciarTratamientos();
    iniciarPacientes();
});
