<!DOCTYPE html>

<!DOCTYPE html >
<html lang="fr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>

<label for="file">Sélectionner le fichier à envoyer</label>
</br>
<input type="file" id="file" name="file" multiple accept=".txt,.csv">
 
</body>
<script type="text/javascript">
document.querySelector('#file').addEventListener('change', function() {

    alert(this.files[0].name);

});
</script>
</html>