const formulario = document.getElementById("formulario");
const email = document.getElementById("email");
const password = document.getElementById("password");
const confi_passwordInput = document.getElementById("confi_password");

const users = [
    {
        email: "yarelybelenj@gmail.com",
        password: "123"
    },
    {
        email: "yleraydiego@gmail.com",
        password: "0811"
    }
];

const manejoFormulario = (evento) => {
    evento.preventDefault();
    const emai = email.value.trim();
    const passwordd = password.value;
    const confi_password = confi_passwordInput.value;

    const mensaje = passwordd === confi_password ?
        "Contraseñas iguales" :
        "Las contraseñas no coinciden";
    alert(mensaje);

    let userConfirmed = users.find((use) => use.email === emai && use.password === passwordd && passwordd === confi_password);
    if (userConfirmed) {
        alert("Usuario logeado");
    } else {
        alert("Las contraseñas son incorrectas");
    }
};

formulario.addEventListener("submit", manejoFormulario);

function togglePassword(inputField) {
    inputField.type = inputField.type === "password" ? "text" : "password";
}

password.addEventListener("dblclick", () => togglePassword(password));
confi_passwordInput.addEventListener("dblclick", () => togglePassword(confi_passwordInput));
