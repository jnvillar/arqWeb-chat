<!doctype html>
<html>

<g:render template="/head" model='[title: "Registro"]'></g:render>

<head>
    <asset:stylesheet src="login.css"/>

</head>

<g:render template="/navbar"></g:render>

<body>
<div class="row">
    <div class="col-md-6 offset-md-3">
        <div class="card">
            <div class="row">
                <div class="col-md-10 offset-md-1">
                    <div class="card-body">
                        <h1 class="card-title">Registrarse</h1>

                        <div class="form-group has-danger">
                            <label class="form-control-label" for="name">Nombre</label>
                            <input class="form-control" id="name" type="text">

                            <div class="invalid-feedback" style="display: none"
                                 id="userFeedback">Usuario no registrado</div>
                        </div>

                        <div class="form-group has-danger">
                            <label class="form-control-label" for="pass">Contraseña</label>
                            <input class="form-control" id="pass" type="password">

                            <div class="invalid-feedback" style="display: none"
                                 id="passFeedback">Contraseña incorrecta</div>
                        </div>

                        <div class="form-group" style="text-align: center">
                            <button class="btn btn-primary" id="submit">Submit</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script>

    $('#submit').click(function () {
        var name = $('#name').val();
        var password = $('#pass').val();

        $.post("register", {
            name: name,
            password: password
        }, function (response) {
            if (response.status == 200) {
                window.location.replace("/")
            }
        });
    })

</script>

</html>
