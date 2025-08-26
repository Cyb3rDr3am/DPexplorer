<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DPE formulaire</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"
	rel="stylesheet" />
<script
	src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

</head>
<body>
	<div class="container">
		<div class="left-part-container box">
			<img src="./images/logo1.png" id="logo-bar" alt="logo-dpexplorer"
				style="width: 150px; height: 150px" />
			<form action="SearchForm" method="post">
				<s:submit class="button-left-bar" value="Formulaire de recherche"
					name="actionName" cssStyle="border-top: 2px solid black" />
			</form>
			<form action="submitDPE" method="post">
				<s:submit class="button-left-bar" value="Ajout de données"
					name="actionName" />
			</form>
			<form action="Map" method="post">
				<s:submit class="button-left-bar" value="Carte" name="actionName" />
			</form>
		</div>
		<div class="right-part-container">
			<div class="form-menu-div">
				<form action="rue" method="post">
					<s:submit class="form-menu-container" value="Rue"
						name="actionName" cssStyle="border-top: 2px solid black" />
				</form>
				<form action="ville" method="post">
					<s:submit class="form-menu-container" value="Ville"
						name="actionName" />
				</form>
				<form action="submitDPE" method="post">
					<s:submit class="form-menu-container" value="DPE" name="actionName" />
				</form>
			</div>
			<div class="bottom-container">
				<s:actionerror />
				<s:form action="submitDPE">
					<s:if test="%{dpeForm.id != null}">
						<h1>Modifier un DPE</h1>
					</s:if>
					<s:else>
						<h1>Insérer un DPE</h1>
					</s:else>
					<s:hidden name="dpeForm.id" />
					<s:fielderror fieldName="dpeForm.idCodePostal" />
					<s:select label="Code Postal" name="dpeForm.idCodePostal"
						id="idCodePostal" list="codePostals" listKey="id" listValue="code"
						headerKey="-1" headerValue="--Select--" onChange="loadVilles()"
						cssClass="custom-select" />
					<s:fielderror fieldName="dpeForm.idVille" />
					<s:select label="Ville" name="dpeForm.idVille" id="idVille"
						list="villes" listKey="id" listValue="nom" headerKey="-1"
						headerValue="--Select--" onChange="loadRues()"
						cssClass="custom-select" />
					<s:fielderror fieldName="dpeForm.idRue" />
					<s:select label="Rue" name="dpeForm.idRue" id="idRue" list="rues"
						listKey="id" listValue="nom" headerKey="-1"
						headerValue="--Select--" cssClass="custom-select" />
					<s:fielderror fieldName="dpeForm.classeEnergetique" />
					<s:radio name="dpeForm.classeEnergetique"
						list="classeEnergetiqueList" label="Classe Énergétique"
						cssClass="classeEnergetique" />
					<s:textfield name="dpeForm.consommation" label="Consommation" />
					<s:fielderror fieldName="dpeForm.numeroVoie" />
					<s:textfield name="dpeForm.numeroVoie" label="Numéro de Voie" />
					<s:fielderror fieldName="dpeForm.anneeConstruction" />
					<s:textfield name="dpeForm.anneeConstruction"
						label="Année de Construction" />
					<div class="submit-container">
						<s:submit value="💾 Enregistrer" cssClass="blue-submit-button" />
					</div>
				</s:form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
