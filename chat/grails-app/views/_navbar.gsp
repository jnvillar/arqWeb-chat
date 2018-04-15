<nav class="navbar navbar-expand-lg navbar-light bg-light navbar-colors">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="mx-auto order-0">
        <g:if test="${session?.user?.name}">
            <a class="navbar-brand mx-auto nav-link-color" href="../">${session?.user?.name.length() > 30 ? session?.user?.name?.capitalize()[0..30] + "..." : session?.user?.name?.capitalize()}</a>
        </g:if>

        <g:else>
            <a class="navbar-brand mx-auto nav-link-color" href="../">Chat!</a>
        </g:else>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".dual-collapse2">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>

    <div class="navbar-collapse collapse w-100 order-3 dual-collapse2">
        <ul class="navbar-nav ml-auto">
            <g:if test="${session?.user?.name}">
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