<div class="user-card">
    <div class="item user-image" onclick='startChat(["${session.user.id}", "${user.id}"])'>
        <img src="https://upload.wikimedia.org/wikipedia/commons/d/d3/User_Circle.png" width="40" height="40"/>
    </div>

    <div class="user-name-container" onclick='startChat(["${session.user.id}", "${user.id}"])'>
        <p class="user-name">${user.name}</p>
    </div>
</div>
