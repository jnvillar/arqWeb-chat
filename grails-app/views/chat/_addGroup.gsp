<div id="add-group" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title">Nuevo Grupo</h4>
            </div>

            <div class="row">
                <div class="col-10 offset-md-1">

                    <div class="form-group" style="margin-top: 5%">
                        <label class="form-control-label" for="group">Personas (separar por coma)</label>
                        <input class="form-control" id="group" type="text">

                        <div class="invalid-feedback" style="display: none"
                             id="groupFeedback">Algún usuario no esta registrado</div>
                    </div>

                    <div class="form-group" style="text-align: center">
                        <button class="btn btn-primary" id="addGroup">Crear Grupo</button>
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script>

    $("#addGroup").click(function () {
        $('#groupFeedback').hide();
        $('#group').removeClass("is-invalid");

        var names = $("#group").val();

        names = names.replace(/\s/g, '');
        names = names.toLowerCase();
        names = names.split(',');
        names.push("${session.user.name}");

        $.post("chat/start",
            {
                users: JSON.stringify(names)
            },
            function (response) {
                console.log(response);
                loadChats(response.chat.id);
                $('#add-group').modal('hide');
            }).fail(function (response) {
            $('#group').addClass("is-invalid");
            $('#groupFeedback').show();
        });
    })

</script>