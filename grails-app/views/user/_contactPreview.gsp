<div class="sort">
    <div class="sort-title">Ordenar</div>

    <div class="sort-type">
        <select class="selectpicker select-option" style="width: 100%">
            <option value="name" <g:if test="${sort == "name"}">selected</g:if>>Nombre</option>
            <option value="city" <g:if test="${sort == "city"}">selected</g:if>>Ciudad</option>
            <option value="age" <g:if test="${sort == "age"}">selected</g:if>>Edad</option>
        </select>
    </div>
</div>

<g:each var="user" in="${users}">
    <div class="user-card contact-card" data-user="${user.name}">

        <div class="user-image">
            <i class="fas fa-user"></i>
        </div>

        <div class="user-name-and-preview">
            <div class="user-name-container">
                <div class="user-name">${user.name.capitalize()}</div>

                <div class="user-info">
                    <div class="user-city">Ciudad:${user.city.abbreviation}</div>

                    <div class="user-age">Edad: ${user.age}</div>
                </div>
            </div>
        </div>

    </div>
</g:each>



<script>
    $('.selectpicker').selectpicker();
</script>