/**function loadData(url,id,select) {
    fetch('${path}/' + url + id)
    .then(response => response.json())
    .then(data => {
  		console.log(data);
  		while (select.options.length > 1) {
  			select.remove(1);
  		}
  		for (k in data) {
  			let nouvelleOption = document.createElement("option");
  			nouvelleOption.text = data[k]["nom"];
  			nouvelleOption.value = data[k]["id"];
  			select.appendChild(nouvelleOption);
  		    console.log("ici1");
  		}
    })
    .catch(error => console.error('Error:', error));
}**/
function loadData(url, id, select) {
    // Return a new Promise
    return new Promise((resolve, reject) => {
        fetch('${path}/' + url + id)
        .then(response => response.json())
        .then(data => {
            console.log(data);
            while (select.options.length > 1) {
                select.remove(1);
            }
            for (k in data) {
                let nouvelleOption = document.createElement("option");
                nouvelleOption.text = data[k]["nom"];
                nouvelleOption.value = data[k]["id"];
                select.appendChild(nouvelleOption);
                console.log("ici1");
            }
            resolve(); // Resolve the promise when done
        })
        .catch(error => {
            console.error('Error:', error);
            reject(error); // Reject the promise on error
        });
    });
}
async function loadVilles() {
	await loadData("/listVille.action?idCodePostal=",document.getElementById("idCodePostal").value,document.getElementById("idVille"));
	await loadRues();
}
async function loadRues() {
	await loadData("/listRue.action?idVille=",document.getElementById("idVille").value,document.getElementById("idRue"));
}
window.onload = async function() {
	document.querySelectorAll('ul.errorMessage').forEach(el => el.remove());
	await loadVilles();
	<s:if test="%{dpeForm.idVille != null}">
		document.getElementById("idVille").value = ${dpeForm.idVille}
	</s:if>
	await loadRues();
	<s:if test="%{dpeForm.idVille != null}">
		document.getElementById("idRue").value = ${dpeForm.idRue}
	</s:if>
	$('#idVille').select2();
	$('#idCodePostal').select2();
	$('#idRue').select2();
};
</script>
<style>
	.form-menu-div {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 5vh;
            padding-top: 50px;
            margin-bottom: 10px;
        }

        .form-menu-div > form {
        }
        .form-menu-div input {
        	padding: 15px 32px;
  			text-align: center;
  			text-decoration: none;
  			font-size: 16px;
  			width: 500px;
  			height: 100%;
  			display: inline-block;
  			border: 2px solid black;
  			
  		}
/////////////////////////////////////////////////////////////////////
.select2-container {
	width: 100% !important;
}

.custom-select {
	width: 450px;
	height: 40px;
	font-size: 16px;
	padding: 5px;
}

.classeEnergetique[value="A"]+label {
	background-color: #15821F
}

.classeEnergetique[value="B"]+label {
	background-color: #5DBA51
}

.classeEnergetique[value="C"]+label {
	background-color: #ACDE48
}

.classeEnergetique[value="D"]+label {
	background-color: #FBDC31
}

.classeEnergetique[value="E"]+label {
	background-color: #FDAE25
}

.classeEnergetique[value="F"]+label {
	background-color: #D75F15
}

.classeEnergetique[value="G"]+label {
	background-color: #FF0036
}

.classeEnergetique+label {
	font-size: larger;
	border: 2px solid black;
	padding: 5px;
	display: inline-block;
}

.errorMessage {
	color: red;
	background-color: #FFD2D2;
	border: 1px solid red;
	padding: 10px;
	margin-bottom: 5px;
	margin-top: 5px;
	border-radius: 5px;
	font-weight: bold;
	display: block;
}

#submitDPE {
	width: 100%;
	max-width: 600px; margin : auto;
	padding: 20px;
	border: 1px solid #ddd;
	border-radius: 10px;
	background-color: #f9f9f9;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	margin: auto;
}

h1 {
	text-align: center;
	color: red;
}

.blue-submit-button {
	float: right;
	background-color: #007BFF;
	color: white;
	border: none;
	padding: 10px 15px;
	border-radius: 20px;
	cursor: pointer;
	font-size: 16px;
}

.blue-submit-button:hover {
	background-color: #0056b3;
}

.submit-container {
	text-align: right;
	overflow: auto;
}

//////////////////////////////////////////////////////////////////
body, html {
	margin: 0;
	padding: 0;
	font-family: sans-serif;
}

div.container {
	display: flex;
	width: 100%;
}

div.left-part-container {
	width: 150px;
	height: 100%;
	border-right: 3px solid black;
	background-color: #aaa;
	position: fixed;
	left: 0px;
}

div.right-part-container {
	margin-left: 160px;
	margin-right: auto;
	width: calc(100% - 160px);
	align-items: center;
}
div.bottom-container {
	display: flex;
	justify-content: center;
	min-height: 90vh;
}

.button-left-bar {
	width: 100%;
	height: 80px;
	padding: 8px;
	background-color: #eee;
	transition: background-color 0.15s;
	border: none;
	outline: none;
	cursor: pointer;
	font-size: 15px;
	font-weight: bold;
	white-space: pre-line;
	border-bottom: 2px solid black;
}

.button-left-bar:hover {
	background-color: #ccc;
}

.button-left-bar:active {
	background-color: #bbb;
}
</style>
</html>