<nav class="navbar navbar-expand-lg navbar-light bg-light navbar-colors">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="mx-auto order-0">
        <a class="navbar-brand mx-auto nav-link-color" href="../">Chat!</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".dual-collapse2">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>

    <div class="navbar-collapse collapse w-100 order-3 dual-collapse2">
        <ul class="navbar-nav ml-auto">
            <g:if test="${session?.user?.name}">
                <li class="nav-item">
                    <a class="nav-link nav-link-color">Bienvenido ${session?.user?.name}!</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-color" href="../logout">Deslogear</a>
                </li>
            </g:if>
            <g:else>
                <li class="nav-item">
                    <a class="nav-link nav-link-color" href="../register">Registrarse</a>
                </li>
            </g:else>
        </ul>
    </div>
</nav>