<!doctype html>
<html>

<g:render template="/head" model='[title: "Login"]'></g:render>

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
                        <h1 class="card-title">Login</h1>

                        <div class="form-group">
                            <label class="form-control-label" for="name">Nombre</label>
                            <input class="form-control" id="name" type="text">

                            <div class="invalid-feedback" style="display: none"
                                 id="userFeedback">Usuario no registrado</div>
                        </div>

                        <div class="form-group">
                            <label class="form-control-label" for="pass">Contraseña</label>
                            <input class="form-control" id="pass" type="password">

                            <div class="invalid-feedback" style="display: none"
                                 id="passFeedback">Contraseña incorrecta</div>
                        </div>

                        <div class="form-group" style="text-align: center">
                            <button class="btn btn-primary" id="submit">Entrar</button>
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
        $('#pass').removeClass("is-invalid");
        $('#userFeedback').hide();
        $('#passFeedback').hide();

        var name = $('#name').val();
        var password = $('#pass').val();

        $.post("login", {
            name: name,
            password: password
        }, function (response) {
            if (response.status == 200) {
                window.location.replace("/")
            }
            if (response.status == 405) {
                $('#pass').addClass("is-invalid");
                $('#passFeedback').show();
            }
            if (response.status == 404) {
                $('#name').addClass("is-invalid");
                $('#userFeedback').show();
            }
        });
    })

</script>

</html>
