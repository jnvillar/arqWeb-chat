<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="mx-auto order-0">
        <a class="navbar-brand mx-auto" href="../">Chat!</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".dual-collapse2">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>

    <div class="navbar-collapse collapse w-100 order-3 dual-collapse2">
        <ul class="navbar-nav ml-auto">
            <g:if test="${session?.user?.name}">
                <li class="nav-item">
                    <a class="nav-link">Bienvenido ${session?.user?.name}!</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="../logout">Deslogear</a>
                </li>
            </g:if>
            <g:else>
                <li class="nav-item">
                    <a class="nav-link" href="../register">Registrarse</a>
                </li>
            </g:else>
        </ul>
    </div>
</nav>