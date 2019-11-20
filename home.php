<!DOCTYPE html>

<!DOCTYPE html >
<html lang="fr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="css/style_fac.css" />
</head>

<body>

<div>
	<table id="t01" align="center">
	<td><a href="http://www.cellomet.com"> <img src="images/logo_web.png"> </a>	</td>
	<td ><label id="p02">Pathway</label> <label id="p01">analyzer</label> </td>
	</table>
</div>

<p align="center">Welcome to your favorite pathway analyzer !</p>

</br>

<form action="home.php" method="post" id="option_form">

	<fieldset id="fs01">
	 
	   <p id="p03">Which option do you want for the analysis ? </p>
	     <!-- <input type="radio" name="CSS" value="oui" id="oui"
	     checked="checked" />
	     <label for="oui" class="inline">oui</label>
	     <input type="radio" name="CSS" value="non" id="non" />
	     <label for="non" class="inline">non</label>
		 
	  <label for="utilise">Si oui, les utilisez-vous plutôt : </label> -->
	   <select name="analyse" id="analyse">
	   <option value="meta"> Metabolic</option>
	   <option value="transcri"> Transcriptomic</option>
	   <option value="other"> Other</option>
	   </select>
	</fieldset>

	<p>
		<button class="button" type="submit" form="option_form" value="Envoyer"><span>Launch</span></button>	
	</p>
</form>

</br></br></br></br></br></br></br>

<label for="file">Sélectionner le fichier à envoyer</label>
</br>
<input type="file" id="file" name="file" multiple accept=".txt,.csv">
 
</body>
<script type="text/javascript">
document.querySelector('#file').addEventListener('change', function() {

    alert(this.files[0].name);

});
</script>



<!-- <iframe src="Testing_pdf_output.pdf" width="600" height="800" align="middle"></iframe> -->

</html>