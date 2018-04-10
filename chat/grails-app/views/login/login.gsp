<!doctype html>
<html>
<head>
    <title>Login</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>

<body>

<div>
<input id="name" type="text">
</div>

<div>
<input id="pass" type="password">
</div>

<div>
<button id="submit">Submit</button>
</div>

</body>

<script>

    $('#submit').click(function(){
        var name = $('#name').val();
        var password = $('#pass').val();

        $.post("login", {
            name: name,
            password: password
        },function(response){
            if(response.status == 200){
                window.location.replace("/")
            }
        });
    })

</script>

</html>
