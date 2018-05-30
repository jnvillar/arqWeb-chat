<div id="add-contact" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title">Agregar Contacto</h4>
            </div>

            <div class="row">
                <div class="col-10 offset-md-1">

                    <div class="form-group" style="margin-top: 5%">
                        <label class="form-control-label" for="name">Nombre</label>
                        <input class="form-control" id="name" type="text">

                        <div class="invalid-feedback" style="display: none"
                             id="userFeedback">Usuario no registrado</div>
                    </div>

                    <div class="form-group" style="text-align: center">
                        <button class="btn btn-primary" id="addContact">Agregar</button>
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

    $("#addContact").click(function () {
        $('#userFeedback').hide();
        $('#name').removeClass("is-invalid");

        var name = $("#name").val();
        $.post("user/add",
            {
                name: name
            },
            function (response) {
                loadContacts()
                $('#add-contact').modal('hide');
            }).fail(function (response) {
            $('#name').addClass("is-invalid");
            $('#userFeedback').show();
        });
    })

</script>