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

                        <div class="form-group">
                            <label class="form-control-label" for="name">Nombre</label>
                            <input class="form-control" id="name" type="text">

                            <div class="invalid-feedback" style="display: none"
                                 id="userFeedback">Usuario ya registrado</div>
                        </div>

                        <div class="form-group">
                            <label class="form-control-label" for="pass">Contraseña</label>
                            <input class="form-control" id="pass" type="password">
                            <div class="invalid-feedback" style="display: none"
                                 id="passFeedback">Contraseña vacía</div>
                        </div>

                        <div class="form-group" style="text-align: center">
                            <button class="btn btn-primary" id="submit">Registarse</button>
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
        $('#name').removeClass("is-invalid");
        $('#userFeedback').hide();

        $('#pass').removeClass("is-invalid");
        $('#passFeedback').hide();

        var name = $('#name').val();
        var password = $('#pass').val();

        if(password==""){
            $('#pass').addClass("is-invalid");
            $('#passFeedback').show();
            return
        }

        $.post("register", {
            name: name,
            password: password
        }, function (response) {
            if (response.status == 200) {
                window.location.replace("/")
            }
        }).fail(function (response) {
            $('#name').addClass("is-invalid");
            $('#userFeedback').show();
        });
    })

</script>

</html>
